###!
Linebacker
==========
A set of tools to allow defensive programming for callbacks
###

###
  _**applier**_
  -----
  Defends callback _fn_ by setting the **this** context (_self_),
  pre-set arguments (_args_)
  **Args:**
  - _fn {Function}_: the callback to defend
  - _self {Object}_: [optional] the this context for the callback
  - _apply_middle {Boolean}_: if true, _args_ are applied in the middle, 
   else outside (right) 
  - _args {Multiple}_: [optional] pre-set arguments to apply to the callback
###
applier = (fn, self, apply_middle, args...) ->

  if apply_middle
    func = (first, iargs...) ->
      args.unshift first
      fn.apply(self or @, args.concat(iargs))
  else
    func = (iargs...) -> fn.apply(self or @, iargs.concat(args))

  func.orig = fn
  func.args = args
  func.self = self

  func      

###
  _**middle**_
  -----
  Applies passed _args_ in the middle, leaving the left side for _first_
  and the right side for all other call-time args
  **Args:**
  _fn {Function}_: the callback to defend
  _args {Multiple}_: the rest of the members of the arguments object
###
middle = (fn, args...) -> applier fn, null, yes, args

###
  _**outside**_
  -----
  Applies passed _args_ on the right (outside), leaving the left side for _first_
  and the middle for all other call-time args
  **Args:**
  _fn {Function}_: the callback to defend
  _args {Multiple}_: the rest of the members of the arguments object 
###
outside = (fn, args...) -> applier fn, null, no, args

###
  _**strong**_
  -----
  Like outside, but it allows setting **this** context before call time
###
strong = (fn, self, args...) -> applier fn, self, no, args

exports =
  middle: middle
  mike: middle
  outside: outside
  will: outside
  strong: strong
  sam: strong
  coach: applier