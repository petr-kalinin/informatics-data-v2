updateAllCf = ->
    for u in Users.findAll().fetch()
        u.updateCfRating()
        
SyncedCron.add
    name: 'updateCf',
    schedule: (parser) ->
        return parser.text('at 3:00');
#        return parser.text('every 5 minutes');
    job: -> 
        console.log("updating Cf ratings")
        updateAllCf()
   
