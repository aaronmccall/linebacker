lb = require '../lib/linebacker.js'
should = require 'should'
one   = {'one'    : 1}
two   = {'two'    : 2}
three = {'three'  : 3}
four  = {'four'   : 4}
five  = {'five'   : 5}
six   = {'six'    : 6}


describe 'linebacker', ->
  describe 'outside', ->
    it "should apply [two, one] when outside(fn, one)(two)", (done) ->
        fn = (first, last) ->
            first.should.equal  two
            last.should.equal   one
            done()

        lb.outside(fn, one)(two)

    it "should apply [three, one, two] when outside(fn, one, two)(three)", (done) ->
        fn = (first, second, last) ->
            first.should.equal  three
            second.should.equal one
            last.should.equal   two
            done()

        lb.outside(fn, one, two)(three)

    it "should apply [four, two, three, one] when outside(outside(fn, one), two, three)(four)", (done) ->
        fn = (first, second, third, fourth) ->
            first.should.equal  four
            second.should.equal two
            third.should.equal  three
            fourth.should.equal one
            done()

        lb.outside(lb.outside(fn, one), two, three)(four)