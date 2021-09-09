import XCTest
import KeyCombination
import AccessibilityStrategy


// the test where the character is not found and therefore nothing gets deleted is tested in UT.
// no need UI for that, and already a lot of UI Tests that take time :D
// here we have all the tests where the move does delete text, and therefore block cursor need to be
// recalculated.
class ASUI_NM_dF__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(with character: Character) -> AccessibilityTextElement? {
        return applyMove(with: character) { character, focusedElement in
            asNormalMode.dF(to: character, on: focusedElement)
        }
    }
    
}


// TextFields
extension ASUI_NM_dF__Tests {
    
    func test_that_in_normal_setting_it_selects_from_the_character_found_to_the_caret() {
        let textInAXFocusedElement = "gonna use dF on that sentence"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        
        
        let accessibilityElement = applyMoveBeingTested(with: "F")
        
        XCTAssertEqual(accessibilityElement?.value, "gonna use de")
        XCTAssertEqual(accessibilityElement?.caretLocation, 11)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
}


// TextAreas
extension ASUI_NM_dF__Tests {
    
    func test_that_it_can_find_the_character_on_a_line_for_a_multiline() {
        let textInAXFocusedElement = """
dF on a multiline
should work
on a lin😂️
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested(with: "o")
        
        XCTAssertEqual(accessibilityElement?.value, """
dF on a multiline
should work
😂️
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 30)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }
    
}
