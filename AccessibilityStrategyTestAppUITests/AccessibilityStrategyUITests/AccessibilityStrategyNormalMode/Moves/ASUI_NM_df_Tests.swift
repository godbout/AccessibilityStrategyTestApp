import XCTest
@testable import AccessibilityStrategy


// see dF for blah blah
class ASUI_NM_df_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, with character: Character, pgR: Bool = false) -> AccessibilityTextElement? {
        var state = VimEngineState(pgR: pgR)
        
        return applyMove { asNormalMode.df(times: count, to: character, on: $0, &state) }
    }
    
}


// count
extension ASUI_NM_df_Tests {
    
    func test_that_it_implements_the_count_system() {
        let textInAXFocusedElement = "here we gonna delete up to 🕑️ characters rather than 🦴️!"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.F(to: "u", on: $0) }
        applyMove { asNormalMode.ge(on: $0) }
        let accessibilityElement = applyMoveBeingTested(times: 2, with: "e")
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "here we gonna deletr than 🦴️!")
        XCTAssertEqual(accessibilityElement?.caretLocation, 19)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
        XCTAssertEqual(accessibilityElement?.selectedText, "r")
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
