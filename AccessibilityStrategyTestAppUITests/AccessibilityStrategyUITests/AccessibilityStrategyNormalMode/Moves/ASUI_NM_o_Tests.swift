import XCTest
@testable import AccessibilityStrategy


class ASUI_NM_o_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.o(on: $0, pgR: pgR) }
    }
    
}


// TextViews
extension ASUI_NM_o_Tests {
    
    func test_that_if_a_file_line_ends_with_a_linefeed_it_creates_a_new_line_below() {
        let textInAXFocusedElement = """
that's a multiline and o will create a new line
between the first file line and the second file line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.f(times: 1, to: "i", on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
that's a multiline and o will create a new line

between the first file line and the second file line
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 48)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
    func test_that_if_a_file_line_does_not_end_with_a_linefeed_it_still_creates_a_new_line_below() {
        let textInAXFocusedElement = """
now that's gonna be a multiline but we will put the caret at the last line
that doesn't end with a linefeed and it's still gonna work coz 🪄️🪄️🪄️ we're genius
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.F(to: "d", on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
now that's gonna be a multiline but we will put the caret at the last line
that doesn't end with a linefeed and it's still gonna work coz 🪄️🪄️🪄️ we're genius

"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 161)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
       
    func test_that_if_a_file_line_is_empty_it_still_creates_a_new_line_below() {
        let textInAXFocusedElement = """
yeah so it always seems easy but actually it's fucking hard

and i'm doing this not because i'm a genius but because i'm pretty dumb LMAO
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
yeah so it always seems easy but actually it's fucking hard


and i'm doing this not because i'm a genius but because i'm pretty dumb LMAO
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 61)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
    func test_that_the_caret_goes_to_the_same_spaces_indentation_as_the_previous_line_on_the_newly_created_line() {
        let textInAXFocusedElement = """
like
    there's some s🙃️ace
so the new line follows that
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.B(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
like
    there's some s🙃️ace
    
so the new line follows that
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 34)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
    func test_that_if_on_the_last_empty_line_it_does_create_a_new_line() {
        let textInAXFocusedElement = """
caret on empty last line

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
caret on empty last line


"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 26)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}


// PGR
// looks different from others here because we don't delete, we paste.
extension ASUI_NM_o_Tests {
    
    func test_that_if_on_the_last_empty_line_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
caret on empty last line

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
caret on empty last line



"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 27)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
        
    func test_that_in_other_settings_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
that's a multiline and o will create a new line
between the first file line and the second file line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.f(times: 1, to: "i", on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
that's a multiline and o will create a new line
iline and o will create a new line

between the first file line and the second file line
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 83)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}
