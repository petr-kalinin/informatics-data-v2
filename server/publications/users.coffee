Meteor.publish 'users', ->
    Users.findAll()

Meteor.publish 'basicUsers', ->
    Users.collection.find({}, {fields: {
            _id: 1,
            name: 1,
            userList: 1,
            level: 1,
            startlevel: 1,
            active: 1,
            ratingSort: 1,
            rating: 1,
            activity: 1
        }})