class CoreExpectationsSpec extends ExpectationsSpec {
  spec(){
    example("CoreExpectations (default expectations)", (){

      before(() => 
        Expectations.onExpect((target) => new CoreExpectations(target)));

      example("expect() == 1", (){
        shouldPass(()=> expect(1) == 1);

        shouldFail(() => expect(1) == 999,
          check:   (exception) => exception is ExpectException,
          message: "Expect.equals(expected: <999>, actual: <1>) fails.");
      });

      example("expect().equals(1)", (){
        shouldPass(()=> expect(1).equals(1));

        shouldFail(() => expect(1).equals(999),
          check:   (exception) => exception is ExpectException,
          message: "Expect.equals(expected: <999>, actual: <1>) fails.");

        shouldFailWithReason(() => expect(1).equals(999, reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.equals(expected: <999>, actual: <1>, 'Cuz I said so') fails.");
      });

      example("expect().approxEquals", (){
        shouldPass(() => expect(1.0000).approxEquals(1.0001));

        shouldFail(() => expect(1.0000).approxEquals(1.001),
          check:   (exception) => exception is ExpectException,
          message: "Expect.approxEquals(expected:<1.001000>, actual:<1.000000>, tolerance:<0.000100>) fails");

        shouldFailWithReason(() => expect(1.0000).approxEquals(1.001, reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.approxEquals(expected:<1.001000>, actual:<1.000000>, tolerance:<0.000100>, 'Cuz I said so') fails");
      });

      example("expect().approxEquals with tolerance", (){
        shouldPass(() => expect(1.000).approxEquals(1.001, tolerance: 0.1));

        shouldFail(() => expect(1.0000).approxEquals(1.1, tolerance: 0.1),
          check:   (exception) => exception is ExpectException,
          message: "Expect.approxEquals(expected:<1.100000>, actual:<1.000000>, tolerance:<0.100000>) fails");

        shouldFailWithReason(() => expect(1.0000).approxEquals(1.1, tolerance: 0.1, reason: "Cuz I said so"),
          check:   (exception) => exception is ExpectException,
          message: "Expect.approxEquals(expected:<1.100000>, actual:<1.000000>, tolerance:<0.100000>, 'Cuz I said so') fails");
      });

      example("isNull", (){
        shouldPass(() => expect(null).isNull());

        it("fail", () =>
          mustThrowException(() => expect("Not NULL").isNull(),
            check:   (exception) => exception is ExpectException,
            message: "Expect.isNull(actual: <Not NULL>) fails."));

        it("fail with reason", () =>
          mustThrowException(() => expect("Not NULL").isNull(reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.isNull(actual: <Not NULL>, 'Cuz I said so') fails."));
      });

      example("isNotNull", (){
        shouldPass(() => expect("Not NULL").isNotNull());

        it("fail", () =>
          mustThrowException(() => expect(null).isNotNull(),
            check:   (exception) => exception is ExpectException,
            message: "Expect.isNotNull(actual: <null>) fails."));

        it("fail with reason", () =>
          mustThrowException(() => expect(null).isNotNull(reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.isNotNull(actual: <null>, 'Cuz I said so') fails."));
      });

      example("isTrue", (){
        shouldPass(() => expect(true).isTrue());

        it("fail", () =>
          mustThrowException(() => expect(false).isTrue(),
            check:   (exception) => exception is ExpectException,
            message: "Expect.isTrue(false) fails."));

        it("fail with reason", () =>
          mustThrowException(() => expect(false).isTrue(reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.isTrue(false, 'Cuz I said so') fails."));
      });

      example("isFalse", (){
        shouldPass(() => expect(false).isFalse());

        it("fail", () =>
          mustThrowException(() => expect(true).isFalse(),
            check:   (exception) => exception is ExpectException,
            message: "Expect.isFalse(true) fails."));

        it("fail with reason", () =>
          mustThrowException(() => expect(true).isFalse(reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.isFalse(true, 'Cuz I said so') fails."));
      });

      example("equalsCollection", (){
        it("pass", () => expect(["foo"]).equalsCollection(["foo"]));

        it("fail", () =>
          mustThrowException(() => expect(["foo"]).equalsCollection(["bar"]),
            check:   (exception) => exception is ExpectException,
            message: "Expect.listEquals(at index 0, expected: <bar>, actual: <foo>) fails"));

        it("fail with reason", () =>
          mustThrowException(() => expect(["foo"]).equalsCollection(["bar"], reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.listEquals(at index 0, expected: <bar>, actual: <foo>, 'Cuz I said so') fails"));
      });

      example("equalsSet", (){
        it("pass", () => expect(new Set.from(["foo"])).equalsSet(new Set.from(["foo"])));

        it("fail", () =>
          mustThrowException(() => expect(new Set.from(["foo"])).equalsSet(new Set.from(["bar"])),
            check:   (exception) => exception is ExpectException,
            message: "Expect.setEquals() fails\nExpected collection does not contain: bar \nExpected collection should not contain: foo "));

        it("fail with reason", () =>
          mustThrowException(() => expect(new Set.from(["foo"])).equalsSet(new Set.from(["bar"]), reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.setEquals(, 'Cuz I said so') fails\nExpected collection does not contain: bar \nExpected collection should not contain: foo "));
      });
    });
  }
}
