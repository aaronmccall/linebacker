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


    ```javascript
    // A simple node example
    
    // In players.js
    exports.getById = function (id, next) {
        // if player is found, next is called with null as 1st arg, data as 2nd
        db.players.getById(id, next)
    }
    
    exports.update = function (player, data, next) {
        player.set(data)
        // calls next upon failure or sucess
        // upon failure only arg is an Error
        // upon success 1st arg is null, 2nd is result data
        player.save(next)
    }
    // A typical server.js
    var players = require('players')

    app.post('/players/:id', function (req, res) {
        var data = req.body || {}
          , id = req.params.id

        players.getById(id, function (error, player) {
            if (error) return res.render(error.template || 'error', {error: error, data: data})
            players.update(player, data, function (error, result)) {
                if (error) return res.render(error.template || 'error', error)
                res.render('player', {data: result})
            })
        })
    })

    // In server.js with linebacker
    var players = require('players')
    function respond(error, data, template, res) {
        if (error) {
            return res.render(error.template || 'error', error)
        }
        res.render(template || 'default', data)
    }

    app.post('/players/:id', function (req, res) {
        var responder = lb.coach(respond, null, false, 'player', res)
          , player_updater = lb.coach(players.update, null, false, req.body || {}, responder)
          
          players.getById(req.params.id, player_updater)
    });
    
    ```