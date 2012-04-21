lb = require '../lib/linebacker.js'
should = require 'should'
one   = {'one'    : 1}
two   = {'two'    : 2}
three = {'three'  : 3}
four  = {'four'   : 4}
five  = {'five'   : 5}
four  = {'four'   : 4}

describe 'linebacker', ->
  describe 'middle', ->

    it "should apply 'one' last when only two args", (done) ->
      fn = (first, second) ->
        first.should.equal two
        second.should.equal one
        done()
      func = lb.middle(fn, one)(two)

    it "should apply 'one' in the middle when more than two args", (done) ->
      fn = (first, second, third) ->
        first.should.equal three
        second.should.equal one
        third.should.equal two
        done()
      func = lb.middle(fn, one)(three, two, four)

    it "should apply [three, one, two, four] when middle(middle(fn, one), two)(three, four)", (done) ->
      fn = (first, second, third, fourth) ->
        first.should.equal  three
        second.should.equal one
        third.should.equal  two
        fourth.should.equal four
        done()

      lb.middle(lb.middle(fn, one), two)(three, four)