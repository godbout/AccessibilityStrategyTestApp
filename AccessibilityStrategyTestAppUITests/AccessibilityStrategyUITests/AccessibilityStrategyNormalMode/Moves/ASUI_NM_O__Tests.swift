import XCTest
@testable import AccessibilityStrategy


// see ASUT O for blah blah
class ASUI_NM_O__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asNormalMode.O(on: $0) }
    }
    
}


// TextViews
extension ASUI_NM_O__Tests {
    
    func test_that_if_at_the_first_line_it_creates_a_new_line_above_and_reposition_the_caret_on_that_new_line() {
        let textInAXFocusedElement = """
caret on the first
line and it should
still create a line above
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
               
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.dollarSign(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.fileText.value, """

caret on the first
line and it should
still create a line above
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
    }
    
    func test_that_if_keeps_the_indentation_even_if_it_is_on_the_first_line() {
        let textInAXFocusedElement = """
   now indent on the first line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)

        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.fileText.value, """
   
   now indent on the first line
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 3)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
    }
    
}
