import XCTest
import AccessibilityStrategy


class ASUI_NM_M__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement {
        return applyMove { asNormalMode.M(on: $0) }
    }
    
}


// TextViews
extension ASUI_NM_M__Tests {

    func test_that_it_goes_hald_between_the_highest_screeLine_and_the_lowest_screenLine() {
        let textInAXFocusedElement = """
 😂k so now we're
going to
have very

long lines
so that 
   😂he H
and

M

  😂and
L

can be
tested

  🐍roperly!
"""

        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.caretLocation, 78)
        XCTAssertEqual(accessibilityElement.selectedLength, 2)
    }
    
}
