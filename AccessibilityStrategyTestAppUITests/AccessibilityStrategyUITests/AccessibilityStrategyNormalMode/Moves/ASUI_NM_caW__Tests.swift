@testable import AccessibilityStrategy
import XCTest


// see ciw for blah blah
class ASUI_NM_caW__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.caW(on: $0, pgR: pgR) }
    }
    
}


// Both
extension ASUI_NM_caW__Tests {
    
    func test_that_when_it_finds_a_WORD_it_selects_the_range_and_will_delete_the_selection() {
        let textInAXFocusedElement = "that's some cute-boobies      text in here don't you think?"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.F(to: "c", on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "that's some text in here don't you think?")
        XCTAssertEqual(accessibilityElement?.caretLocation, 12)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }

    func test_that_when_it_cannot_find_a_WORD_the_caret_goes_to_the_end_limit_of_the_text() {
        let textInAXFocusedElement = """
some text
and also a lot of spaces at the end of this line        
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.ge(on: $0) }
        applyMove { asNormalMode.l(times: 3, on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
some text
and also a lot of spaces at the end of this line        
"""        
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 65)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
        XCTAssertEqual(accessibilityElement?.selectedText, " ")
   }
    
}


// PGR
extension ASUI_NM_caW__Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "that's some cute-boobies      text in here don't you think?"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.F(to: "c", on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "that's sometext in here don't you think?")
        XCTAssertEqual(accessibilityElement?.caretLocation, 11)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}
