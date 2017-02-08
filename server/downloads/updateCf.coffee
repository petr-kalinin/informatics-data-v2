updateAllCf = ->
    for u in Users.findAll().fetch()
        u.updateCfRating()
        
SyncedCron.add
    name: 'updateCf',
    schedule: (parser) ->
        return parser.text('every 1 hour');
#        return parser.text('every 5 minutes');
    job: -> 
        console.log("updating Cf ratings")
        updateAllCf()
        
#Meteor.startup ->
#    for u in Users.findAll().fetch()
#        u.updateCfRating()
   
