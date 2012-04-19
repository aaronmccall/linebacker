/*!
Linebacker
==========
A set of tools to allow defensive programming for callbacks
*/
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
var applier, exports, middle, outside, strong;
var __slice = Array.prototype.slice;
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
  func.orig = fn;
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
  return applier(fn, null, true, args);
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
  return applier(fn, null, false, args);
};
/*
  _**strong**_
  -----
  Like outside, but it allows setting **this** context before call time
*/
strong = function() {
  var args, fn, self;
  fn = arguments[0], self = arguments[1], args = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
  return applier(fn, self, false, args);
};
exports = {
  middle: middle,
  mike: middle,
  outside: outside,
  will: outside,
  strong: strong,
  sam: strong,
  coach: applier
};