ResultsCollection = new Mongo.Collection 'results'

# fields
#   _id
#   user
#   userList
#   table
#   total
#   solved
#   ok 
#   attempts
#   lastSubmitId
#   lastSubmitTime
#   ignored   // for problems only

Results =
    DQconst: -10

    addResult: (user, table, total, solved, ok, attempts, ignored, lastSubmitId, lastSubmitTime) ->
        userList = Users.findById(user).userList
        id = user + "::" + table
        @collection.update({_id: id}, 
                           {_id: id, user: user, userList: userList, table: table, total: total, solved: solved, ok: ok, attempts: attempts, ignored: ignored, lastSubmitId: lastSubmitId, lastSubmitTime: lastSubmitTime}, 
                           {upsert: true})

    findById: (id) ->
        @collection.findOne _id: id
        
    findAll: ->
        @collection.find {}
    
    findByUserListAndTable: (userList, table) ->
        @collection.find {
            userList: userList, 
            table: table
        }, sort: { solved: -1, attempts: 1}
            
    findByUser: (userId) ->
        @collection.find {
            user: userId, 
        }

    findByUserAndTable: (userId, tableId) ->
        @collection.findOne {
            _id: userId + "::" + tableId
        }
        
    collection: ResultsCollection
            
@Results = Results

if Meteor.isServer
    Meteor.startup ->
        Results.collection._ensureIndex
            userList: 1
            table : 1 
            solved: -1
            attempts: 1

        Results.collection._ensureIndex
            user: 1
            table: 1
