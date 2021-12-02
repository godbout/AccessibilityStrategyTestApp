@testable import AccessibilityStrategy
import XCTest


class ASUI_NM_cT__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(to character: Character, pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.cT(to: character, on: $0, pgR: pgR) }
    }
    
}


// Both
extension ASUI_NM_cT__Tests {
    
    func test_that_in_normal_setting_it_selects_from_the_character_found_to_the_caret() {
        let textInAXFocusedElement = "gonna use cT on that sentence"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.F(to: "e", on: $0) }
        let accessibilityElement = applyMoveBeingTested(to: "T")
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "gonna use cTence")
        XCTAssertEqual(accessibilityElement?.caretLocation, 12)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}


// TextViews
extension ASUI_NM_cT__Tests {
    
    func test_that_it_can_find_the_character_on_a_line_for_a_multiline() {
        let textInAXFocusedElement = """
cT on a multiline
should w🔨️🔨️or🔨️k
on a line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.dollarSign(on: $0) }
        let accessibilityElement = applyMoveBeingTested(to: "w")
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
cT on a multiline
should wk
on a line
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 26)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}


// PGR
extension ASUI_NM_cT__Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
cT on a multiline
should work
on a 📏️📏️ line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(to: "o", pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
cT on a multiline
should work
e
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 30)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}
