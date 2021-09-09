import XCTest
import KeyCombination
import AccessibilityStrategy


// see dF for blah blah
class ASUI_NM_dT__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(with character: Character) -> AccessibilityTextElement? {
        return applyMove(with: character) { character, focusedElement in
            asNormalMode.dT(to: character, on: focusedElement)
        }
    }
    
}


// TextFields
extension ASUI_NM_dT__Tests {
    
    func test_that_in_normal_setting_it_selects_from_the_character_found_to_the_caret() {
        let textInAXFocusedElement = "gonna use dT on that sentence"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
      
        let accessibilityElement = applyMoveBeingTested(with: "T")
        
        XCTAssertEqual(accessibilityElement?.value, "gonna use dTe")
        XCTAssertEqual(accessibilityElement?.caretLocation, 12)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
}


// TextAreas
extension ASUI_NM_dT__Tests {
    
    func test_that_it_can_find_the_character_on_a_line_for_a_multiline() {
        let textInAXFocusedElement = """
dT on a multiline
should work
on a line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.dollarSign(on: $0) }
        let accessibilityElement = applyMoveBeingTested(with: "w")
        
        XCTAssertEqual(accessibilityElement?.value, """
dT on a multiline
should wk
on a line
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 26)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
}


// emojis
extension ASUI_NM_dT__Tests {

    func test_that_it_handles_emojis() {
        let textInAXFocusedElement = """
need to deal with
those💨️💨️💨️ faces 🥺️☹️😂️ h😀️ha
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.B(on: $0) }
        let accessibilityElement = applyMoveBeingTested(with: "h")
        
        XCTAssertEqual(accessibilityElement?.value, """
need to deal with
thh😀️ha
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 20)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }

}
