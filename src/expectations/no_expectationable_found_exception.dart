/**
 * Exception that is thrown when expect() is called but none of 
 * the expectationableSelectors (registered via Expectations.onExpect()) 
 * returned an instance of Expectationable that could be returned from expect()
 */
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
