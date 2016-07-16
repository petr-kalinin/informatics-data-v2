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
        
    height: ->
        if @tables.length > 0
            return Tables.findById(@tables[0]).height() + 1
        else
            return 1
        
    expand: ->
        expandedTables = []
        for table in @tables
            subTable = Tables.findById(table)
            subTable.expand()
            expandedTables.push(subTable)
        @tables = expandedTables
        expandedProblems = []
        for problem in @problems
            expandedProblem = Problems.findById(problem)
            expandedProblems.push(expandedProblem)
        @problems = expandedProblems
        
    descendandTables: ->
        result = [@_id]
        for table in @table
            subTable = Tables.findById(table)
            result = result.concat(subTable.descendandTables())
        for problem in @problems
            result.push(problem)
        
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
            console.log prob, id
            Problems.findById(prob).addTable(id)
        if parent
            if not @findById(parent)
                pp = parentFromParent(parent)
                Tables.addTable(parent, parent, [], [], pp, order-1)
            Tables.findById(parent).addTable(id)
        
    collection: TablesCollection
            
@Tables = Tables
