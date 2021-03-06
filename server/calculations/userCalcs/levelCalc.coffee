@calculateLevel = (user, baseLevel, lastDate) ->
    #console.log "lastdate=", lastDate
    for bigLevel in [1..10]
        for smallLevel in ["А", "Б", "В", "Г"]
            tableId = bigLevel + smallLevel
            level = tableId
            table = Tables.findById(tableId)
            if not table
                continue
            probNumber = 0
            probAc = 0
            for subTableId in table.tables
                subTable = Tables.findById(subTableId)
                if not subTable
                    continue
                for prob in subTable.problems
                    if subTable.name[4] != "*"
                        probNumber++
                    result = Results.findByUserAndTable(user, prob)
                    if not result
                        continue
                    if result.solved == 0
                        continue
                    submitDate = new Date(result.lastSubmitTime)
                    #console.log "submitDate=", submitDate
                    if submitDate >= lastDate
                        #console.log "skipping submit"
                        continue
                    probAc++
            needProblem = probNumber
            if smallLevel == "В"
                needProblem = probNumber * 0.5
            else if smallLevel == "Г"
                needProblem = probNumber * 0.3333
            if (probAc < needProblem) and ((!baseLevel) or (baseLevel <= level))
                console.log user, level
                return level
    return "inf"
    
Meteor.startup ->
#    for u in Users.findAll().fetch()
#        #u = Users.findById("62906")
#        u.updateLevel()
#        console.log u.name, u.level, u.startLevel
