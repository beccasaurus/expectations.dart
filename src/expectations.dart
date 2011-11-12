#library("expectations");

#source("expectations/expectationable.dart");
#source("expectations/expectationable_selector.dart");
#source("expectations/no_expectationable_found_exception.dart");
#source("expectations/core_expectations.dart");

/**
 * The expect() function is defined globally so you can easily call 
 * it from within your own test suites (or wherever).
 *
 * Example usage: expect("Foo").toEqual("Bar");
 *
 * If you want to implement your own expectations so 
 * you can call expect("Foo").toSomethingCustom(), 
 * see Expectations.onExpect()
 */
Expectationable expect(var target) => Expectations.expect(target);

/**
 * [Expectations] houses the logic for the top-level [:expect():] 
 * method, including determining what [Expectationable] instance to 
 * return (which is where expectation methods are defined).
 * 
 * See [:Expectations.expect():] for main [:expect():] implementation.
 * See [:Expectations.onExpect():] to use your own custom [Expectationable].
 */
class Expectations {

  /** Returns the vurrent version of Expectations */
  static final VERSION = "0.1.0";

  static List<ExpectationableSelector> _expectationableSelectors;
  static ExpectationableSelector       _defaultExpectationableSelector;

  /**
   * Default [:ExpectationableSelector:] that we include in 
   * expectationableSelectors which always returns an instance of [Expectations]. */
  static ExpectationableSelector get defaultExpectationableSelector() {
    if (_defaultExpectationableSelector === null)
      _defaultExpectationableSelector = (target) => new CoreExpectations(target);
    return _defaultExpectationableSelector;
  }

  /**
   * A list of functions that are iterated through and each called 
   * to determine what [Expectationable] instance to return from expect().
   *
   * When each function is called, it can look at the target object 
   * to determine whether to return null or an instance of Expectationable 
   * that has been instantiated with the target object, allowing us to 
   * return that from [:expect():].
   */
  static List<ExpectationableSelector> get expectationableSelectors() {
    if (_expectationableSelectors === null) {
      _expectationableSelectors = new List<ExpectationableSelector>();
      _expectationableSelectors.add(defaultExpectationableSelector);
    }
    return _expectationableSelectors;
  }

  /**
   * [:onExpect:] takes a [:ExpectationableSelector:] and configures 
   * it to be called whenever [:expect():] is called, allowing this function 
   * to return a custom [Expectationable] object for the target provided.
   *
   * The [:ExpectationableSelector:] provided will be added to the front 
   * of [:expectationableSelectors():].  If your function returns null, we will 
   * continue iterations over the rest of the [:expectationableSelectors():] that 
   * were registered via [:onExpect():] until we finally find an [Expectationable] class 
   * to return from [:expect():] (or an Exception will be thrown if none are found).
   */
  static void onExpect(ExpectationableSelector fn) {
    expectationableSelectors.insertRange(0, 1, fn);
  }

  // When given an ExpectationableSelector, this clears out all other 
  // selector callback functions (eg. those registered via onExpect) and 
  // sets this to be the only function, so only this function will handle 
  // what Expectationable object to return from expect().
  static void setExpectationableSelector(ExpectationableSelector fn) {
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
    for (ExpectationableSelector selector in expectationableSelectors) {
      expectationable = selector(target);
      if (expectationable !== null)
        break;
    }
    if (expectationable === null)
      throw new NoExpectationableFoundException(target);
    return expectationable;
  }
}
