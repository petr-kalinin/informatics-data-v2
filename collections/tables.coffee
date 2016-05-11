TablesCollection = new Mongo.Collection 'tables'

# fields
#   _id
#   name
#   tables[]
#   problems[]
#   parent
#   order

TablesCollection.helpers
    addTable: (id) ->
        Tables.collection.update({ _id: @_id }, {$push: { tables: id }})
        
parentFromParent = (level) ->
    if level == Tables.main
        return undefined
    p = parseLevel(level)
    if p.minor
        return p.major
    else 
        return Tables.main
        
Tables =
    main: "main"

    findById: (id) ->
        @collection.findOne _id: id
        
    findAll: ->
        @collection.find({}, {sort: {_id: 1}})
        
    addTable: (id, name, tables, problems, parent, order) ->
        @collection.update({_id: id}, 
                           {_id: id, name: name, tables: tables, problems: problems, parent: parent, order: order}, 
                           {upsert: true})
        for prob in problems
            Problems.findById(prob).addTable(id)
        if parent
            if not @findById(parent)
                pp = parentFromParent(parent)
                Tables.addTable(parent, parent, [], [], pp, order-1)
            Tables.findById(parent).addTable(id)
        
    collection: TablesCollection
            
@Tables = Tables
