class CustomExpectationsSpec extends ExpectationsSpec {
  spec() {
    describe("Custom Expectations", (){

      it("throws a useful NoSuchMethodException when expectation method is not found");
      it("throws a useful NoSuchMethodException if expect() is called but there are no Expectations");

      describe("adding expectations by extending Expectations");
      describe("overriding expectations by extending Expectations");
      describe("adding expectations by registering new Expectations instances");

    });
  }
}
