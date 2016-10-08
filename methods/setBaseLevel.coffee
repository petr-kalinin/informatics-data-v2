Meteor.methods
    setBaseLevel: (userId, newLevel) ->
        if (!isAdminMethod())
            throw new Meteor.error('Not authorized')
        user = Users.findById(userId)
        user.setBaseLevel(newLevel)