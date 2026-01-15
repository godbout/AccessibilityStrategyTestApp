import XCTest
import AccessibilityStrategy


class ASUI_NM_zz_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1) -> AccessibilityTextElement {
        return applyMove { asNormalMode.zz(times: count, on: $0) }
    }
    
}


// TextViews
extension ASUI_NM_zz_Tests {

    func test_that_in_normal_setting_it_puts_the_currentScreenLine_in_the_middle_of_the_visible_area_and_keeps_the_caretLocation_at_the_same_place() {
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
        applyMove { asNormalMode.G(times: 8, on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
    
        XCTAssertEqual(accessibilityElement.caretLocation, 68)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "n")
        XCTAssertEqual(accessibilityElement.fullyVisibleArea, 27..<81)
    }
    
    func test_that_if_on_an_EmptyLine_it_works_properly_and_the_EmptyLine_ends_at_the_middle_of_the_visible_area() {
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
        applyMove { asNormalMode.G(times: 9, on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
    
        XCTAssertEqual(accessibilityElement.caretLocation, 71)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "\n")
        XCTAssertEqual(accessibilityElement.fullyVisibleArea, 37..<81)
    }

}
