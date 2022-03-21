import XCTest
import AccessibilityStrategy


class ASUI_NM_H__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1) -> AccessibilityTextElement {
        return applyMove { asNormalMode.H(times: count, on: $0) }
    }
    
}


// scroll
extension ASUI_NM_H__Tests {
    
    func test_that_it_does_not_scroll() {
        let textInAXFocusedElement = """
 this definitely can't be tested in UT coz it would return nil coz visible character range
"""

        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(times: 3)

        print(accessibilityElement.shouldScroll)
        XCTAssertFalse(accessibilityElement.shouldScroll)
    }

}


// count
extension ASUI_NM_H__Tests {

    func test_that_it_implements_the_count_system() {
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
        
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(times: 3)

        XCTAssertEqual(accessibilityElement.caretLocation, 72)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_if_the_count_is_too_high_it_ends_up_on_the_firstNonBlank_of_the_lowest_screenLine() {
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
        
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(times: 69)

        XCTAssertEqual(accessibilityElement.caretLocation, 98)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
}


// TextViews
extension ASUI_NM_H__Tests {

    func test_that_in_normal_setting_it_goes_to_the_firstNonBlank_of_the_highest_screenLine() {
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
        
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.caretLocation, 61)
        XCTAssertEqual(accessibilityElement.selectedLength, 2)
    }
    
}
