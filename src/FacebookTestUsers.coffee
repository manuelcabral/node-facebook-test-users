qs = require('querystring')
request = require('request')
async = require('async')

class FacebookTestUsers

    constructor: (@app_id, @app_secret) ->  
        @createdUsers = []

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

            request.post create_query, (e, r, user) =>
                if !e && r.statusCode == 200
                    @createdUsers.push user.id
                    callback(null, user)
                else callback(e || user, null)

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

            request.del delete_query, (e, r, body) =>
                if !e && r.statusCode == 200
                    @createdUsers.filter (userId) -> userId != user_id 
                    callback(null, body)
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

    deleteAll: (callback) ->
        @fetch (err, existing_users) =>
            user_ids = for user in existing_users then user.id
            async.each user_ids, @delete, (err) -> 
                if err? then return callback(err, null)
                callback(null, true)

    deleteAllRecentlyCreated: (callback) ->
        user_ids = @createdUsers
        async.each user_ids, @delete, (err) -> 
            if err? then return callback(err, null)
            callback(null, true)

module.exports = FacebookTestUsers