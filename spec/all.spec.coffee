lb = require '../lib/linebacker.js'
should = require 'should'
one   = {'one'    : 1}
two   = {'two'    : 2}
three = {'three'  : 3}
four  = {'four'   : 4}
five  = {'five'   : 5}
four  = {'four'   : 4}

describe 'linebacker', ->
  describe 'all', ->
    it "should always apply the first call time argument first", (done) ->
      fn = (first, finish) ->
        first.should.equal one
        if finish and finish is done
          finish()
      lb.middle(fn, two)(one)
      lb.outside(fn, two)(one, done)

    it "should always have self as this context", (done) ->
      fn = (done) ->
        @.should.equal one
        done?()

      lb.blitz(fn, one).bind(two)()
      lb.rush(fn, one).bind(two)()
      lb.coach(fn, one).bind(two)(done)