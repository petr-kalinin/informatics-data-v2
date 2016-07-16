Template.solvedByWeekTable.helpers
    users: ->
        Users.findByList("" + this)
