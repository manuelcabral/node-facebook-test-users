qs = require('querystring')
request = require('request')

class FacebookTestUsers

    constructor: (@app_id, @app_secret) -> 

    getAppToken: (callback) ->
        if @app_token then callback(null, @app_token)
        else @fetchAppToken(callback)

    fetchAppToken: (callback) ->
        app_login =
            url: 'https://graph.facebook.com/oauth/access_token'
            qs: 
                redirect_uri: "http://localhost"
                client_id: @app_id
                client_secret: @app_secret
                grant_type: "client_credentials"

        request.get app_login, (e, r, body) =>
                if !e && r.statusCode == 200
                    @app_token = qs.parse(body).access_token
                    callback(null, @app_token)
                else
                    callback(e || body, null)

    create: (callback) ->
        @getAppToken (e, app_token) =>
            create_query =
                url: "https://graph.facebook.com/#{@app_id}/accounts/test-users?"
                qs:
                    permissions: "read_stream"
                    access_token: app_token 
                json: true

            request.post create_query, (e, r, body) ->
                if !e && r.statusCode == 200 then callback(null, body)
                else callback(e || body, null)

    validateUserToken: (user_token, callback) ->
        validate_query =
            url: "https://graph.facebook.com/app/?"
            qs:
                access_token: user_token 
            json: true

        request.get validate_query, (e, r, body) ->
            if !e && r.statusCode == 200 then callback(null, body)
            else callback(e || body, null)

    delete: (user_id, callback) =>
        @getAppToken (e, app_token) =>
            delete_query =
                url: "https://graph.facebook.com/" + user_id + "?"
                qs:
                    access_token: app_token
                json: true

            request.del delete_query, (e, r, body) ->
                if !e && r.statusCode == 200 then callback(null, body)
                else callback(e || body, null)

    fetch: (callback) ->
        @getAppToken (e, app_token) =>
            access_query = 
                url: "https://graph.facebook.com/" + @app_id + "/accounts/test-users?"
                qs:
                    access_token: app_token 
                json: true

            request.get access_query, (e, r, body) ->
                if !e && r.statusCode == 200 then callback(null, body.data)
                else callback(e || body, null)

module.exports = FacebookTestUsers