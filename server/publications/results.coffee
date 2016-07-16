Meteor.publish 'results', ->
    Results.findAll()
    
Meteor.publish 'resultsForUserList', (userList)->
    Results.findByUserList(userList)

Meteor.publish 'resultsForUserListAndTable', (userList, table)->
    Results.findByUserListAndTable(userList, table)

Meteor.publish 'resultsForUser', (user)->
    Results.findByUser(user)
