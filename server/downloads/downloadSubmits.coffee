class AllSubmitDownloader
    
    constructor: (@baseUrl, @userList, @submitsPerPage, @minPages, @limitPages) ->
        @addedUsers = {}
        @dirtyResults = {}
    
    AC: 'Зачтено/Принято'
    IG: 'Проигнорировано'
    DQ: 'Дисквалифицировано'
    CE: 'Ошибка компиляции'
        
    addedUsers: {}
        
    needContinueFromSubmit: (runid) ->
        true
        
    setDirty: (userId, probid) ->
        @dirtyResults[userId + "::" + probid] = 1
        problem = Problems.findById(probid)
        if not problem
            console.log "unknown problem ", probid
            return
        for table in problem.tables
            t = table
            while true
                t = Tables.findById(t)
                if t._id == Tables.main
                    break
                @dirtyResults[userId + "::" + t._id] = 1
                t = t.parent
        @dirtyResults[userId + "::" + Tables.main] = 1

    processSubmit: (uid, name, pid, runid, prob, date, outcome) ->
        #if uid == "230963"
        #    console.log uid, name, pid, runid, prob, date, outcome
        res = @needContinueFromSubmit(runid)
        if (outcome == @CE)  # completely ignore CEs
            outcome = "CE"
        if (outcome == @AC) 
            outcome = "AC"
        if (outcome == @IG) 
            outcome = "IG"
        if (outcome == @DQ) 
            outcome = "DQ"
        Submits.addSubmit(runid, date, uid, "p"+pid, outcome)
        Users.addUser(uid, name, @userList)
        @addedUsers[uid] = uid
        @setDirty(uid, "p"+pid)
        res
    
    parseSubmits: (submitsTable, canBreak) ->
        submitsRows = submitsTable.split("<tr>")
        result = true
        wasSubmit = false
        for row in submitsRows
            re = new RegExp '<td>[^<]*</td>\\s*<td><a href="/moodle/user/view.php\\?id=(\\d+)">([^<]*)</a></td>\\s*<td><a href="/moodle/mod/statements/view3.php\\?chapterid=(\\d+)&run_id=([0-9r]+)">([^<]*)</a></td>\\s*<td>([^<]*)</td>\\s*<td>[^<]*</td>\\s*<td>([^<]*)</td>', 'gm'
            data = re.exec row
            if not data
                continue
            uid = data[1]
            name = data[2]
            pid = data[3]
            runid = data[4] + "p" + pid
            prob = data[5]
            date = data[6]
            outcome = data[7].trim()
            resultSubmit = @processSubmit(uid, name, pid, runid, prob, date, outcome)
            result = result and resultSubmit
            wasSubmit = true
            if (not result) and canBreak
                break
        return result and wasSubmit
    
    run: ->
        console.log "AllSubmitDownloader::run ", @userList, @submitsPerPage, @minPages, '-', @limitPages
        page = 0
        while true
            submitsUrl = @baseUrl(page, @submitsPerPage)
            submits = syncDownload(submitsUrl)
            submits = submits["data"]["result"]["text"]
            result = @parseSubmits(submits, page >= @minPages)
            if (page < @minPages) # always load at least minPages pages
                result = true
            if not result
                break
            page = page + 1
            if page > @limitPages
                break
        tables = Tables.findAll().fetch()
        for uid,tmp of @addedUsers
            updateResults(uid, @dirtyResults)
            u = Users.findById(uid)
            u.updateChocos()
            u.updateRatingEtc()
            u.updateLevel()
        console.log "Finish AllSubmitDownloader::run ", @userList, @limitPages
            
class LastSubmitDownloader extends AllSubmitDownloader
    needContinueFromSubmit: (runid) ->
        !Submits.findById(runid)

class UntilIgnoredSubmitDownloader extends AllSubmitDownloader
    needContinueFromSubmit: (runid) ->
        res = Submits.findById(runid)?.outcome
        r = !((res == "AC") || (res == "IG"))
        return r

    # Лицей 40
lic40url = (page, submitsPerPage) ->
        'http://informatics.mccme.ru/moodle/ajax/ajax.php?problem_id=0&group_id=5401&user_id=0&lang_id=-1&status_id=-1&statement_id=0&objectName=submits&count=' + submitsPerPage + '&with_comment=&page=' + page + '&action=getHTMLTable'
    # Заоч
zaochUrl = (page, submitsPerPage) ->
    'http://informatics.mccme.ru/moodle/ajax/ajax.php?problem_id=0&group_id=5402&user_id=0&lang_id=-1&status_id=-1&statement_id=0&objectName=submits&count=' + submitsPerPage + '&with_comment=&page=' + page + '&action=getHTMLTable'
    
MSEC_IN_DAY = 24*60*60*1000
    
runDownload = ->
    now = new Date()
    console.log "Starting download"
    if Downloads.lastDownloadTime("any") > now - 1000*60*10
        console.log "Another download in progress, exiting"
        return
    Downloads.setLastDownloadTime("any", now)
    try
        if (Downloads.lastDownloadTime("All") < now - MSEC_IN_DAY) and (now.getUTCHours() <= 3)
            console.log "running All"
            (new AllSubmitDownloader(lic40url, 'lic40', 1000, 1, 1e9)).run()
            (new AllSubmitDownloader(zaochUrl, 'zaoch', 1000, 1, 1e9)).run()
            Downloads.setLastDownloadTime("All", now)
        else if Downloads.lastDownloadTime("UntilIgnored") < now - 2.9*60*1000
            console.log "running UntilIgnored"
            (new UntilIgnoredSubmitDownloader(lic40url, 'lic40', 100, 2, 4)).run()
            (new UntilIgnoredSubmitDownloader(zaochUrl, 'zaoch', 100, 2, 4)).run()
            Downloads.setLastDownloadTime("UntilIgnored", now)
        else if Downloads.lastDownloadTime("Last") < now - 0.9*60*1000
            console.log "running Last"
            (new LastSubmitDownloader(lic40url, 'lic40', 20, 1, 1)).run()
            (new LastSubmitDownloader(zaochUrl, 'zaoch', 20, 1, 1)).run()
            Downloads.setLastDownloadTime("Last", now)
        else
            console.log "not running anything"
    finally
        Downloads.setLastDownloadTime("any", new Date(0))
        
SyncedCron.add
    name: 'downloadSubmits',
    schedule: (parser) ->
        return parser.text('every 30 seconds');
#        return parser.text('every 5 minutes');
    job: -> 
        console.log("1")
        runDownload()
   

Meteor.startup ->
    SyncedCron.start()
#    (new AllSubmitDownloader(lic40url, 'lic40', 1000, 1, 1e9)).run()
    #(new AllSubmitDownloader(zaochUrl, 'zaoch', 40, 1, 1e9)).run()
#    for u in Users.findAll().fetch()
#        tables = Tables.findAll().fetch()
#        for t in tables
#            Results.updateResults(u, t)
#        u.updateChocos()
#        u.updateRatingEtc()
#        u.updateLevel( )
#    console.log Submits.problemResult("208403", {_id: "1430"})
