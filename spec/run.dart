#import("../lib/bullseye.dart");
#import("../src/expectations.dart");

#source("included_expectations_spec.dart");
#source("custom_expectations_spec.dart");

// Spec baseclass with helper methods, etc.
class ExpectationsSpec extends BullseyeSpec {

  // Given a function of code to run, this fails unless the function throws 
  // an exception when run.
  //
  // You may optionally pass a String message and we'll assert that the 
  // message is equal to the Exception's message.
  //
  // You may optionally pass a check function which is given the Exception 
  // that was thrown and should return true, or else an assertion will be raised.
  //
  // If you want to perform additional assertions on the Exception thrown, 
  // this method returns the original Exception.
  Exception mustThrowException([code = null, bool check(Exception) = null, String message = null]) {
    var exception = null;
    try {
      code();
    } catch (Exception e) {
      exception = e;
    } finally {
      if (exception == null)
        Expect.fail("Expected an Exception to be thrown, but none was");
    }

    if (message != null) Expect.stringEquals(message, exception.toString());
    if (check != null)   Expect.isTrue(check(exception));

    return exception;
  } 
}

int main() {
  Bullseye.run([
    new IncludedExpectationsSpec()
    // new CustomExpectationsSpec()
  ]);
}
