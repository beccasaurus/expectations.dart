class CustomExpectationsSpec_Expectationable implements Expectationable {
  var target;
  CustomExpectationsSpec_Expectationable(this.target);

  toBeAwesome() {
    if (! target.toString().toLowerCase().contains("awesome", 0))
      Expect.fail("Expected $target to be awesome, but it was not.  Lame.");
  }
}

class CustomExpectationsSpec extends ExpectationsSpec {
  spec() {
    describe("Custom Expectations", (){
      after(() => Expectations.setDefaultExpectationableSelector());

      it("throws a regular ol' NoSuchMethodException if the expectation method you call doesn't exist", (){
        pending("TODO");
      });

      describe("When there are no expectationable selectors", (){
        before(() => Expectations.expectationableSelectors.clear());

        it("should throw a NoExpectationableFoundException letting me know that there are no expectationableSelectors set", (){
          var exception = mustThrowException(() => expect("foo").toNotEqual("foo"));
          Expect.isTrue(exception is NoExpectationableFoundException);
          Expect.equals("No Expectations.expectationableSelectors() were found.  Try calling Expectations.onExpect(fn).", exception.toString());
        });
      });

      describe("When none of the expectationable selectors match the given target", (){
        before(() => Expectations.setExpectationableSelector((target) => null));

        it("should throw a NoExpectationableFoundException letting me know that none of the expectationableSelectors returned an Expectationable", (){
          var exception = mustThrowException(() => expect("foo").toNotEqual("foo"));
          Expect.isTrue(exception is NoExpectationableFoundException);
          Expect.equals("No Expectations.expectationableSelectors() returned an Expectationable for target: foo", exception.toString());
        });
      });

      describe("overriding expectations by always returning a custom Expectationable", (){
        before(() => Expectations.setExpectationableSelector((target) => new CustomExpectationsSpec_Expectationable(target)));

        it("my custom expectation can pass OK", (){
          expect("is totally awesome").toBeAwesome();
        });

        it("my custom expectation can fail OK", (){
          var exception = mustThrowException(() => expect("is lame").toBeAwesome());
          Expect.isTrue(exception is ExpectException);
          Expect.stringEquals("Expect.fail('Expected is lame to be awesome, but it was not.  Lame.')", exception.toString());
        });
      });

      describe("adding expectations by extending Expectations", (){
        it("can call my new expectation");
        it("can call a built-in expectation");
      });

      describe("overriding expectations by extending Expectations");
      describe("adding expectations by registering new Expectations instances");

    });
  }
}
