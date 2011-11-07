class IncludedExpectationsSpec extends ExpectationsSpec {
  spec() {
    describe("Expectations included with expectations.dart", (){

      describe("expect.toEqual", (){
        it("pass", () => expect(1).toEqual(1));

        it("fail", () =>
          mustThrowException(() => expect(1).toEqual(999),
            check:   (exception) => exception is ExpectException,
            message: "Expect.equals(expected: <999>, actual: <1>) fails."));

        it("fail with reason", () =>
          mustThrowException(() => expect(1).toEqual(999, reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.equals(expected: <999>, actual: <1>, 'Cuz I said so') fails."));
      });

      describe("toNotEqual", (){
        it("pass", () => expect("foo").toNotEqual("BAR"));

        it("fail", () =>
          mustThrowException(() => expect('foo').toNotEqual('foo'),
            check:   (exception) => exception is ExpectException,
            message: "Expect.notEquals(unexpected: <foo>, actual:<foo>) fails."));

        it("fail with reason", () =>
          mustThrowException(() => expect('foo').toNotEqual('foo', reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.notEquals(unexpected: <foo>, actual:<foo>, 'Cuz I said so') fails."));
      });

      describe("toApproxEqual", (){
        it("pass", () => expect(1.0000).toApproxEqual(1.0001));

        it("fail", () =>
          mustThrowException(() => expect(1.0000).toApproxEqual(1.001),
            check:   (exception) => exception is ExpectException,
            message: "Expect.approxEquals(expected:<1.001000>, actual:<1.000000>, tolerance:<0.000100>) fails"));

        it("fail", () =>
          mustThrowException(() => expect(1.0000).toApproxEqual(1.001, reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.approxEquals(expected:<1.001000>, actual:<1.000000>, tolerance:<0.000100>, 'Cuz I said so') fails"));
      });

      describe("toApproxEqual with tolerance", (){
        it("pass", () => expect(1.000).toApproxEqual(1.001, tolerance: 0.1));

        it("fail", () =>
          mustThrowException(() => expect(1.0000).toApproxEqual(1.1, tolerance: 0.1),
            check:   (exception) => exception is ExpectException,
            message: "Expect.approxEquals(expected:<1.100000>, actual:<1.000000>, tolerance:<0.100000>) fails"));

        it("fail with reason", () =>
          mustThrowException(() => expect(1.0000).toApproxEqual(1.1, tolerance: 0.1, reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.approxEquals(expected:<1.100000>, actual:<1.000000>, tolerance:<0.100000>, 'Cuz I said so') fails"));
      });

      // This one's being fussy - come back to it
      // describe("toBeIdenticalTo", (){
      //   it("pass", () => expect(1).toBeIdenticalTo(1));

      //   it("fail", () =>
      //     mustThrowException(() => expect(new Object()).toBeIdenticalTo(new Object()),
      //       check:   (exception) => exception is ExpectException,
      //       message: "Expect.identical(expected: <Instance of 'Library:'dart:core' Class: Object'>, actual: <Instance of 'Library:'dart:core' Class: Object'>) fails."));

      //   it("fail with reason", () =>
      //     mustThrowException(() => expect(new Object()).toBeIdenticalTo(new Object(), reason: "Cuz I said so"),
      //       check:   (exception) => exception is ExpectException,
      //       message: "Expect.identical(expected: <Instance of 'Library:'dart:core' Class: Object'>, actual: <Instance of 'Library:'dart:core' Class: Object'>, 'Cuz I said so') fails."));
      // });

      describe("toBeTrue", (){
        it("pass", () => expect(true).toBeTrue());

        it("fail", () =>
          mustThrowException(() => expect(false).toBeTrue(),
            check:   (exception) => exception is ExpectException,
            message: "Expect.isTrue(false) fails."));

        it("fail with reason", () =>
          mustThrowException(() => expect(false).toBeTrue(reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.isTrue(false, 'Cuz I said so') fails."));
      });

      describe("toBeFalse", (){
        it("pass", () => expect(false).toBeFalse());

        it("fail", () =>
          mustThrowException(() => expect(true).toBeFalse(),
            check:   (exception) => exception is ExpectException,
            message: "Expect.isFalse(true) fails."));

        it("fail with reason", () =>
          mustThrowException(() => expect(true).toBeFalse(reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.isFalse(true, 'Cuz I said so') fails."));
      });

      describe("toBeNull", (){
        it("pass", () => expect(null).toBeNull());

        it("fail", () =>
          mustThrowException(() => expect("Not NULL").toBeNull(),
            check:   (exception) => exception is ExpectException,
            message: "Expect.isNull(actual: <Not NULL>) fails."));

        it("fail with reason", () =>
          mustThrowException(() => expect("Not NULL").toBeNull(reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.isNull(actual: <Not NULL>, 'Cuz I said so') fails."));
      });

      describe("toNotBeNull", (){
        it("pass", () => expect("Not NULL").toNotBeNull());

        it("fail", () =>
          mustThrowException(() => expect(null).toNotBeNull(),
            check:   (exception) => exception is ExpectException,
            message: "Expect.isNotNull(actual: <null>) fails."));

        it("fail with reason", () =>
          mustThrowException(() => expect(null).toNotBeNull(reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.isNotNull(actual: <null>, 'Cuz I said so') fails."));
      });

      describe("toEqualString", (){
        it("pass", () => expect("foo").toEqualString("foo"));

        it("fail", () =>
          mustThrowException(() => expect("foo").toEqualString("bar"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.stringEquals(expected: <bar>\", <foo>) fails\nDiff:\n...[ bar} ]...\n...[ foo ]..."));

        it("fail with reason", () =>
          mustThrowException(() => expect("foo").toEqualString("bar", reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.stringEquals(expected: <bar>\", <foo>, 'Cuz I said so') fails\nDiff:\n...[ bar} ]...\n...[ foo ]..."));
      });

      describe("toEqualList", (){
        it("pass", () => expect(["foo"]).toEqualList(["foo"]));

        it("fail", () =>
          mustThrowException(() => expect(["foo"]).toEqualList(["bar"]),
            check:   (exception) => exception is ExpectException,
            message: "Expect.listEquals(at index 0, expected: <bar>, actual: <foo>) fails"));

        it("fail with reason", () =>
          mustThrowException(() => expect(["foo"]).toEqualList(["bar"], reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.listEquals(at index 0, expected: <bar>, actual: <foo>, 'Cuz I said so') fails"));
      });

      describe("toEqualSet", (){
        it("pass", () => expect(new Set.from(["foo"])).toEqualSet(new Set.from(["foo"])));

        it("fail", () =>
          mustThrowException(() => expect(new Set.from(["foo"])).toEqualSet(new Set.from(["bar"])),
            check:   (exception) => exception is ExpectException,
            message: "Expect.setEquals() fails\nExpected collection does not contain: bar \nExpected collection should not contain: foo "));

        it("fail with reason", () =>
          mustThrowException(() => expect(new Set.from(["foo"])).toEqualSet(new Set.from(["bar"]), reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.setEquals(, 'Cuz I said so') fails\nExpected collection does not contain: bar \nExpected collection should not contain: foo "));
      });

      describe("toThrow", (){
        it("pass", () => expect((){ throw new NotImplementedException(); }).toThrow());

        it("fail", () =>
          mustThrowException(() => expect(() => null).toThrow(),
            check:   (exception) => exception is ExpectException,
            message: "Expect.throws() fails"));

        it("fail with reason", () =>
          mustThrowException(() => expect(() => null).toThrow(reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.throws(, 'Cuz I said so') fails"));
      });

      describe("toThrow with check", (){
        it("pass", () => expect((){ throw new NotImplementedException(); }).toThrow((ex) => ex is NotImplementedException));

        it("fail", () =>
          mustThrowException(() => expect((){ throw new NotImplementedException(); }).toThrow((ex) => ex is NoSuchMethodException),
            check:   (exception) => exception is ExpectException,
            message: "Expect.isTrue(false) fails."));

        it("fail with reason", () =>
          mustThrowException(() => expect((){ throw new NotImplementedException(); }).toThrow((ex) => ex is NoSuchMethodException, reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.isTrue(false) fails."));
      });
      
    });
  }
}
