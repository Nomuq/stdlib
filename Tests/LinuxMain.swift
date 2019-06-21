import XCTest

import ioTests

var tests = [XCTestCaseEntry]()
tests += ioTests.allTests()
XCTMain(tests)
