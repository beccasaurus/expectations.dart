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
    if (positive) {
      Expect.approxEquals(expected, target, tolerance: tolerance, reason: reason);
    } else {
      ExpectException expectedException = null;
      try {
        Expect.approxEquals(expected, target, tolerance: tolerance, reason: reason);
      } catch (ExpectException ex) {
        print("APPROX-EQUALS - caught Exception!  $ex");
        expectedException = ex;
      }
      if (expectedException == null) {
        String reasonText = (reason == null) ? '' : ", '$reason'";
        throw new ExpectException("Expect.not.approxEquals(unexpected:<$expected>, actual:<$target>, tolerance:<$tolerance>$reasonText) fails"); // add reason
      } else if (expectedException.toString().startsWith("Expect.approxEquals")) {
        // Do nothing, this is a success!
      } else {
        throw expectedException; // Unexpected Exception
      }
    }
  }

  /** See Expect.equals. */
  void equals(var expected, [String reason = null]) {
    if (positive == true)
      Expect.equals(expected, target, reason: reason);
    else
      Expect.notEquals(expected, target, reason: reason);
  }

  /** See [equals]. */
  operator ==(var object) {
    equals(object);
  }

  /** See Expect.fail(). */
  void fail([String reason = "no reason given"]) {
    Expect.fail(reason);
  }

  // See Expect.identical()
  void identical(expected, [String reason = null]) {
    Expect.identical(expected, target, reason: reason);
  }

  /** See Expect.isFalse(). */
  void isFalse([String reason = null]) {
    Expect.isFalse(target, reason: reason);
  }

  /** See Expect.isNotNull(). */
  void isNotNull([String reason = null]) {
    Expect.isNotNull(target, reason: reason);
  }

  /** See Expect.isNull().  */
  void isNull([String reason = null]) {
    Expect.isNull(target, reason: reason);
  }

  /** See Expect.isTrue(). */
  void isTrue([String reason = null]) {
    Expect.isTrue(target, reason: reason);
  }

  /** See Expect.listEquals(). */
  void equalsCollection(Collection expected, [String reason = null]) {
    Expect.listEquals(expected, target, reason: reason);
  }

  /** See Expect.notEquals(). */
  void notEquals(value, [String reason = null]) {
    Expect.notEquals(value, target, reason: reason);
  }

  /** See Expect.setEqual(). */
  void equalsSet(Iterable expected, [String reason = null]) {
    Expect.setEquals(expected, target, reason: reason);
  }

  /** See Expect.stringEquals(). */
  void equalsString(String value, [String reason = null]) {
    Expect.stringEquals(value, target, reason: reason);
  }

  /** See Expect.throws(). */
  void throws([check = null, String reason = null]) {
    Expect.throws(target, check: check, reason: reason);
  }
}
