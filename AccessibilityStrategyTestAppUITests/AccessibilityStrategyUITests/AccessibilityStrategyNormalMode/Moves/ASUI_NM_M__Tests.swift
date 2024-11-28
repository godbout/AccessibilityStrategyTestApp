import XCTest
import AccessibilityStrategy


// see H for blah blah
class ASUI_NM_M__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement {
        return applyMove { asNormalMode.M(on: $0) }
    }
    
}


// TextViews
extension ASUI_NM_M__Tests {

    func test_that_it_goes_half_between_the_highest_screenLine_and_the_lowest_screenLine() {
        let textInAXFocusedElement = """
 😂k so now we're
going to
have very

long lines
so that
   😂he H
and

M

and
L

can be
tested

properly!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.G(times: 7, on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
    
        XCTAssertEqual(accessibilityElement.caretLocation, 49)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "s")
        XCTAssertEqual(accessibilityElement.fullyVisibleArea, 0..<75)
    }

}
