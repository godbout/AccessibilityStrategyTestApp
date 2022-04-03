import XCTest
import AccessibilityStrategy


// H L M should work on FileLines (they did at first)
// but Vim owns its own buffer, and always make the start of the buffer by a FieLine
// in macOS we can't (at least currently, too much work) so sometimes using H L M may
// bring the caretLocation out of visibility. for now i decide to use ScreenLines instead.
// let's see if users prefer it like this or not.
class ASUI_NM_H__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1) -> AccessibilityTextElement {
        return applyMove { asNormalMode.H(times: count, on: $0) }
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
        
        applyMove { asNormalMode.G(times: 5, on: $0) }
        let accessibilityElement = applyMoveBeingTested(times: 7)
    
        XCTAssertEqual(accessibilityElement.caretLocation, 60)
        XCTAssertEqual(accessibilityElement.selectedLength, 2)
        XCTAssertEqual(accessibilityElement.selectedText, "😂")
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
        
        applyMove { asNormalMode.G(times: 5, on: $0) }
        let accessibilityElement = applyMoveBeingTested(times: 100)
    
        XCTAssertEqual(accessibilityElement.caretLocation, 74)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "\n")
    }

}


// TextViews
extension ASUI_NM_H__Tests {
    
    func test_that_if_the_text_is_scrolled_to_the_top_then_it_goes_to_the_firstNonBlank_of_the_first_line() {
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
    
        XCTAssertEqual(accessibilityElement.caretLocation, 1)
        XCTAssertEqual(accessibilityElement.selectedLength, 2)
        XCTAssertEqual(accessibilityElement.selectedText, "😂")
    }

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
        
        let accessibilityElement = applyMoveBeingTested()
    
        XCTAssertEqual(accessibilityElement.caretLocation, 67)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "a")
    }

}
