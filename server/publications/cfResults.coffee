Meteor.publish "lastCfResults", ->
    cfResults.findLastResults(20)