@isAdmin = ->
    Meteor.isClient and Meteor.user() and Meteor.user().admin

@isAdminMethod = ->
    Meteor.user() and Meteor.user().admin