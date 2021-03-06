Template.okSubmits.helpers
    allUpdateTime: ->
        Downloads.lastDownloadTime("All")

    ignoredUpdateTime: ->
        Downloads.lastDownloadTime("UntilIgnored")
        
    lastUpdateTime: ->
        Downloads.lastDownloadTime("Last")

    submits: ->
        Submits.findByOutcome("OK")

    acSubmits: ->
        Submits.findLastByOutcome("AC", 100)

    igSubmits: ->
        Submits.findLastByOutcome("IG", 100)

    waResults: ->
        results = Results.findLastWA(100)
        
    user: ->
        user = Users.findById(@user)
        star = ""
        if user.userList == "stud"
            star = "*"
        star + user.name + " (" + user.level + ")"
        
    userHref: ->
        "/user/" + @user
        
    needSubmit: ->
        START_DATE = "2017-06-12"
        startDate = new Date(START_DATE)
        if new Date(@time) < startDate
            return false
        if Problems.findById(@problem)
            return true
        return false
    
    needAcSubmit: ->
        if Problems.findById(@problem)
            return true
        return false
    
    problem: ->
        p = Problems.findById(@problem || @table)
        return p.name
    
    time: ->
        @time || @lastSubmitTime
    
    contests: ->
        p = Problems.findById(@problem || @table)
        contests = ""
        for t in p.tables
            table = Tables.findById(t)
            if table.tables.length == 0
                if contests.length > 0
                    contests = contests + ", "
                contests = contests + table.name
        return contests
                
    href: ->
        problem = (@problem || @table).substr(1)
        url = 'http://informatics.mccme.ru/moodle/mod/statements/view3.php?chapterid='+problem+'&submit&user_id=' + @user
        return url
    
    lastCfResults: -> 
        cfResults.findLastResults(20)
        
    cfTime: ->
        moment(@time).format("YYYY-MM-DD HH:mm")
        
    cfUser: ->
        user = Users.findById(@userId)
        user.name + " (" + user.level + ")"

    cfUserHref: ->
        "/user/" + @userId
        
    cfResultHref: ->
        user = Users.findById(@userId)
        "http://codeforces.com/submissions/" + user.cfLogin + "/contest/" + @contestId
        
    cfRatingStr: ->
        delta = @newRating - @oldRating
        if delta > 0
            delta = "+" + delta
        delta + " (" + @oldRating + " -> " + @newRating + " / " + @place + ")"
