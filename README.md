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

### A simple browser example

- app.js (typical)
    ```javascript
    //Set the 3 possible state for the accordion
    (function ($) {
      var active

      function setActive(newState) {
          // store our new state as current state
          active = newState

          // make the UI reflect our new current state
          if (active === 'top') {
            $('#substream, .event_listing, .events header').slideDown()
            $('#submit').addClass('down')
            $('#submitEvent').slideUp()
          } else if (active === 'bottom') {
            $('#submitEvent').slideDown()
            $('#event_submit').addClass('down')
            $('#substream, .event_listing, .events header').slideUp()
          } else {
            $('#submit, #event_submit').removeClass('down')
            $('#submitEvent, #substream').slideUp()
            $('.event_listing, .events header').slideDown()
          }
      }

      // State if they add a post
      $('#post_submit').click(function () {
        if (active === 'top') {
            setActive('')
        } else {
            setActive('top')
        }
        return false
      })

      //State if they add a event
      $('#event_submit').click(function () {
        if (active === 'bottom') {
          setActive('')
        } else {
          setActive('bottom')
        }
        return false
      })
    })(jQuery)
    ```
- app.js (with linebacker)
    ```javascript
    //Set the 3 possible state for the accordion
    (function ($, lb) {
        var active
          , form_sections = $('#substream, .event_listing, .events header, #submitEvent')
          , form_buttons = $('#submit, #event_submit')
          , activate = {
                top: lb.outside( setActive, 'top'                       // newState = top
                               , form_sections.not('#submitEvent')      // slide down
                               , form_sections.filter('#submitEvent')   // slide up
                               , form_buttons.filter('#submit'), 'add'))// add .down
              , bottom: lb.outside( setActive, 'bottom'
                                  , form_sections.filter('#submitEvent')
                                  , form_sections.not('#submitEvent')
                                  , form_buttons.filter('#event_submit'), 'add')
              , none: lb.outside( setActive, ''
                                , form_sections.filter('.events_listing, .events header')
                                , form_sections.not('.events_listing, .events header')
                                , form_buttons, 'remove')
            }

        function activate(event, section) {
          if (section === active) return activate['none']()
          if (section in activate) activate[section]()
        }

        function setActive(newState, slide_down, slide_up, down_els, down_op) {
          // store our new state as current state
          active = newState
          if (slide_down) slide_down.slideDown()
          if (slide_up) slide_up.slideUp()
          if (down_els && down_op) down_els[down_op+'Class']('.down')
        }

        // State if they add a stream post
        $('#submit').click(lb.outside(activate, 'top'))

        //State if they add a event
        $('#event_submit').click(lb.outside(activate, 'bottom'))
    })(jQuery, linebacker)
    ```