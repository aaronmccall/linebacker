# What is Linebacker?

Linebacker is a set of tools to defend against anonymous callback syndrome
and other ailments of both node.js and browser javascript developers. It does
this while respecting the idiom of the environment: leaving the first argument
to always be set at call time with error (in node) or event (if in browser).

## What are the tools?

1. coach: Defends callback _fn_ by setting the **this** context (_self_),
    pre-set arguments (_args_)

    **Args:**
    - _fn {Function}_: the callback to defend
    - _self {Object}_: [optional] the this context for the callback
    - _apply_middle {Boolean}_: if true, _args_ are applied in the middle, 
     else outside (right) 
    - _args {Multiple}_: [optional] pre-set arguments to apply to the callback

2. middle: Applies passed _args_ in the middle, leaving the left side for _first_
    and the right side for all other call-time args

    **Args:**
    - _fn {Function}_: the callback to defend
    - _args {Multiple}_: the rest of the members of the arguments object

3. outside: Applies passed _args_ on the right (outside), leaving the left side for _first_
    and the middle for all other call-time args

    **Args:**
    - _fn {Function}_: the callback to defend
    - _args {Multiple}_: the rest of the members of the arguments object 


### A simple node example

- players.js
    ```javascript
    var Player = require('models/player').Player

    exports.getById = function (id, next) {
        // if player is found, hydrate Player instance and pass to next
        db.players.getById(id, function (err, player_data) {
            if (err) return next(err)
            next(null, new Player(player_data))
        })
    }
    
    exports.update = function (player, data, next) {
        player.set(data)
        // calls next upon failure or sucess
        // upon failure only arg is an Error
        // upon success 1st arg is null, 2nd is updated Player instance
        player.save(next)
    }
    ```

- server.js (typical)
    ```javascript

    var players = require('players')

    app.get('/players/:id', function (req, res) {

        players.getById(req.params.id, function (error, player) {
            if (error) return res.render(error.template || 'error', error)
            res.render('player', player)
        })
    })

    app.post('/players/:id', function (req, res) {
        var data = req.body || {}

        players.getById(req.params.id, function (error, player) {
            if (error) return res.render(error.template || 'error', error)
            players.update(player, data, function (error, result)) {
                if (error) return res.render(error.template || 'error', error)
                res.render('player', result)
            })
        })
    })
    ```

- server.js (with linebacker)
    ```javascript
    var players = require('players')
      , lb = require('linebacker')

    function respond(error, data, template, res) {
        if (error) return res.render(error.template || 'error', error)
        res.render(template || 'default', data)
    }

    app.get('/players/:id', function (req, res) {
        players.getById(req.params.id, lb.outside(respond, 'player', res))
    })

    app.post('/players/:id', function (req, res) {
        var data = req.body || {}
          , player_updater = lb.outside(players.update, data, 
                                        lb.outside(respond, 'player', res))
          players.getById(req.params.id, player_updater)
    });
    
    ```