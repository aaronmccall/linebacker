var applier, blitz, middle, outside, rush, __lb;
var __slice = Array.prototype.slice;
__lb = function() {
  /*!
    Linebacker
    ==========
    A set of tools to allow defensive programming for callbacks
    */
};
/*
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
  */
applier = function() {
  var apply_middle, args, fn, func, self;
  fn = arguments[0], self = arguments[1], apply_middle = arguments[2], args = 4 <= arguments.length ? __slice.call(arguments, 3) : [];
  if (apply_middle) {
    func = function() {
      var first, iargs;
      first = arguments[0], iargs = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      args.unshift(first);
      return fn.apply(self || this, args.concat(iargs));
    };
  } else {
    func = function() {
      var iargs;
      iargs = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return fn.apply(self || this, iargs.concat(args));
    };
  }
  func.fn = fn;
  func.args = args;
  func.self = self;
  return func;
};
/*
    _**middle**_
    -----
    Applies passed _args_ in the middle, leaving the left side for _first_
    and the right side for all other call-time args
    **Args:**
    _fn {Function}_: the callback to defend
    _args {Multiple}_: the rest of the members of the arguments object
  */
middle = function() {
  var args, fn;
  fn = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
  return applier.apply(null, [fn, null, true].concat(args));
};
/*
    _**rush**_
    -----
    Like middle, but it also sets the **this** context, disrupting call time
    attempts to pass a new **this**
    **Args:**
    _fn {Function}_: the callback to defend
    _self {Object}_: [optional] the this context for the callback
    _args {Multiple}_: the rest of the members of the arguments object
  */
rush = function() {
  var args, fn, self;
  fn = arguments[0], self = arguments[1], args = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
  return applier.apply(null, [fn, self, true].concat(args));
};
/*
    _**outside**_
    -----
    Applies passed _args_ on the right (outside), leaving the left side for _first_
    and the middle for all other call-time args
    **Args:**
    _fn {Function}_: the callback to defend
    _args {Multiple}_: the rest of the members of the arguments object 
  */
outside = function() {
  var args, fn;
  fn = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
  return applier.apply(null, [fn, null, false].concat(args));
};
/*
    _**blitz**_
    -----
    Like outside, but it allows defending the **this** context before call time attempts
    to set a new one.
    **Args:**
    _fn {Function}_: the callback to defend
    _self {Object}_: [optional] the this context for the callback
    _args {Multiple}_: the rest of the members of the arguments object 
  */
blitz = function() {
  var args, fn, self;
  fn = arguments[0], self = arguments[1], args = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
  return applier.apply(null, [fn, self, false].concat(args));
};
module.exports = {
  middle: middle,
  rush: rush,
  outside: outside,
  blitz: blitz,
  coach: applier
};
this.linebacker = exports;
__lb();