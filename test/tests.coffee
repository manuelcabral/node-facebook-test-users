expect = require('chai').expect

appcredentials = require('./appcredentials')
FacebookTestUsers = require('../src/FacebookTestUsers')

describe 'FacebookTestUsers', ->

  it 'should create an object with App ID and App secret', ->
    facebookTestUsers = new FacebookTestUsers(appcredentials.app_id, appcredentials.app_secret)

  it 'should retrieve an app token', ->
    facebookTestUsers = new FacebookTestUsers(appcredentials.app_id, appcredentials.app_secret)
    facebookTestUsers.getAppToken (err, success) ->
      expect(err).to.not.ok
      expect(success).to.be.ok
      #verificar que app access token esta em success

  it 'should create a Facebook test user', ->
    facebookTestUsers = new FacebookTestUsers(appcredentials.app_id, appcredentials.app_secret)
    facebookTestUsers.create (err, success) ->
      expect(err).to.be.not.ok
      expect(success).to.be.ok
      #verificar que user access token esta em success
      #apagar test user
      
  it 'should delete a Facebook test user'

