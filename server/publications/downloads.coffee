Meteor.publish 'downloads', ->
    Downloads.findAll()
