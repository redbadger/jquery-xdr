((jQuery) =>
  if @XDomainRequest
    jQuery.ajaxTransport (s) ->
      if s.crossDomain and s.async
        xdr = new XDomainRequest()

        send: (headers, complete) ->
          response = (status, statusText, responses, responseHeaders) ->
            xdr.onload = xdr.onerror = xdr.ontimeout = jQuery.noop
            complete status, statusText, responses, responseHeaders

          xdr.onload = ->
            response 200, 'OK',
              text: xdr.responseText
            , "Content-Type: #{xdr.contentType}"

          if s.timeout
            xdr.ontimeout = -> response 0, 'Timeout'
            xdr.timeout = s.timeout

          if s.dataType
            headerThroughUriParameters = "header_Accept=#{encodeURIComponent(s.dataType)}"
            s.url = s.url + ((if s.url.indexOf('?') is -1 then '?' else '&')) + headerThroughUriParameters

          s.contentType = 'text/plain'
          xdr.open s.type, s.url
          xdr.onprogress = ->
          xdr.send (s.hasContent and s.data) or null
          xdr.onerror = (e) -> response 404, 'Not Found'
          return
        abort: ->
          if xdr
            xdr.onerror = jQuery.noop()
            xdr.abort()
          return
) jQuery
