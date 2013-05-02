expect = require('chai').expect
async = require('async')
request = require('request')

appcredentials = require('./appcredentials')
FacebookTestUsers = require('../src/FacebookTestUsers')

describe 'FacebookTestUsers', ->

  facebookTestUsers = null

  before -> 
    facebookTestUsers = new FacebookTestUsers(appcredentials.app_id, appcredentials.app_secret)

  it 'should retrieve an app token', (done) ->
    facebookTestUsers.getAppToken (err, success) ->
      expect(err).to.not.ok
      expect(success).to.be.ok
      done()

  it 'should not retrieve an app token', (done) ->
    facebookTestUsersUndefined = new FacebookTestUsers("", "")
    facebookTestUsersUndefined.getAppToken (err, success) ->
      expect(err).to.be.ok
      expect(success).to.not.be.ok
      done()

  it 'should create a Facebook test user', (done) ->
    facebookTestUsers.create (err, user) ->
      expect(err).to.not.ok
      expect(user).to.be.ok
      expect(user.id).to.be.ok
      expect(user.access_token).to.be.ok

      facebookTestUsers.validateUserToken user.access_token, (err, body) ->
        expect(err).to.not.ok
        expect(body).to.be.ok

        facebookTestUsers.delete user.id, (err, success) -> 
          done()
        
  it 'should delete a Facebook test user', (done) ->
    facebookTestUsers.create (e, user) ->
      facebookTestUsers.delete user.id, (err, success) -> 
        expect(err).to.be.not.ok
        expect(success).to.be.ok
        done()

  it 'should retrieve 2 Facebook test users', (done) ->
    async.times 2,
      ((n, next) ->
        facebookTestUsers.create(next)),
      (e, users) ->
        facebookTestUsers.fetch (err, fetched_users) ->
          user_ids = for user in fetched_users then user.id
          for user in users then expect(user_ids).to.include(user.id)

          async.each user_ids, facebookTestUsers.delete, (err) ->
              done()