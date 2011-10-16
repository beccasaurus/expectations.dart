class IncludedExpectationsSpec extends ExpectationsSpec {
  spec() {
    describe("Expectations included with expectations.dart", (){

      describe("expect('foo').toEqual", (){
        it("pass", () => expect("foo").toEqual("foo"));
        it("fail", (){
          var exception = mustThrowException(
            code:    () => expect('foo').toEqual('bar'),
            check:   (exception) => exception is ExpectException,
            message: "Expect.equals(expected: <bar>, actual: <foo>) fails."
          );
        });
      });

      describe("expect('foo').toNotEqual", (){
      });

      describe("expect(').toEqual", (){
        it("expect('foo').toEqual('foo')", (){
          expect('foo').toEqual('foo');
        });

        it("expect('foo').toEqual('bar')", (){
          var exception = mustThrowException(() => expect('foo').toEqual('bar'));
          Expect.equals("Expect.equals(expected: <bar>, actual: <foo>) fails.", exception.toString());
        });

        it("expect('foo').toNotEqual('bar')", (){
          expect('foo').toNotEqual('bar');
        });

        it("expect('foo').toNotEqual('foo')", (){
          var exception = mustThrowException(() => expect('foo').toNotEqual('foo'));
          Expect.equals("Expect.notEquals(unexpected: <foo>, actual:<foo>) fails.", exception.toString());
        });
      });

      describe("expect().toApproxEqual", (){
        it("expect(1.0000).toApproxEqual(1.0001)", (){
          expect(1.0000).toApproxEqual(1.0001);
        });

        it("expect(1.000).toApproxEqual(1.001, tolerance: 0.1)", (){
          expect(1.000).toApproxEqual(1.001, tolerance: 0.1);
        });
      });
    });
  }
}
