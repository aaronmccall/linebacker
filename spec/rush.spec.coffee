lb = require '../lib/linebacker.js'
should = require 'should'
one   = {'one'    : 1}
two   = {'two'    : 2}
three = {'three'  : 3}
four  = {'four'   : 4}
five  = {'five'   : 5}
four  = {'four'   : 4}

describe 'linebacker', ->
  describe 'rush', ->
    it "should have one as this when rush(fn, one)"