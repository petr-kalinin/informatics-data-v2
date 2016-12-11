Meteor.methods
    setCfLogin: (userId, cfLogin) ->
        if (!isAdminMethod())
            throw new Meteor.error('Not authorized')
        user = Users.findById(userId)
        user.setCfLogin(cfLogin)