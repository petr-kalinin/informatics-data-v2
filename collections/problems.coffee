ProblemsCollection = new Mongo.Collection 'problems'

# fields
#   _id
#   letter
#   name
#   tables[]

ProblemsCollection.helpers
    addTable: (table) ->
        Problems.collection.update({ _id: @_id }, {$push: { tables: table }})

Problems =
    findById: (id) ->
        @collection.findOne _id: id
        
    findByTable: (table) ->
        @collection.find tables: table

    findAll: ->
        @collection.find {}
        
    addProblem: (id, letter, name) ->
        @collection.update({_id: id}, {_id: id, letter: letter, name: name, tables: []}, {upsert: true})
        
    collection: ProblemsCollection
            
@Problems = Problems
