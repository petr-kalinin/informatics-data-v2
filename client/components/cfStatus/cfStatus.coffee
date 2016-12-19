Template.cfStatus.helpers
    cfProgressFormatted: ->
        if @cfProgress > 0
            "+" + @cfProgress.toFixed(1)
        else
            @cfProgress.toFixed(1)
            
    cfProgressColor: ->
        if @cfProgress > 10
            "#00aa00"
        else if @cfProgress < -10
            "#aa0000"
        else
            "inherit"

    cfActivityFormatted: ->
        @cfActivity.toFixed(1)