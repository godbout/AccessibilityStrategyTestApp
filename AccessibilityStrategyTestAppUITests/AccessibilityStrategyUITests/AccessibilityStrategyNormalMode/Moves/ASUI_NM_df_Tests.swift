import XCTest
@testable import AccessibilityStrategy


// see dF for blah blah
class ASUI_NM_df_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(with character: Character, pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove(with: character) { character, focusedElement in
            asNormalMode.df(to: character, on: focusedElement, pgR: pgR)
        }
    }
    
}


extension ASUI_NM_df_Tests {
    
    func test_that_the_block_cursor_is_repositioned_correctly_after_the_deletion() {
        let textInAXFocusedElement = "gonna us⛱️ df on this sentence"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gZero(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
       
        let accessibilityElement = applyMoveBeingTested(with: "s")
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "g⛱️ df on this sentence")
        XCTAssertEqual(accessibilityElement?.caretLocation, 1)
        XCTAssertEqual(accessibilityElement?.selectedLength, 2)
    }
    
}


// PGR
extension ASUI_NM_df_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "gonna us⛱️ df on this sentence"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gZero(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
       
        let accessibilityElement = applyMoveBeingTested(with: "s", pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "⛱️ df on this sentence")
        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 2)
    }
}
