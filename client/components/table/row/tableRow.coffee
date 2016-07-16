Template.tableRow.helpers

Template.result.helpers
    text: ->
        result = Results.findByUserAndTable(@user._id, @table._id)
        if result.ignored == Results.DQconst
            ""
        else if result.solved > 0 or result.ok > 0
            "+" + (if result.attempts > 0 then result.attempts else "")
        else if result.attempts > 0
            "-" + result.attempts
        else
            " "
            
    class: ->
        result = Results.findByUserAndTable(@user._id, @table._id)
        if result.solved > 0
            "ac"
        else if result.ignored > 0
            "ig"
        else if result.ok > 0
            "ok"
        else if result.ignored == Submits.DQconst
            "dq"
        else if result.attempts > 0
            "wa"
        else
            undefined
            
Template.totalResult.helpers
    result: ->
        solved = 0
        ok = 0
        total = 0
        if @table
            tables = [@table]
        else
            tables = @tables
        for table in tables
            res = Results.findByUserAndTable(@user._id, table._id)
            solved += res.solved
            ok += res.ok
            total += res.total
        solved + (if ok > 0 then " + " + ok else "") + " / " + total
    
Template.attempts.helpers
    result: ->
        attempts = 0
        for table in @tables
            res = Results.findByUserAndTable(@user._id, table._id)
            attempts += res.attempts
        return attempts
    
Template.tableRow.events
#    'click .userName': (e,t) ->
#        Session.set("activeUser", t.data.result.user)
        
    'dblclick .userName': (e,t) ->
        url = "http://informatics.mccme.ru/moodle/user/view.php?id=" + t.data.result.user
        window.open(url, '_blank')

Template.result.events
    'dblclick .res': (e,t) ->
        problem = @table._id.substr(1)
        result = Results.findByUserAndTable(@user._id, @table._id)
        runId = result.lastSubmitId
        runSuff = ''
        if runId
            runSuff = '&run_id=' + runId
        if e.ctrlKey
            url = 'http://informatics.mccme.ru/moodle/mod/statements/view3.php?chapterid=' + problem + '&submit&user_id=' + @user._id
        else
            url = 'http://informatics.mccme.ru/moodle/mod/statements/view3.php?chapterid=' + problem + runSuff
        window.open(url, '_blank')
