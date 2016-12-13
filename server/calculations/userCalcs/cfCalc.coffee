colors = [[0, "gray"], [1200, "green"], [1400, "#03A89E"], [1600, "blue"], 
         [1900, "#a0a"], [2200, "#bb0"], [2300, "#FF8C00"], [2400, "red"]];

getRating = (user) ->
    href = "http://codeforces.com/api/user.info?handles=" + user.cfLogin
    text = syncDownload(href).content
    #console.log "cf returns ", text
    data = JSON.parse(text)["result"]
    return data[0]["rating"]

getActivityAndProgress = (user) ->
    href = "http://codeforces.com/api/user.rating?handle=" + user.cfLogin
    text = syncDownload(href).content
    #console.log "cf returns ", text
    data = JSON.parse(text)["result"]

    startDate = new Date("2016-09-01")
    change = 0
    contests = 0
    first = true
    for elem in data
        thisDate = new Date(elem["ratingUpdateTimeSeconds"] * 1000)
        #console.log "contest date", thisDate, " (", elem["ratingUpdateTimeSeconds"], ") startDate", startDate
        if (thisDate > startDate) 
            if (not first)  # very first contest has no meaning as start rating is 1500
                change += elem["newRating"] - elem["oldRating"]
            contests += 1
        first = false
    return activity: contests, progress: change

colorByRating = (rating) ->
    color = ""
    for c in colors
        if c[0] > rating
            break
        color = c[1]
    return color

@updateCfRating = (user) ->
    if not user.cfLogin
        return
    rating = getRating(user)
    color = colorByRating(rating)
    activityAndProgress = getActivityAndProgress(user)
    return rating: rating, color: color, activity: activityAndProgress.activity, progress: activityAndProgress.progress
    
    