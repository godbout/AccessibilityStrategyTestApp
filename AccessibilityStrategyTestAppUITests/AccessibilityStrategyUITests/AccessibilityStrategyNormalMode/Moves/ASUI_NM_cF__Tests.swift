@testable import AccessibilityStrategy
import XCTest


class ASUI_NM_cF__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(to character: Character, pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.cF(to: character, on: $0, pgR: pgR) }
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
