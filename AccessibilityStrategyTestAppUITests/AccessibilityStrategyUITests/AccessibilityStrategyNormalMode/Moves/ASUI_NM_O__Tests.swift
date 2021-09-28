import XCTest
import AccessibilityStrategy


class ASUI_NM_O__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asNormalMode.O(on: $0) }
    }
    
}


// TextViews
extension ASUI_NM_O__Tests {
    
    func test_that_in_normal_setting_it_creates_a_new_line_above_the_current_one() {
        let textInAXFocusedElement = """
tha😄️t's a mu😄️ltiline
an😄️😄️d O will
create a n😄️ew line
abo😄️ve!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
                
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.text.value, """
tha😄️t's a mu😄️ltiline

an😄️😄️d O will
create a n😄️ew line
abo😄️ve!
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 25)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
    }
    
    func test_that_if_at_the_first_line_it_will_create_a_new_line_above() {
        let textInAXFocusedElement = """
caret on the first
line and it should
still create a line above
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
               
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.text.value, """

caret on the first
line and it should
still create a line above
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
    }

    func test_that_if_on_an_empty_line_it_will_still_create_a_line_above() {
        let textInAXFocusedElement = """
there is now

an empty line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.text.value, """
there is now


an empty line
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 13)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
    }

    func test_that_if_on_the_last_empty_line_it_creates_a_line_below_and_the_caret_stays_on_the_current_line() {
        let textInAXFocusedElement = """
now the caret
will be on
the last empty line

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)

        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.text.value, """
now the caret
will be on
the last empty line


"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 45)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
    }

    func test_that_if_on_the_last_non_empty_line_it_creates_a_line_below_and_the_caret_stays_on_the_current_line() {
        let textInAXFocusedElement = """
now the caret
will be on
the last empty line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)

        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.text.value, """
now the caret
will be on

the last empty line
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 25)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
    }

    func test_that_it_creates_a_line_above_and_goes_to_the_same_indentation_as_the_current_line() {
        let textInAXFocusedElement = """
now there's
    some indent
but it should work
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.text.value, """
now there's
    
    some indent
but it should work
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 16)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
    }

    func test_that_if_keeps_the_indentation_even_if_it_is_on_the_first_line() {
        let textInAXFocusedElement = """
   now indent on the first line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)

        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.text.value, """
   
   now indent on the first line
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 3)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
    }
    
}


// word wrap for now. not sure we gonna keep this way of doing.
// like do we insert like Vim does, on top of the real line, or on top of the visible line?
// currently in code for `o` and `O` it is according to visible line, but decision is not
// definitive.
extension ASUI_NM_O__Tests {
    
    func test_that_in_normal_setting_it_does_insert_two_linefeeds_above_and_reposition_the_caret_between_them() {
        let textInAXFocusedElement = """
that's 😀️ a multiline 😀️😀️ and a long 😀️😀️ one that will be wrapped somewhere but we 😀️ don't know where LOL and i have to 😀️ test that shit
"""

        
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.k(on: $0) }        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.text.value, """
that's 😀️ a multiline 😀️😀️ and a long 😀️😀️ one that will 

be wrapped somewhere but we 😀️ don't know where LOL and i have to 😀️ test that shit
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 63)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
    }
    
}
