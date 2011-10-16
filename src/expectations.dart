#library("expectations");

// An Expectationable class has a constructor that takes any type 
// of object and provides functions that make Expect assertions on 
// that object, eg. new MyExpectationable("Foo").toEqual("Bar")
//
// An Expectationable instance is meant to be returned by 
// expect(), eg. expect("Foo").toEqual("Bar").
interface Expectationable {
  var target;
  Expectationable(var target);
}

// An ExpectationableSelectorFunction is a function that, given 
// a target object, can return either:
//
//  - an instance of an Expectationable class, initialized with the 
//    target object, so we can call the functions that the Expectationable 
//    class provides on the target object, eg. toEqual()
//
//  - or null to indicate that we don't want to run expectations on 
//    the given target, so another ExpectationableSelectorFunction 
//    should be checked to return an Expectationable.
typedef Expectationable ExpectationableSelectorFunction(var target);

// The expect() function is defined globally so you can easily call 
// it from within your own test suites (or wherever).
//
// Example usage: expect("Foo").toEqual("Bar");
//
// If you want to implement your own expectations so 
// you can call expect("Foo").toSomethingCustom(), 
// see Expectations.onExpect()
expect(var target) => Expectations.expect(target);

// Exception that is thrown when expect() is called but none of 
// the expectationableSelectors (registered via Expectations.onExpect()) 
// returned an instance of Expectationable that could be returned from expect()
class NoExpectationableFoundException implements Exception {
  var  target;
  bool noSelectors;

  NoExpectationableFoundException(var target, [bool noSelectors = false]) {
    this.target      = target;
    this.noSelectors = noSelectors;
  }

  String toString() {
    if (noSelectors == true)
      return "No Expectations.expectationableSelectors() were found.  Try calling Expectations.onExpect(fn).";
    else
      return "No Expectations.expectationableSelectors() returned an Expectationable for target: $target";
  }
}

// Expectations is an Expectationable which provides 
// all of the expectations build into this library.
//
// Expectations also statically stores a list of 
// callbacks that are called whenever expect() is 
// called to determine what Expectationable object 
// to return from expect(), providing a set of 
// expectation functions, eg. toEqual()
// 
// See Expectations.expect() for main expect() implementation.
// See Expectations.onExpect() to use your own custom Expectationable.
class Expectations implements Expectationable {

  // Returns the vurrent version of Expectations
  static final VERSION = "0.1.0";

  static List<ExpectationableSelectorFunction> _expectationableSelectors;
  static ExpectationableSelectorFunction       _defaultExpectationableSelector;

  // Default ExpectationableSelectorFunction that we include in 
  // expectationableSelectors which always returns an instance of Expectations
  static ExpectationableSelectorFunction get defaultExpectationableSelector() {
    if (_defaultExpectationableSelector == null)
      _defaultExpectationableSelector = (target) => new Expectations(target);
    return _defaultExpectationableSelector;
  }

  // A list of functions that are iterated through and each called 
  // to determine what Expectationable instance to return from expect().
  //
  // When each function is called, it can look at the target object 
  // to determine whether to return null or an instance of Expectationable 
  // that has been instantiated with the target object, allowing us to 
  // return that from expect().
  static List<ExpectationableSelectorFunction> get expectationableSelectors() {
    if (_expectationableSelectors == null) {
      _expectationableSelectors = new List<ExpectationableSelectorFunction>();
      _expectationableSelectors.add(defaultExpectationableSelector);
    }
    return _expectationableSelectors;
  }

  // onExpect takes a ExpectationableSelectorFunction and configures 
  // it to be called whenever expect() is called, allowing this function 
  // to return a custom Expectationable object for the target provided.
  //
  // The ExpectationableSelectorFunction provided will be added to the front 
  // of expectationableSelectors().  If your function returns null, we will 
  // continue iterations over the rest of the expectationableSelectors() that 
  // were registered via onExpect() until we finally find an Expectationable class 
  // to return from expect() (or an Exception will be thrown if none are found).
  static void onExpect(ExpectationableSelectorFunction fn) {
    _addToStartOfList(expectationableSelectors, fn);
  }

  // When given an ExpectationableSelectorFunction, this clears out all other 
  // selector callback functions (eg. those registered via onExpect) and 
  // sets this to be the only function, so only this function will handle 
  // what Expectationable object to return from expect().
  static void setExpectationableSelector(ExpectationableSelectorFunction fn) {
    expectationableSelectors.clear();
    expectationableSelectors.add(fn);
  }

  // Resets expectationableSelectors back to its default (which always returns an 
  // instance of Expectations from expect())
  static void setDefaultExpectationableSelector() {
    Expectations.setExpectationableSelector(Expectations.defaultExpectationableSelector);
  }

  // Wraps the target object in an instance of an Expectationable that 
  // should provide useful Expect-style functions, eg. toEqual() so 
  // you can write expect(someNumber).toEqual(5).
  static Expectationable expect(var target) {
    if (expectationableSelectors.length == 0)
      throw new NoExpectationableFoundException(target, noSelectors: true);

    Expectationable expectationable;
    for (ExpectationableSelectorFunction selector in expectationableSelectors) {
      expectationable = selector(target);
      if (expectationable != null)
        break;
    }
    if (expectationable == null)
      throw new NoExpectationableFoundException(target);
    return expectationable;
  }

  // List.insertRange isn't implemented yet, so here's a hack 
  // that gives you a new list with the given object at the front.
  static void _addToStartOfList(List list, var object) {
    var tempList = new List.from(list);
    list.clear();
    list.add(object);
    tempList.forEach((item) => list.add(item));
  }

  // The target object that was passed to this set of Expectations
  var target;

  // Instantiate this set of Expectations for the given target object.
  Expectations(this.target);

  // See Expect.equals()
  void toEqual(value, [String reason = null]) {
    Expect.equals(value, target, reason: reason);
  }

  // See Expect.notEquals()
  void toNotEqual(value, [String reason = null]) {
    Expect.notEquals(value, target, reason: reason);
  }

  // See Expect.approxEquals()
  void toApproxEqual(num value, [num tolerance = null, String reason = null]) {
    Expect.approxEquals(value, target, tolerance: tolerance, reason: reason);
  }

  // See Expect.identical()
  void toBeIdenticalTo(value, [String reason = null]) {
    Expect.identical(value, target, reason: reason);
  }

  // See expect.isTrue()
  void toBeTrue([String reason = null]) {
    Expect.isTrue(target, reason: reason);
  }

  // See expect.isFalse()
  void toBeFalse([String reason = null]) {
    Expect.isFalse(target, reason: reason);
  }

  // See expect.isNull()
  // See expect.isNotNull()

  // See expect.stringEquals()
  // See expect.listEquals()
  // See expect.setEquals()

  // See expect.throws()
}
