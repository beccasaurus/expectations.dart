#import("../lib/spec.dart");
#import("../src/expectations.dart");

#source("included_expectations_spec.dart");
#source("custom_expectations_spec.dart");

// Spec baseclass with helper methods, etc.
class ExpectationsSpec extends Spec {
  Exception mustThrowException(fn) {
    var exception = null;
    try {
      fn();
    } catch (Exception e) {
      exception = e;
    } finally {
      if (exception == null)
        throw new ExpectException("Expected an Exception to be thrown, but none was");
      return exception;
    }
  } 
}

int main() {
  // SpecExample.raiseExceptions = true;
  Specs.run([
    new IncludedExpectationsSpec(),
    new CustomExpectationsSpec()
  ]);
}
