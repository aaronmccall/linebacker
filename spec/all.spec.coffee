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
      lb.coach(fn, null, no, two)(one)
      lb.middle(fn, two)(one)
      lb.outside(fn, two)(one, done)

    it "should always have self as `this` context, if self not omitted", (done) ->
      fn = (done) ->
        @.should.equal one
        done?()

      lb.blitz(fn, one).bind(two)()
      lb.rush(fn, one).bind(two)()
      lb.coach(fn, one).bind(two)(done)

    it "`this` context should be changeable, if self omitted", (done) ->
      fn = (done) ->
        @.should.equal two
        done?()

      lb.middle(fn, one).bind(two)()
      lb.outside(fn, one).bind(two)()
      lb.coach(fn).bind(two)(done)
      
  describe 'blitz', ->
    it "should have one as `this` when blitz(fn, one)", (done) ->
        fn = ->
            @.should.equal one
            done()

        lb.blitz(fn, one)()
      
  describe 'rush', ->
    it "should have one as `this` when rush(fn, one)", (done) ->
        fn = ->
            @.should.equal one
            done()

        lb.rush(fn, one)()