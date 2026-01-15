import XCTest
import AccessibilityStrategy


class ASUI_NM_zMinus_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1) -> AccessibilityTextElement {
        return applyMove { asNormalMode.zMinus(times: count, on: $0) }
    }
    
}


// TextViews
extension ASUI_NM_zMinus_Tests {

    func test_that_in_normal_setting_it_puts_the_currentScreenLine_at_the_bottom_of_the_visible_area_and_sets_the_caretLocation_to_the_firstNonBlank_of_the_line() {
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
        applyMove { asNormalMode.interrogationMark(to: "ed", on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
    
        XCTAssertEqual(accessibilityElement.caretLocation, 91)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "t")
        XCTAssertEqual(accessibilityElement.fullyVisibleArea, 49..<89)
    }
    
    func test_that_if_on_an_EmptyLine_it_works_properly_and_the_EmptyLine_ends_at_the_bottom_of_the_visible_area_and_not_after() {
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
        applyMove { asNormalMode.G(times: 14, on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
    
        XCTAssertEqual(accessibilityElement.caretLocation, 81)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "\n")
        XCTAssertEqual(accessibilityElement.fullyVisibleArea, 37..<81)
    }

}
