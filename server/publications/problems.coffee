Meteor.publish 'problems', ->
    Problems.findAll()