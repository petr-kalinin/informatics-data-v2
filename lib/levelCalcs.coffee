@parseLevel = (level) ->
    last = level.slice(-1)
    if (last >= '0') and (last <= '9')
        res = { major : level }
    else 
        res = { major : level.slice(0, -1), minor : last }
    console.log "level ", level, " parsed ", res
    res