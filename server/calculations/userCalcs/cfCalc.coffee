colors = [[0, "gray"], [1200, "green"], [1400, "#03A89E"], [1600, "blue"], 
         [1900, "#a0a"], [2200, "#bb0"], [2300, "#FF8C00"], [2400, "red"]];

@updateCfRating = (user) ->
    if not user.cfLogin
        return
    href = "http://codeforces.com/api/user.info?handles=" + user.cfLogin
    text = syncDownload(href).content
    data = JSON.parse(text)["result"]
    rating = data[0]["rating"]
    color = ""
    for c in colors
        if c[0] > rating
            break
        color = c[1]
    return [rating, color]
    
    