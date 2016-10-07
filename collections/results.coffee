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
        tableList = Tables.findById(table).descendandTables()
        @collection.find {
            userList: userList, 
            table: {$in: tableList}
        }, sort: { solved: -1, attempts: 1}
            
    findByUserList: (userList) ->
        @collection.find {
            userList: userList
        }, sort: { solved: -1, attempts: 1}
            
    findByUser: (userId) ->
        @collection.find {
            user: userId, 
        }

    findByUserAndTable: (userId, tableId) ->
        key = userId + "::" + tableId
        if not @cache
            return @collection.findOne {
                _id: userId + "::" + tableId
            }
        if not (key of @cache)
            @cache[key] = @collection.findOne {
                _id: userId + "::" + tableId
            }
        return @cache[key]
    
    enableCache: ->
        @cache = {}
        
    disableCache: ->
        @cache = undefined
        
    collection: ResultsCollection
    
    cache: {}
            
@Results = Results

if Meteor.isServer
    Meteor.startup ->
        Results.collection._ensureIndex
            userList: 1
            table : 1 
            solved: -1
            attempts: 1

        Results.collection._ensureIndex
            userList: 1
            solved: -1
            attempts: 1

        Results.collection._ensureIndex
            user: 1
            table: 1
