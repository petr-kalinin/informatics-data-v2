@isAdmin = ->
    Meteor.isClient and Meteor.Meteor.user() and Meteor.user().admin