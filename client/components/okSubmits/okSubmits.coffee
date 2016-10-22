Template.okSubmits.helpers
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
        user.name + " (" + user.level + ")"
        
    userHref: ->
        "/user/" + @user
        
    needSubmit: ->
        START_DATE = "2016-10-13"
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