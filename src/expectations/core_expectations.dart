/**
 * By default, [Expectations] uses [CoreExpectations] for all of its expectations. 
 * In other words, calling [:expect("foo"):] returns an instance of [CoreExpectations].
 *
 * This class provides 1 method for every method available on [:Expect:].  The names map 
 * very closely to the originals, eg. [:Expect.equals(a, b):] becomes [:expect(b).equals(a):].
 *
 * There are a few notable differences, eg. [:Expect.listEquals(a, b):] becomes [:expect(b).equalsCollection(a):]. 
 * These method names were inspired the Dart unit test library, unittest: 
 * http://code.google.com/p/dart/source/browse/trunk/dart/client/testing/unittest/unittest.dart?r=1052 
 *
 */
class CoreExpectations implements Expectationable {
  var target;
  bool positive;

  CoreExpectations(target) {
    this.target   = target;
    this.positive = true;
  }

  CoreExpectations get not() {
    var core = new CoreExpectations(target);
    core.positive = false;
    return core;
  }

  /** See Expect.approxEquals. */
  void approxEquals(num expected, [num tolerance = 0.000100, String reason = null]) {
    _runExpectation(
      (){ Expect.approxEquals(expected, target, tolerance: tolerance, reason: reason); },
      () => "Expect.not.approxEquals(unexpected:<$expected>, actual:<$target>, tolerance:<$tolerance>${_reasonText(reason)}) fails");
  }

  /** See Expect.equals. */
  void equals(var expected, [String reason = null]) {
    if (positive)
      Expect.equals(expected, target, reason: reason);
    else
      if (expected == target)
        throw new ExpectException("Expect.not.equals(unexpected: <$expected>, actual: <$target>${_reasonText(reason)}) fails.");
  }

  /** See [equals]. */
  operator ==(var object) {
    equals(object);
  }

  /** See Expect.fail(). */
  void fail([String reason = "no reason given"]) {
    if (positive != true) throw new UnsupportedOperationException("fail cannot be called with .not");
    Expect.fail(reason);
  }

  // See Expect.identical()
  void identical(expected, [String reason = null]) {
    if (positive)
      Expect.identical(expected, target, reason: reason);
    else
      if (expected === target)
        throw new ExpectException("Expect.not.identical(unexpected: <$expected>, actual: <$target>${_reasonText(reason)}) fails.");
  }

  /** See Expect.isFalse(). */
  void isFalse([String reason = null]) {
    if (positive != true) throw new UnsupportedOperationException("isFalse cannot be called with .not");
    Expect.isFalse(target, reason: reason);
  }

  /** See Expect.isNotNull(). */
  void isNotNull([String reason = null]) {
    if (positive != true) throw new UnsupportedOperationException("isNotNull cannot be called with .not");
    Expect.isNotNull(target, reason: reason);
  }

  /** See Expect.isNull().  */
  void isNull([String reason = null]) {
    if (positive == true)
      Expect.isNull(target, reason: reason);
    else
      if (null === target)
        throw new ExpectException("Expect.not.isNull($target${_reasonText(reason)}) fails.");
  }

  /** See Expect.isTrue(). */
  void isTrue([String reason = null]) {
    if (positive == true)
      Expect.isTrue(target, reason: reason);
    else
      if (true === target)
        throw new ExpectException("Expect.not.isTrue($target${_reasonText(reason)}) fails.");
  }

  /** See Expect.listEquals(). */
  void equalsCollection(Collection expected, [String reason = null]) {
    _runExpectation(
      (){ Expect.listEquals(expected, target, reason: reason); },
      () => "Expect.not.listEquals(${_iterableText(target)}${_reasonText(reason)}) fails");
  }

  /** See Expect.notEquals(). */
  void notEquals(value, [String reason = null]) {
    if (positive != true) throw new UnsupportedOperationException("notEquals cannot be called with .not");
    Expect.notEquals(value, target, reason: reason);
  }

  /** See Expect.setEqual(). */
  void equalsSet(Iterable expected, [String reason = null]) {
    _runExpectation(
      (){ Expect.setEquals(expected, target, reason: reason); },
      () => "Expect.not.setEquals(${_iterableText(target)}${_reasonText(reason)}) fails");
  }

  /** See Expect.stringEquals(). */
  void equalsString(String value, [String reason = null]) {
    _runExpectation(
      (){ Expect.stringEquals(value, target, reason: reason); },
      () => "Expect.not.stringEquals('$target'${_reasonText(reason)}) fails");
  }

  /** See Expect.throws(). */
  void throws([check = null, String reason = null]) {
    if (positive) {
      Expect.throws(target, check: check, reason: reason);
    } else {
      // I'm not sure what the "expected" behavior of check: would be when 
      // called as expect().not.throws(check: ...) so it's currently unsupported.
      if (check != null)
        throw new UnsupportedOperationException("the :check parameter of throws() is unsupported when called with .not");
      try {
        target();
      } catch (Exception ex) {
        throw new ExpectException("Expect.not.throws(unexpected: <$ex>${_reasonText(reason)}) fails");
      }
    }
  }

  // This does some evil to make the .not statements work by calling 
  // the *positive* version of the expectation and passing if an 
  // ExpectException was thrown by the positive expectation.
  //
  // NOTE: This implementation isn't ideal!  Exceptions shouldn't be 
  //       thrown within *passing* expectations.
  void _runExpectation(void passingCode(), String notFailureMessage()) {
    if (positive == true) {
      // This code should pass, so we just run it!
      // If it blows up, that means a legit failure
      passingCode();
    } else {
      // If .not was used, we *expect* the passingCode to actually fail.
      // If we get an ExpectException that looks right, then this was successful.
      // Otherwise, we throw the Exception that we got, directly.
      ExpectException expectedException;
      try {
        passingCode();
      } catch (ExpectException ex) {
        expectedException = ex;
      }
      
      // We expected to get an exception.
      // The code must have passed, meaning the "not" failed!"
      if (expectedException == null)
        throw new ExpectException(notFailureMessage());
    }
  }

  String _reasonText(String reason) {
    return (reason == null) ? "" : ", '$reason'";
  }

  String _iterableText(Iterable collection) {
    List<String> stringRepresentations = new List<String>();
    for (var item in collection)
      stringRepresentations.add(item.toString());
    return "[" + Strings.join(stringRepresentations, ", ") + "]";
  }
}
