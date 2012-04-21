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

    func.fn = fn
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
  middle = (fn, args...) -> applier.apply null, [fn, null, yes].concat(args)

  ###
    _**rush**_
    -----
    Like middle, but it also sets the **this** context, disrupting call time
    attempts to pass a new **this**
    **Args:**
    _fn {Function}_: the callback to defend
    _self {Object}_: [optional] the this context for the callback
    _args {Multiple}_: the rest of the members of the arguments object
  ###
  rush = (fn, self, args...) -> applier.apply null, [fn, self, yes].concat(args)

  ###
    _**outside**_
    -----
    Applies passed _args_ on the right (outside), leaving the left side for _first_
    and the middle for all other call-time args
    **Args:**
    _fn {Function}_: the callback to defend
    _args {Multiple}_: the rest of the members of the arguments object 
  ###
  outside = (fn, args...) -> applier.apply null, [fn, null, no].concat(args)

  ###
    _**blitz**_
    -----
    Like outside, but it allows defending the **this** context before call time attempts
    to set a new one.
    **Args:**
    _fn {Function}_: the callback to defend
    _self {Object}_: [optional] the this context for the callback
    _args {Multiple}_: the rest of the members of the arguments object 
  ###
  blitz = (fn, self, args...) -> applier.apply null,  [fn, self, no].concat(args)

  module.exports = 
    middle: middle
    rush: rush
    outside: outside
    blitz: blitz
    coach: applier
  