class @ControllerWithTitle extends RouteController
    title: ->
        ""

    onAfterAction: ->
        thisTitle = @title()
        if !thisTitle
            thisTitle = "Сводные таблицы"
#        SEO.set title: thisTitle

    #fastRender: true

    action: ->
        if @server
            head = SSR.render('head', {})
            console.log("Before render")
            body = SSR.render(@name(), @data())
            console.log("Done render")
            css = '<link rel="stylesheet" type="text/css" class="__meteor-css__" href="/style.css">\n'
            this.response.end("<html>" + css + head + "<body><div class='container-fluid'>" + body + "</div></body></html>")
        else
            this.render()