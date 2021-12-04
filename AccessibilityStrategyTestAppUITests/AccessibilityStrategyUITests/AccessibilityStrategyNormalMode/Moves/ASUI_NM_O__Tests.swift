import XCTest
@testable import AccessibilityStrategy


// see ASUT O for blah blah
class ASUI_NM_O__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.O(on: $0, pgR: pgR) }
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
               
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.j(on: $0) }
        applyMove { asNormalMode.f(times: 1, to: "d", on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.fileText.value, """
tha😄️t's a mu😄️ltiline

an😄️😄️d O will
create a n😄️ew line
abo😄️ve!
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 25)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
    func test_that_if_on_an_empty_line_it_will_still_create_a_line_above() {
        let textInAXFocusedElement = """
there is now

an empty line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
               
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.fileText.value, """
there is now


an empty line
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 13)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
    func test_that_if_on_the_last_empty_line_it_creates_a_line_above_and_the_caret_goes_on_that_line() {
        let textInAXFocusedElement = """
now the caret
will be on
the last empty line

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
               
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.fileText.value, """
now the caret
will be on
the last empty line


"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 45)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
    func test_that_if_on_the_last_non_empty_line_it_creates_a_line_above_and_the_caret_goes_on_that_line() {
        let textInAXFocusedElement = """
now the caret
will be on
the last empty line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
               
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.fileText.value, """
now the caret
will be on

the last empty line
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 25)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
    func test_that_it_creates_a_line_above_and_goes_to_the_same_indentation_as_the_current_line() {
        let textInAXFocusedElement = """
now there's
    some indent
but it should work
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
               
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.fileText.value, """
now there's
    
    some indent
but it should work
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 16)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
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


// PGR
extension ASUI_NM_O__Tests {
    
    func test_that_if_at_the_first_line_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
caret on the first
line and it should
still create a line above
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
               
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.dollarSign(on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)

        XCTAssertEqual(accessibilityElement?.fileText.value, """


caret on the first
line and it should
still create a line above
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
    func test_that_in_other_settings_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
tha😄️t's a mu😄️ltiline
an😄️😄️d O will
create a n😄️ew line
abo😄️ve!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
               
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.j(on: $0) }
        applyMove { asNormalMode.f(times: 1, to: "d", on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)

        XCTAssertEqual(accessibilityElement?.fileText.value, """
tha😄️t's a mu😄️ltiline
tha😄️t's a mu😄️ltiline

an😄️😄️d O will
create a n😄️ew line
abo😄️ve!
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 50)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}
