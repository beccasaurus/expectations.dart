class CustomExpectationsSpec_Expectationable implements Expectationable {
  var target;
  CustomExpectationsSpec_Expectationable(this.target);

  toBeAwesome() {
    if (! target.toString().toLowerCase().contains("awesome", 0))
      Expect.fail("Expected $target to be awesome, but it was not.  Lame.");
  }
}

class CustomExpectationsSpec_ExpectationsSubclass extends CoreExpectations implements Expectationable {
  CustomExpectationsSpec_ExpectationsSubclass(var target) : super(target);

  toBeAwesome() {
    if (! target.toString().toLowerCase().contains("awesome", 0))
      Expect.fail("Expected $target to be awesome, but it was not.  Lame.");
  }
}

class CustomExpectationsSpec_OverridesToEqual extends CoreExpectations implements Expectationable {
  CustomExpectationsSpec_OverridesToEqual(var target) : super(target);

  toBeAwesome() {
    if (! target.toString().toLowerCase().contains("awesome", 0))
      Expect.fail("Expected $target to be awesome, but it was not.  Lame.");
  }

  equals(value,[reason = null]) { throw new ExpectException("Ha, this is our new equals!"); }
}

class CustomExpectationsSpec extends CoreExpectationsSpec {
  spec() {
    describe("Custom Expectations", (){

      // Reset the Expectations before and after each test
      before(() => Expectations.setDefaultExpectationableSelector());
      after(() => Expectations.setDefaultExpectationableSelector());

      it("throws a regular ol' NoSuchMethodException if the expectation method you call doesn't exist", (){
        var exception = mustThrowException(() => expect("foo").toBeUnknownMethod());
        Expect.isTrue(exception is NoSuchMethodException);
        Expect.isTrue(exception.toString().contains("function name: 'toBeUnknownMethod'", 0));
      });

      describe("When there are no expectationable selectors", (){
        before(() => Expectations.expectationableSelectors.clear());

        it("should throw a NoExpectationableFoundException letting me know that there are no expectationableSelectors set", (){
          var exception = mustThrowException(() => expect("foo").notEquals("foo"));
          Expect.isTrue(exception is NoExpectationableFoundException);
          Expect.equals("No Expectations.expectationableSelectors() were found.  Try calling Expectations.onExpect(fn).", exception.toString());
        });
      });

      describe("When none of the expectationable selectors match the given target", (){
        before(() => Expectations.setExpectationableSelector((target) => null));

        it("should throw a NoExpectationableFoundException letting me know that none of the expectationableSelectors returned an Expectationable", (){
          var exception = mustThrowException(() => expect("foo").notEquals("foo"));
          Expect.isTrue(exception is NoExpectationableFoundException);
          Expect.equals("No Expectations.expectationableSelectors() returned an Expectationable for target: foo", exception.toString());
        });
      });

      describe("overriding expectations by always returning a custom Expectationable", (){
        before(() => Expectations.setExpectationableSelector((target) => new CustomExpectationsSpec_Expectationable(target)));

        it("my custom expectation can pass OK", () => expect("is totally awesome").toBeAwesome());

        it("my custom expectation can fail OK", (){
          var exception = mustThrowException(() => expect("is lame").toBeAwesome());
          Expect.isTrue(exception is ExpectException);
          Expect.stringEquals("Expect.fail('Expected is lame to be awesome, but it was not.  Lame.')", exception.toString());
        });
      });

      describe("adding expectations by extending Expectations", (){
        before(() => Expectations.setExpectationableSelector((target) => new CustomExpectationsSpec_ExpectationsSubclass(target)));

        it("always uses our subclass",        () => Expect.isTrue(expect('anything') is CustomExpectationsSpec_ExpectationsSubclass));
        it("our subclass is an Expectations", () => Expect.isTrue(expect('anything') is CoreExpectations));

        describe("calling my custom expectation function", (){
          it("can pass", () => expect("is totally awesome").toBeAwesome());

          it("can fail", (){
            mustThrowException(() => expect("lame").toBeAwesome(),
              check:   (ex) => ex is ExpectException,
              message: "Expect.fail('Expected lame to be awesome, but it was not.  Lame.')");
          });
        });

        describe("calling a build-in expectation function", (){
          it("can pass", () => expect(1).equals(1));

          it("can fail", (){
            mustThrowException(() => expect(1).equals(999),
              check:   (ex) => ex is ExpectException,
              message: "Expect.equals(expected: <999>, actual: <1>) fails.");
          });
        });
      });

      describe("overriding expectations by extending Expectations", (){
        it("behaves normally if we use the default Expectations", (){
          expect("foo").equals("foo");
          expect("foo").notEquals("bar");
        });

        it("behaves differently when we use our custom Expectations subclass", (){
          Expectations.setExpectationableSelector((target) => new CustomExpectationsSpec_OverridesToEqual(target));

          // equals() throws an exception now
          var exception = mustThrowException(() => expect("foo").equals("foo"));
          Expect.stringEquals("Ha, this is our new equals!", exception.toString());

          // But other functions still work 
          expect("foo").notEquals("bar");
        });
      });

      describe("adding expectations by registering new Expectations instances via onExpect()", (){
        it("our custom expectation doesn't work before we register our Expectations with onExpect()", (){
          var exception = mustThrowException(() => expect("totally awesome").toBeAwesome());
          Expect.isTrue(exception is NoSuchMethodException);
          Expect.isTrue(exception.toString().contains("function name: 'toBeAwesome'", 0));
        });

        it("our custom expectation works after we register our Expectations with onExpect()", (){
          Expectations.onExpect((target) => new CustomExpectationsSpec_OverridesToEqual(target));
          expect("totally awesome").toBeAwesome();
        });

        it("our custom expectation can override default ones based on the type of the target object", (){
          expect(1).equals(1);
          expect("foo").equals("foo");
          
          // If we pass a String to expect(), return a CustomExpectationsSpec_OverridesToEqual (which will throw an Exception)
          Expectations.onExpect((target) {
            if (target is String)
              return new CustomExpectationsSpec_OverridesToEqual(target);
            else
              return null; // fall back to the default set of expectations
          });

          // expect(int)'s equals works fine ...
          expect(1).equals(1);

          // but expect(String)'s equals blows up!
          var exception = mustThrowException(() => expect("foo").equals("foo"));
          Expect.isTrue(exception is ExpectException);
          Expect.stringEquals("Ha, this is our new equals!", exception.toString());
        });
      });
    });
  }
}
