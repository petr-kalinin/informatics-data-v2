class @ControllerWithTitle extends RouteController
    title: ->
        ""

    onAfterAction: ->
        thisTitle = @title()
        if !thisTitle
            thisTitle = "Сводные таблицы"
#        SEO.set title: thisTitle

    fastRender: true

    action: ->
        if @server
            head = SSR.render('head', {})
            body = SSR.render(@name(), @data())
            css = '<link rel="stylesheet" type="text/css" class="__meteor-css__" href="/merged-stylesheets.css">\n'
            this.response.end("<html>" + css + head + "<body><div class='container-fluid'>" + body + "</div></body></html>")
        else
            this.render()