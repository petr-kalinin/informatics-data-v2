Template.okSubmits.helpers
    submits: ->
        Submits.findByOutcome("OK")
        
    user: ->
        Users.findById(@user).name
        
    needSubmit: ->
        START_DATE = "2015-01-01"
        startDate = new Date(START_DATE)
        if new Date(@time) < startDate
            return false
        if Problems.findById(@problem)
            return true
        return false
    
    problem: ->
        p = Problems.findById(@problem)
        return p.name
    
    contests: ->
        p = Problems.findById(@problem)
        contests = ""
        for t in p.tables
            table = Tables.findById(t)
            if table.tables.length == 0
                if contests.length > 0
                    contests = contests + ", "
                contests = contests + table.name
        return contests
                
    href: ->
        url = 'http://informatics.mccme.ru/moodle/mod/statements/view3.php?chapterid='+@problem+'&submit&user_id=' + @user
        return url