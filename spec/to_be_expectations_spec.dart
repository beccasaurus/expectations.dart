class ToBeExpectationsSpec extends ExpectationsSpec {
  spec(){
    example("ToBeExpectations (default expectations)", (){

      before(() => 
        Expectations.onExpect((target) => new ToBeExpectations(target)));

      // Expect.approxEquals(num expected, num actual, [num tolerance = null, String reason = null])
      example("expect().toApproxEqual", (){
        shouldPass(() => expect(1.0000).toApproxEqual(1.0001));

        shouldFail(() => expect(1.0000).toApproxEqual(1.001),
          check:   (exception) => exception is ExpectException,
          message: "Expect.approxEquals(expected:<1.001000>, actual:<1.000000>, tolerance:<0.000100>) fails");

        shouldFailWithReason(() => expect(1.0000).toApproxEqual(1.001, reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.approxEquals(expected:<1.001000>, actual:<1.000000>, tolerance:<0.000100>, 'Cuz I said so') fails");

        example("not", (){
          shouldPass(() => expect(1.0000).not.toApproxEqual(1.001));

          shouldFail(() => expect(1.0000).not.toApproxEqual(1.0001),
            check:   (exception) => exception is ExpectException,
            message: "Expect.not.approxEquals(unexpected:<1.000100>, actual:<1.000000>, tolerance:<0.000100>) fails");

          shouldFailWithReason(() => expect(1.0000).not.toApproxEqual(1.0001, reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.not.approxEquals(unexpected:<1.000100>, actual:<1.000000>, tolerance:<0.000100>, 'Cuz I said so') fails");
        });

        example("with tolerance", (){
          shouldPass(() => expect(1.000).toApproxEqual(1.001, tolerance: 0.1));

          shouldFail(() => expect(1.0000).toApproxEqual(1.1, tolerance: 0.1),
            check:   (exception) => exception is ExpectException,
            message: "Expect.approxEquals(expected:<1.100000>, actual:<1.000000>, tolerance:<0.100000>) fails");

          shouldFailWithReason(() => expect(1.0000).toApproxEqual(1.1, tolerance: 0.1, reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.approxEquals(expected:<1.100000>, actual:<1.000000>, tolerance:<0.100000>, 'Cuz I said so') fails");

          example("not", (){
            shouldPass(() => expect(1.0000).not.toApproxEqual(1.1, tolerance: 0.1));

            shouldFail(() => expect(1.000).not.toApproxEqual(1.001, tolerance: 0.1),
              check:   (exception) => exception is ExpectException,
              message: "Expect.not.approxEquals(unexpected:<1.001000>, actual:<1.000000>, tolerance:<0.100000>) fails");

            shouldFailWithReason(() => expect(1.000).not.toApproxEqual(1.001, tolerance: 0.1, reason: "Cuz I said so"),
              check:   (exception) => exception is ExpectException,
              message: "Expect.not.approxEquals(unexpected:<1.001000>, actual:<1.000000>, tolerance:<0.100000>, 'Cuz I said so') fails");
          });
        });
      });

      // Expect.equals(<dynamic> expected, <dynamic> actual, [String reason = null])
      example("expect().toEqual", (){
        shouldPass(()=> expect(1).toEqual(1));

        shouldFail(() => expect(1).toEqual(999),
          check:   (exception) => exception is ExpectException,
          message: "Expect.equals(expected: <999>, actual: <1>) fails.");

        shouldFailWithReason(() => expect(1).toEqual(999, reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.equals(expected: <999>, actual: <1>, 'Cuz I said so') fails.");

        example("not", (){
          shouldPass(()=> expect(1).not.toEqual(2));

          shouldFail(() => expect(1).not.toEqual(1),
            check:   (exception) => exception is ExpectException,
            message: "Expect.not.equals(unexpected: <1>, actual: <1>) fails.");

          shouldFailWithReason(() => expect(1).not.toEqual(1, reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.not.equals(unexpected: <1>, actual: <1>, 'Cuz I said so') fails.");
        });

        example("alias: expect() == 1", (){
          shouldPass(()=> expect(1) == 1);

          shouldFail(() => expect(1) == 999,
            check:   (exception) => exception is ExpectException,
            message: "Expect.equals(expected: <999>, actual: <1>) fails.");

          example("not", (){
            shouldPass(()=> expect(1).not == 2);

            shouldFail(() => expect(1).not == 1,
              check:   (exception) => exception is ExpectException,
              message: "Expect.not.equals(unexpected: <1>, actual: <1>) fails.");
          });
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

        it(".not is unsupported", (){
          mustThrowException(() => expect().not.fail(),
            check:   (exception) => exception is UnsupportedOperationException,
            message: "UnsupportedOperationException: fail cannot be called with .not");
        });
      });

      // Expect.identical(<dynamic> expected, <dynamic> actual, [String reason = null])
      var object1     = new Object();
      var alsoObject1 = object1;
      var object2     = new Object();
      example("expect().toBe", (){
        shouldPass(() => expect(object1).toBe(alsoObject1));

        shouldFail(() => expect(object1).toBe(object2),
          check:   (exception) => exception is ExpectException,
          message: "Expect.identical(expected: <Instance of 'Object'>, actual: <Instance of 'Object'>) fails.");

        shouldFailWithReason(() => expect(object1).toBe(object2, reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.identical(expected: <Instance of 'Object'>, actual: <Instance of 'Object'>, 'Cuz I said so') fails.");

        example("not", (){
          shouldPass(() => expect(object1).not.toBe(object2));

          shouldFail(() => expect(object1).not.toBe(alsoObject1),
            check:   (exception) => exception is ExpectException,
            message: "Expect.not.identical(unexpected: <Instance of 'Object'>, actual: <Instance of 'Object'>) fails.");

          shouldFailWithReason(() => expect(object1).not.toBe(alsoObject1, reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.not.identical(unexpected: <Instance of 'Object'>, actual: <Instance of 'Object'>, 'Cuz I said so') fails.");
        });
      });

      // Expect.isFalse(<dynamic> actual, [String reason = null])
      example("expect().toBeFalse", (){
        shouldPass(() => expect(false).toBeFalse());

        shouldFail(() => expect(true).toBeFalse(),
          check:   (exception) => exception is ExpectException,
          message: "Expect.isFalse(true) fails.");

        shouldFailWithReason(() => expect(true).toBeFalse(reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.isFalse(true, 'Cuz I said so') fails.");

        it(".not is unsupported", (){
          mustThrowException(() => expect(false).not.toBeFalse(),
            check:   (exception) => exception is UnsupportedOperationException,
            message: "UnsupportedOperationException: toBeFalse cannot be called with .not");
        });
      });

      // Expect.isNotNull(<dynamic> actual, [String reason = null])
      example("expect().toNotBeNull", (){
        shouldPass(() => expect("Not NULL").toNotBeNull());

        shouldFail(() => expect(null).toNotBeNull(),
          check:   (exception) => exception is ExpectException,
          message: "Expect.isNotNull(actual: <null>) fails.");

        shouldFailWithReason(() => expect(null).toNotBeNull(reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.isNotNull(actual: <null>, 'Cuz I said so') fails.");

        it(".not is unsupported", (){
          mustThrowException(() => expect(null).not.toNotBeNull(),
            check:   (exception) => exception is UnsupportedOperationException,
            message: "UnsupportedOperationException: toNotBeNull cannot be called with .not");
        });
      });

      // Expect.isNull(<dynamic> actual, [String reason = null])
      example("expect().toBeNull", (){
        shouldPass(() => expect(null).toBeNull());

        shouldFail(() => expect("Not NULL").toBeNull(),
          check:   (exception) => exception is ExpectException,
          message: "Expect.isNull(actual: <Not NULL>) fails.");

        shouldFailWithReason(() => expect("Not NULL").toBeNull(reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.isNull(actual: <Not NULL>, 'Cuz I said so') fails.");

        example("not", (){
          shouldPass(() => expect("Not NULL").not.toBeNull());

          shouldFail(() => expect(null).not.toBeNull(),
            check:   (exception) => exception is ExpectException,
            message: "Expect.not.isNull(null) fails.");

          shouldFailWithReason(() => expect(null).not.toBeNull(reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.not.isNull(null, 'Cuz I said so') fails.");
        });
      });

      // Expect.isTrue(<dynamic> actual, [String reason = null])
      example("expect().toBeTrue", (){
        shouldPass(() => expect(true).toBeTrue());

        shouldFail(() => expect(false).toBeTrue(),
          check:   (exception) => exception is ExpectException,
          message: "Expect.isTrue(false) fails.");

        shouldFailWithReason(() => expect(false).toBeTrue(reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.isTrue(false, 'Cuz I said so') fails.");

        example("not", (){
          shouldPass(() => expect(false).not.toBeTrue());

          shouldFail(() => expect(true).not.toBeTrue(),
            check:   (exception) => exception is ExpectException,
            message: "Expect.not.isTrue(true) fails.");

          shouldFailWithReason(() => expect(true).not.toBeTrue(reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.not.isTrue(true, 'Cuz I said so') fails.");
        });
      });

      // Expect.listEquals(List<E> expected, List<E> actual, [String reason = null])
      example("expect().toEqualList", (){
        shouldPass(() => expect(["foo"]).toEqualList(["foo"]));

        shouldFail(() => expect(["foo"]).toEqualList(["bar"]),
          check:   (exception) => exception is ExpectException,
          message: "Expect.listEquals(at index 0, expected: <bar>, actual: <foo>) fails");

        shouldFailWithReason(() => expect(["foo"]).toEqualList(["bar"], reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.listEquals(at index 0, expected: <bar>, actual: <foo>, 'Cuz I said so') fails");

        example("not", (){
          shouldPass(() => expect(["foo"]).not.toEqualList(["bar"]));

          shouldFail(() => expect(["foo"]).not.toEqualList(["foo"]),
            check:   (exception) => exception is ExpectException,
            message: "Expect.not.listEquals([foo]) fails");

          shouldFailWithReason(() => expect(["foo"]).not.toEqualList(["foo"], reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.not.listEquals([foo], 'Cuz I said so') fails");
        });
      });

      // Expect.notEquals(<dynamic> unexpected, <dynamic> actual, [String reason = null])
      example("expect().toNotEqual", (){
        shouldPass(()=> expect(1).toNotEqual(999));

        shouldFail(() => expect(1).toNotEqual(1),
          check:   (exception) => exception is ExpectException,
          message: "Expect.notEquals(unexpected: <1>, actual:<1>) fails.");

        shouldFailWithReason(() => expect(1).toNotEqual(1, reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.notEquals(unexpected: <1>, actual:<1>, 'Cuz I said so') fails.");

        it(".not is unsupported", (){
          mustThrowException(() => expect(null).not.toNotEqual(999),
            check:   (exception) => exception is UnsupportedOperationException,
            message: "UnsupportedOperationException: toNotEqual cannot be called with .not");
        });
      });

      // Expect.setEquals(Iterable<E> expected, Iterable<E> actual, [String reason = null])
      example("expect().toEqualSet", (){
        shouldPass(() => expect(new Set.from(["foo"])).toEqualSet(new Set.from(["foo"])));

        shouldFail(() => expect(new Set.from(["foo"])).toEqualSet(new Set.from(["bar"])),
          check:   (exception) => exception is ExpectException,
          message: "Expect.setEquals() fails\nExpected collection does not contain: bar \nExpected collection should not contain: foo ");

        shouldFailWithReason(() => expect(new Set.from(["foo"])).toEqualSet(new Set.from(["bar"]), reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.setEquals(, 'Cuz I said so') fails\nExpected collection does not contain: bar \nExpected collection should not contain: foo ");

        example("not", (){
          shouldPass(() => expect(new Set.from(["foo"])).not.toEqualSet(new Set.from(["bar"])));

          shouldFail(() => expect(new Set.from(["foo"])).not.toEqualSet(new Set.from(["foo"])),
            check:   (exception) => exception is ExpectException,
            message: "Expect.not.setEquals([foo]) fails");

          shouldFailWithReason(() => expect(new Set.from(["foo"])).not.toEqualSet(new Set.from(["foo"]), reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.not.setEquals([foo], 'Cuz I said so') fails");
        });
      });

      // Expect.stringEquals(String expected, String actual, [String reason = null])
      example("expect().toEqualString", (){
        shouldPass(() => expect("foo").toEqualString("foo"));

        shouldFail(() => expect("foo").toEqualString("bar"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.stringEquals(expected: <bar>\", <foo>) fails\nDiff:\n...[ bar} ]...\n...[ foo ]...");

        shouldFailWithReason(() => expect("foo").toEqualString("bar", reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.stringEquals(expected: <bar>\", <foo>, 'Cuz I said so') fails\nDiff:\n...[ bar} ]...\n...[ foo ]...");

        example("not", (){
          shouldPass(() => expect("foo").not.toEqualString("bar"));

          shouldFail(() => expect("foo").not.toEqualString("foo"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.not.stringEquals('foo') fails");

          shouldFailWithReason(() => expect("foo").not.toEqualString("foo", reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.not.stringEquals('foo', 'Cuz I said so') fails");
          });
      });

      // Expect.throws(void f(), [_CheckExceptionFn check = null, String reason = null])
      example("expect().toThrow", (){ 
        shouldPass(() => expect((){ throw new NotImplementedException(); }).toThrow());

        shouldFail(() => expect(() => null).toThrow(),
          check:   (exception) => exception is ExpectException,
          message: "Expect.throws() fails");

        shouldFailWithReason(() => expect(() => null).toThrow(reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.throws(, 'Cuz I said so') fails");

        example("not", (){
          shouldPass(() => expect((){ }).not.toThrow());

          shouldFail(() => expect((){ throw new NotImplementedException(); }).not.toThrow(),
            check:   (exception) => exception is ExpectException,
            message: "Expect.not.throws(unexpected: <NotImplementedException>) fails");

          shouldFailWithReason(() => expect((){ throw new NotImplementedException(); }).not.toThrow(reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.not.throws(unexpected: <NotImplementedException>, 'Cuz I said so') fails");
        });

        example("with check", (){ 
          shouldPass(() => expect((){ throw new NotImplementedException(); }).toThrow((ex) => ex is NotImplementedException));

          shouldFail(() => expect((){ throw new NotImplementedException(); }).toThrow((ex) => ex is NoSuchMethodException),
            check:   (exception) => exception is ExpectException,
            message: "Expect.isTrue(false) fails.");

          shouldFailWithReason(() => expect((){ throw new NotImplementedException(); }).toThrow((ex) => ex is NoSuchMethodException, reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.isTrue(false) fails.");

          it(".not is unsupported", (){
            mustThrowException(() => expect().not.toThrow(check: (){}),
              check:   (exception) => exception is UnsupportedOperationException,
              message: "UnsupportedOperationException: the :check parameter of toThrow() is unsupported when called with .not");
          });
        }); 

      });

    });
  }
}
