class IncludedExpectationsSpec extends ExpectationsSpec {
  spec() {
    describe("Expectations included with expectations.dart", (){

      describe("toEqual", (){
        it("expect('foo').toEqual('foo')", (){
          expect('foo').toEqual('foo');
        });

        it("expect('foo').toEqual('bar')", (){
          var exception = mustThrowException(() => expect('foo').toEqual('bar'));
          Expect.equals("Expect.equals(expected: <bar>, actual: <foo>) fails.", exception.message);
        });

        it("expect('foo').toNotEqual('foo')");
        it("expect('foo').toNotEqual('bar')");
      });

    });
  }
}
