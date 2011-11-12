#import("../src/expectations.dart");

main() {
  var text = "foo";

  // Without Expectations
  Expect.equals("foo", text);

  // With Expectations (CoreExpectations)
  expect(text).equals("foo");

  // TODO add With ToBeExpectations
}
