class IncludedExpectationsSpec extends ExpectationsSpec {
  spec() {
    describe("Expectations included with expectations.dart", (){

      describe("expect('foo').toEqual", (){
        it("pass", () => expect("foo").toEqual("foo"));

        it("fail", () =>
          mustThrowException(() => expect('foo').toEqual('BAR'),
            check:   (exception) => exception is ExpectException,
            message: "Expect.equals(expected: <BAR>, actual: <foo>) fails."));

        it("fail with reason", () =>
          mustThrowException(() => expect('foo').toEqual('BAR', reason: "Cuz I said so"),
            check:   (exception) => exception is ExpectException,
            message: "Expect.equals(expected: <BAR>, actual: <foo>, 'Cuz I said so') fails."));
      });

      describe("expect('foo').toNotEqual", (){
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

      describe("expect(1.0000).toApproxEqual", (){
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

      describe("expect(1.0000).toApproxEqual with tolerance", (){
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

    });
  }
}
