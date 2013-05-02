node-facebook-test-users
========================

Node module to create, delete and fetch Facebook test users

This node module has the following methods:
    getAppToken(callback)
    create(callback)
    delete(user_id, callback)
    fetch(callback)

## Tests

To run the tests, create a file `tests/appcredentials.coffee` like the following:

    exports.app_id = YOUR_APP_ID
    exports.app_secret = YOUR_APP_SECRET