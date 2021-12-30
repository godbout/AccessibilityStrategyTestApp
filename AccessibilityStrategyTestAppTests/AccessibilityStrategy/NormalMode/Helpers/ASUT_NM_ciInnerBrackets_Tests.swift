@testable import AccessibilityStrategy
import XCTest


// this move uses FT innerBrackets which is already tested on its own.
// FT innerBrackets returns the range of the text found, but doesn't care if the text
// spans on a line or several. this is up to ciInnerBrackets to handle this, which is
// what we need to test.
// the tests that were here have been moved to UI Tests now that ciInnerBrackets needs to handle PGR.
// also so other stuff like going back to IM or NM have to be tested through UI.
class ASUT_NM_ciInnerBrackets_Tests: ASUT_NM_BaseTests {}
