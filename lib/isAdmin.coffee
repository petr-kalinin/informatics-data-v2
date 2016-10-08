@isAdmin = ->
    Meteor.isClient and Meteor.user() and Meteor.user().admin