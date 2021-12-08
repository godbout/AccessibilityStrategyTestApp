@testable import AccessibilityStrategy
import XCTest


class ASUI_NM_cF__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, to character: Character, pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.cF(times: count, to: character, on: $0, pgR: pgR) }
    }
    
}


// count
extension ASUI_NM_cF__Tests {
    
    func test_that_it_implements_the_count_system() {
        let textInAXFocusedElement = "here we gonna delete up to 🕑️ characters rather than 🦴️!"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.F(to: "u", on: $0) }
        applyMove { asNormalMode.ge(on: $0) }
        let accessibilityElement = applyMoveBeingTested(times: 2, to: "e")
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "here we gonna de up to 🕑️ characters rather than 🦴️!")
        XCTAssertEqual(accessibilityElement?.caretLocation, 15)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}


// Both
extension ASUI_NM_cF__Tests {
    
    func test_that_in_normal_setting_it_selects_from_the_character_found_to_the_caret() {
        let textInAXFocusedElement = "gonna use cF on that sentence"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.F(to: "e", on: $0) }
        let accessibilityElement = applyMoveBeingTested(to: "F")
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "gonna use cence")
        XCTAssertEqual(accessibilityElement?.caretLocation, 11)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}


// TextViews
extension ASUI_NM_cF__Tests {
    
    func test_that_it_can_find_the_character_on_a_line_for_a_multiline() {
        let textInAXFocusedElement = """
cF on a multiline
should work
on a 📏️📏️ line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(to: "o")
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
cF on a multiline
should work
e
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 30)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}


// PGR
extension ASUI_NM_cF__Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
cF on a multiline
should work
on a 📏️📏️ line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(to: "o", pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
cF on a multiline
should worke
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 29)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}
