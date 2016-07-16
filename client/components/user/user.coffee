Template.user.helpers
    tables: ->
        main = Tables.findById(Tables.main)
        res = []
        for table in main.tables
            if table == "1"
                res.push (Tables.findById(id).expand() for id in ["1А", "1Б"])
                res.push (Tables.findById(id).expand() for id in ["1В", "1Г"])
            else 
                result = Results.findByUserAndTable(@_id, table)
                if result.attempts > 0
                    res.push (Tables.findById(id).expand() for id in Tables.findById(table).tables)
        res
        
    activity: ->
        @activity.toFixed(2)
        
    choco: ->
        @choco
        
    lic40: ->
        @userList == "lic40"
        
        
