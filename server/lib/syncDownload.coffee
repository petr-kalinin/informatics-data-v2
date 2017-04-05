Future = Npm.require('fibers/future');

@syncDownload = (url) ->
    console.log 'Retrieving ', url
    fut = new Future();
    request = HTTP.get url, {jar: true, timeout: 10000}, (error, response) ->
        console.log 'Done'
        fut.return response
    return fut.wait();

