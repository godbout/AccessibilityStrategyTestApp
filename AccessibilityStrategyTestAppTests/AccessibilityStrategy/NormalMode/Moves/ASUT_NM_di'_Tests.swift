@testable import AccessibilityStrategy
import XCTest
import Common


// same mindset as with dF.
// di' calls ci', then reposition the caret.
// because the caret needs repositioning, things are tested in UIT. this wasn't the case
// for one case (when no QuotedString is found) but we moved it in UIT also for consistency.
class ASUT_NM_diSingleQuote_Tests: ASUT_NM_BaseTests {}
