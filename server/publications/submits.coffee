Meteor.publish 'submits', ->
    Submits.findAll()

Meteor.publish 'okSubmits', ->
    Submits.findByOutcome("OK")

Meteor.publish 'lastAcSubmits', ->
    Submits.findLastByOutcome("AC", 20)
