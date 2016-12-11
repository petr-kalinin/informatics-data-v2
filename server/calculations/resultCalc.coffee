updateResultsForTable = (userId, tableId, dirtyResults) ->
    if not ((userId + "::" + tableId) of dirtyResults)
        return Results.findByUserAndTable(userId, tableId)
    total = 0
    solved = 0
    ok = 0
    attempts = 0
    lastSubmitId = undefined
    lastSubmitTime = undefined
    
    processRes = (res) ->
        total += res.total
        solved += res.solved
        ok += res.ok
        attempts += res.attempts
        if (!lastSubmitId) or (res.lastSubmitId and res.lastSubmitTime > lastSubmitTime)
            lastSubmitId = res.lastSubmitId
            lastSubmitTime = res.lastSubmitTime
    
    table = Tables.findById(tableId)
    for child in table.tables
        res = updateResultsForTable(userId, child, dirtyResults)
        processRes(res)
    for prob in table.problems
        res = updateResultsForProblem(userId, prob, dirtyResults)
        processRes(res)
        
    #console.log "updated result ", userId, tableId, total, solved, ok, attempts, lastSubmitTime
    Results.addResult(userId, tableId, total, solved, ok, attempts, undefined, lastSubmitId, lastSubmitTime)
    return {total: total, solved: solved, ok: ok, attempts: attempts, lastSubmitId: lastSubmitId, lastSubmitTime: lastSubmitTime}

updateResultsForProblem = (userId, problemId, dirtyResults) ->
    if not ((userId + "::" + problemId) of dirtyResults)
        return Results.findByUserAndTable(userId, problemId)
    submits = Submits.findByUserAndProblem(userId, problemId).fetch()
    solved = 0
    ok = 0
    attempts = 0
    ignored = 0
    lastSubmitId = undefined
    lastSubmitTime = undefined
    for submit in submits
        lastSubmitId = submit._id
        lastSubmitTime = submit.time
        if submit.outcome == "IG"
            ignored = 1
            ok = 0
            continue
        # any other result resets ignored flag
        ignored = 0
        if submit.outcome == "DQ"
            ignored = Results.DQconst
            solved = -2
            ok = 0
            break
        else if submit.outcome == "AC"
            solved = 1
            ok = 0
            break
        else if submit.outcome == "OK"
            ok = 1
            continue  # we might have a future AC
        else  if submit.outcome != "CE"
            attempts++
    #console.log "updated result ", userId, problemId, solved, ok, attempts, ignored, lastSubmitId
    Results.addResult(userId, problemId, 1, solved, ok, attempts, ignored, lastSubmitId, lastSubmitTime)
    return {total: 1, solved: solved, ok: ok, attempts: attempts, ignored: ignored, lastSubmitId: lastSubmitId, lastSubmitTime: lastSubmitTime}

@updateResults = (user, dirtyResults) ->
    console.log "updating results for user ", user
    updateResultsForTable(user, Tables.main, dirtyResults)
    
#Meteor.startup ->
#    for u in Users.findAll().fetch()
#        updateResults(u._id)
    