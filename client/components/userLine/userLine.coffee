Template.userLine.helpers
    activity: ->
        a = Math.floor(@activity / ACTIVITY_THRESHOLD) * ACTIVITY_THRESHOLD
        s = a.toFixed(5)
        s.replace(/\.?0+$/gm,"")

    admin: ->
        isAdmin()
        
Template.userLine.events
    "submit .baseLevel": (event) ->
        Meteor.call("setBaseLevel", @_id, event.target.newLevel.value)
        event.preventDefault()
        false
