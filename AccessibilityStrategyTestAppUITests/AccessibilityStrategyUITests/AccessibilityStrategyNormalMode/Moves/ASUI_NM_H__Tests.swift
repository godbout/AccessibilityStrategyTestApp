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
        XCTAssertEqual(accessibilityElement.fullyVisibleArea, 0..<75)
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
        XCTAssertEqual(accessibilityElement.fullyVisibleArea, 0..<75)
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
        XCTAssertEqual(accessibilityElement.fullyVisibleArea, 0..<75)
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
        XCTAssertEqual(accessibilityElement.fullyVisibleArea, 67..<106)
    }
    
    func test_that_the_text_is_not_scrolled_even_with_FileLines() {
        let textInAXFocusedElement = """
It was the White Rabbit, trotting slowly back again, and looking anxiously about as it went, as if it had lost something; and she heard it muttering to itself “The Duchess! The Duchess! Oh my dear paws! Oh my fur and whiskers! She’ll get me executed, as sure as ferrets are ferrets! Where can I have dropped them, I wonder?” Alice guessed in a moment that it was looking for the fan and the pair of white kid gloves, and she very good-naturedly began hunting about for them, but they were nowhere to be seen—everything seemed to have changed since her swim in the pool, and the great hall, with the glass table and the little door, had vanished completely.
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.interrogationMark(to: "looking", on: $0) }
        let accessibilityElement = applyMoveBeingTested()
    
        XCTAssertEqual(accessibilityElement.caretLocation, 241)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "e")
        XCTAssertEqual(accessibilityElement.fullyVisibleArea, 241..<489)
    }

}
