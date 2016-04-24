TablesCollection = new Mongo.Collection 'tables'

# fields
#   _id
#   name
#   tables[]
#   problems[]
#   parent
#   order

TablesCollection.helpers
    setParent: (parent) ->
        Tables.collection.update({_id: @_id}, {$set: {parent: parent}})
        
Tables =
    findById: (id) ->
        @collection.findOne _id: id
        
    findAll: ->
        @collection.find({}, {sort: {_id: 1}})
        
    addTable: (id, name, tables, problems, parent, order) ->
        @collection.update({_id: id}, {_id: id, name: name, tables: tables, problems: problems, parent: parent, order: order}, {upsert: true})
        for prob in problems
            Problems.findById(prob).addTable(id)
        
    collection: TablesCollection
            
@Tables = Tables
