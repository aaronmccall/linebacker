lb = require '../lib/linebacker.js'
should = require 'should'
one   = {'one'    : 1}
two   = {'two'    : 2}
three = {'three'  : 3}
four  = {'four'   : 4}
five  = {'five'   : 5}
six   = {'six'    : 6}


describe 'linebacker', ->
  describe 'coach', ->
    it "should apply 'one' at the end if apply_middle is false", (done) ->
      fn = (first, second) -> 
        first.should.equal two
        second.should.equal one
        done()

      func = lb.coach(fn, null, no, one)

      func(two)

    it "should apply 'one' last if apply_middle is true when only two args", (done) ->
      fn = (first, second) ->
        first.should.equal two
        second.should.equal one
        done()
      lb.coach(fn, null, yes, one)(two)

    it "should apply 'one' in the middle if apply_middle is true when more than two args", (done) ->
      fn = (first, second, third) ->
        first.should.equal three
        second.should.equal one
        third.should.equal two
        done()
      lb.coach(fn, null, yes, one)(three, two, four)

    it "should have six as `this` when six is self", (done) ->
      fn = (done) ->
        @.should.equal six
        done?()
      func = lb.coach(fn, six)

      # No monkey business just call it
      func()
      # Try to override this via call
      func.call(five)
      # Get serious! Bind it.
      func.bind(five)(done)
