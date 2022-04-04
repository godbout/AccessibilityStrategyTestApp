import XCTest
import AccessibilityStrategy


class ASUI_NM_zb_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1) -> AccessibilityTextElement {
        return applyMove { asNormalMode.zb(times: count, on: $0) }
    }
    
}


// TextViews
extension ASUI_NM_zb_Tests {

    func test_that_in_normal_setting_it_puts_the_currentScreenLine_at_the_bottom_of_the_visible_area_and_keeps_the_caretLocation_at_the_same_place() {
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
        let accessibilityElement = applyMoveBeingTested()
    
        XCTAssertEqual(accessibilityElement.caretLocation, 93)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "e")
        XCTAssertEqual(accessibilityElement.fullyVisibleArea, 49..<89)
    }
    
    func test_that_if_on_an_emptyLine_it_works_properly_and_the_emptyLine_ends_at_the_bottom_of_the_visible_area_and_not_after() {
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
