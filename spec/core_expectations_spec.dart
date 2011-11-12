class CoreExpectationsSpec extends ExpectationsSpec {
  spec(){
    example("CoreExpectations (default expectations)", (){

      before(() => 
        Expectations.onExpect((target) => new CoreExpectations(target)));

      // Expect.approxEquals(num expected, num actual, [num tolerance = null, String reason = null])
      example("expect().approxEquals", (){
        shouldPass(() => expect(1.0000).approxEquals(1.0001));

        shouldFail(() => expect(1.0000).approxEquals(1.001),
          check:   (exception) => exception is ExpectException,
          message: "Expect.approxEquals(expected:<1.001000>, actual:<1.000000>, tolerance:<0.000100>) fails");

        shouldFailWithReason(() => expect(1.0000).approxEquals(1.001, reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.approxEquals(expected:<1.001000>, actual:<1.000000>, tolerance:<0.000100>, 'Cuz I said so') fails");

        example("with tolerance", (){
          shouldPass(() => expect(1.000).approxEquals(1.001, tolerance: 0.1));

          shouldFail(() => expect(1.0000).approxEquals(1.1, tolerance: 0.1),
            check:   (exception) => exception is ExpectException,
            message: "Expect.approxEquals(expected:<1.100000>, actual:<1.000000>, tolerance:<0.100000>) fails");

          shouldFailWithReason(() => expect(1.0000).approxEquals(1.1, tolerance: 0.1, reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.approxEquals(expected:<1.100000>, actual:<1.000000>, tolerance:<0.100000>, 'Cuz I said so') fails");
        });
      });

      // Expect.equals(<dynamic> expected, <dynamic> actual, [String reason = null])
      example("expect().equals", (){
        shouldPass(() {
          expect(1).equals(1);
          expect(1).not.equals(2);
        });

        shouldFail(() => expect(1).equals(999),
          check:   (exception) => exception is ExpectException,
          message: "Expect.equals(expected: <999>, actual: <1>) fails.");

        shouldFailWithReason(() => expect(1).equals(999, reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.equals(expected: <999>, actual: <1>, 'Cuz I said so') fails.");

        example("alias: expect() == 1", (){
          shouldPass(()=> expect(1) == 1);

          shouldFail(() => expect(1) == 999,
            check:   (exception) => exception is ExpectException,
            message: "Expect.equals(expected: <999>, actual: <1>) fails.");
        });
      });

      // Expect.fail(String msg)
      example("expect().fail", (){
        shouldFail(() => expect(1).fail('Oh noes!'),
          check:   (exception) => exception is ExpectException,
          message: "Expect.fail('Oh noes!')");

        shouldFailWithReason(() => expect(1).fail(reason: 'Oh noes!'),
          check:   (exception) => exception is ExpectException,
          message: "Expect.fail('Oh noes!')");

        it("fail with default reason", () =>
          mustThrowException(() => expect(1).fail(),
            check:   (exception) => exception is ExpectException,
            message: "Expect.fail('no reason given')"));
      });

      // Expect.identical(<dynamic> expected, <dynamic> actual, [String reason = null])
      var object1     = new Object();
      var alsoObject1 = object1;
      var object2     = new Object();
      example("expect().identical", (){
        shouldPass(() => expect(object1).identical(alsoObject1));

        shouldFail(() => expect(object1).identical(object2),
          check:   (exception) => exception is ExpectException,
          message: "Expect.identical(expected: <Instance of 'Object'>, actual: <Instance of 'Object'>) fails.");

        shouldFailWithReason(() => expect(object1).identical(object2, reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.identical(expected: <Instance of 'Object'>, actual: <Instance of 'Object'>, 'Cuz I said so') fails.");
      });

      // Expect.isFalse(<dynamic> actual, [String reason = null])
      example("expect().isFalse", (){
        shouldPass(() => expect(false).isFalse());

        shouldFail(() => expect(true).isFalse(),
          check:   (exception) => exception is ExpectException,
          message: "Expect.isFalse(true) fails.");

        shouldFailWithReason(() => expect(true).isFalse(reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.isFalse(true, 'Cuz I said so') fails.");
      });

      // Expect.isNotNull(<dynamic> actual, [String reason = null])
      example("expect().isNotNull", (){
        shouldPass(() => expect("Not NULL").isNotNull());

        shouldFail(() => expect(null).isNotNull(),
          check:   (exception) => exception is ExpectException,
          message: "Expect.isNotNull(actual: <null>) fails.");

        shouldFailWithReason(() => expect(null).isNotNull(reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.isNotNull(actual: <null>, 'Cuz I said so') fails.");
      });

      // Expect.isNull(<dynamic> actual, [String reason = null])
      example("expect().isNull", (){
        shouldPass(() => expect(null).isNull());

        shouldFail(() => expect("Not NULL").isNull(),
          check:   (exception) => exception is ExpectException,
          message: "Expect.isNull(actual: <Not NULL>) fails.");

        shouldFailWithReason(() => expect("Not NULL").isNull(reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.isNull(actual: <Not NULL>, 'Cuz I said so') fails.");
      });

      // Expect.isTrue(<dynamic> actual, [String reason = null])
      example("expect().isTrue", (){
        shouldPass(() => expect(true).isTrue());

        shouldFail(() => expect(false).isTrue(),
          check:   (exception) => exception is ExpectException,
          message: "Expect.isTrue(false) fails.");

        shouldFailWithReason(() => expect(false).isTrue(reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.isTrue(false, 'Cuz I said so') fails.");
      });

      // Expect.listEquals(List<E> expected, List<E> actual, [String reason = null])
      example("expect().equalsCollection", (){
        shouldPass(() => expect(["foo"]).equalsCollection(["foo"]));

        shouldFail(() => expect(["foo"]).equalsCollection(["bar"]),
          check:   (exception) => exception is ExpectException,
          message: "Expect.listEquals(at index 0, expected: <bar>, actual: <foo>) fails");

        shouldFailWithReason(() => expect(["foo"]).equalsCollection(["bar"], reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.listEquals(at index 0, expected: <bar>, actual: <foo>, 'Cuz I said so') fails");
      });

      // Expect.notEquals(<dynamic> unexpected, <dynamic> actual, [String reason = null])
      example("expect().notEquals", (){
        shouldPass(()=> expect(1).notEquals(999));

        shouldFail(() => expect(1).notEquals(1),
          check:   (exception) => exception is ExpectException,
          message: "Expect.notEquals(unexpected: <1>, actual:<1>) fails.");

        shouldFailWithReason(() => expect(1).notEquals(1, reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.notEquals(unexpected: <1>, actual:<1>, 'Cuz I said so') fails.");
      });

      // Expect.setEquals(Iterable<E> expected, Iterable<E> actual, [String reason = null])
      example("expect().equalsSet", (){
        shouldPass(() => expect(new Set.from(["foo"])).equalsSet(new Set.from(["foo"])));

        shouldFail(() => expect(new Set.from(["foo"])).equalsSet(new Set.from(["bar"])),
          check:   (exception) => exception is ExpectException,
          message: "Expect.setEquals() fails\nExpected collection does not contain: bar \nExpected collection should not contain: foo ");

        shouldFailWithReason(() => expect(new Set.from(["foo"])).equalsSet(new Set.from(["bar"]), reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.setEquals(, 'Cuz I said so') fails\nExpected collection does not contain: bar \nExpected collection should not contain: foo ");
      });

      // Expect.stringEquals(String expected, String actual, [String reason = null])
      example("expect().equalsString", (){
        shouldPass(() => expect("foo").equalsString("foo"));

        shouldFail(() => expect("foo").equalsString("bar"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.stringEquals(expected: <bar>\", <foo>) fails\nDiff:\n...[ bar} ]...\n...[ foo ]...");

        shouldFailWithReason(() => expect("foo").equalsString("bar", reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.stringEquals(expected: <bar>\", <foo>, 'Cuz I said so') fails\nDiff:\n...[ bar} ]...\n...[ foo ]...");
      });

      // Expect.throws(void f(), [_CheckExceptionFn check = null, String reason = null])
      example("expect().throws", (){ 
        shouldPass(() => expect((){ throw new NotImplementedException(); }).throws());

        shouldFail(() => expect(() => null).throws(),
          check:   (exception) => exception is ExpectException,
          message: "Expect.throws() fails");

        shouldFailWithReason(() => expect(() => null).throws(reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.throws(, 'Cuz I said so') fails");

        example("with check", (){ 
          shouldPass(() => expect((){ throw new NotImplementedException(); }).throws((ex) => ex is NotImplementedException));

          shouldFail(() => expect((){ throw new NotImplementedException(); }).throws((ex) => ex is NoSuchMethodException),
            check:   (exception) => exception is ExpectException,
            message: "Expect.isTrue(false) fails.");

          shouldFailWithReason(() => expect((){ throw new NotImplementedException(); }).throws((ex) => ex is NoSuchMethodException, reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.isTrue(false) fails.");
        }); 

      });
    });
  }
}
