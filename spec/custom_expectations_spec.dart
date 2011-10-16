class CustomExpectationsSpec_Expectationable implements Expectationable {
  var target;
  CustomExpectationsSpec_Expectationable(this.target);

  toBeAwesome() {
    if (! target.toString().toLowerCase().contains("awesome", 0))
      Expect.fail("Expected $target to be awesome, but it was not.  Lame.");
  }
}

class CustomExpectationsSpec_ExpectationsSubclass extends Expectations implements Expectationable {
  CustomExpectationsSpec_ExpectationsSubclass(var target) { this.target = target; }

  toBeAwesome() {
    if (! target.toString().toLowerCase().contains("awesome", 0))
      Expect.fail("Expected $target to be awesome, but it was not.  Lame.");
  }
}

class CustomExpectationsSpec_OverridesToEqual extends Expectations implements Expectationable {
  CustomExpectationsSpec_OverridesToEqual(var target) { this.target = target; }

  toBeAwesome() {
    if (! target.toString().toLowerCase().contains("awesome", 0))
      Expect.fail("Expected $target to be awesome, but it was not.  Lame.");
  }

  toEqual(o) { throw new ExpectException("Ha, this is our new toEqual!"); }
}

class CustomExpectationsSpec extends ExpectationsSpec {
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
        it("our subclass is an Expectations", () => Expect.isTrue(expect('anything') is Expectations));

        describe("calling my custom expectation function", (){
          it("can pass", () => expect("is totally awesome").toBeAwesome());

          it("can fail", (){
            var exception = mustThrowException(() => expect("lame").toBeAwesome());
            Expect.isTrue(exception is ExpectException);
            Expect.stringEquals("Expect.fail('Expected lame to be awesome, but it was not.  Lame.')", exception.toString());
          });
        });

        describe("calling a build-in expectation function", (){
          it("can pass", () => expect("foo").toEqual("foo"));

          it("can fail", (){
            var exception = mustThrowException(() => expect("foo").toEqual("bar"));
            Expect.isTrue(exception is ExpectException);
            Expect.stringEquals("Expect.equals(expected: <bar>, actual: <foo>) fails.", exception.toString());
          });
        });
      });

      describe("overriding expectations by extending Expectations", (){
        it("behaves normally if we use the default Expectations", (){
          expect("foo").toEqual("foo");
          expect("foo").toNotEqual("bar");
        });

        it("behaves differently when we use our custom Expectations subclass", (){
          Expectations.setExpectationableSelector((target) => new CustomExpectationsSpec_OverridesToEqual(target));

          // toEqual() throws an exception now
          var exception = mustThrowException(() => expect("foo").toEqual("foo"));
          Expect.stringEquals("Ha, this is our new toEqual!", exception.toString());

          // But other functions still work 
          expect("foo").toNotEqual("bar");
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
          expect(1).toEqual(1);
          expect("foo").toEqual("foo");
          
          // If we pass a String to expect(), return a CustomExpectationsSpec_OverridesToEqual (which will throw an Exception)
          Expectations.onExpect((target) {
            if (target is String)
              return new CustomExpectationsSpec_OverridesToEqual(target);
            else
              return null; // fall back to the default set of expectations
          });

          // expect(int)'s toEqual works fine ...
          expect(1).toEqual(1);

          // but expect(String)'s toEqual blows up!
          var exception = mustThrowException(() => expect("foo").toEqual("foo"));
          Expect.isTrue(exception is ExpectException);
          Expect.stringEquals("Ha, this is our new toEqual!", exception.toString());
        });
      });
    });
  }
}
