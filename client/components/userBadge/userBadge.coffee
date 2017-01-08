Template.userBadge.helpers
    activity: ->
        @activity.toFixed(2)
        
    profileLink: ->
        "/user/" + @_id
        
