import XCTest
@testable import AccessibilityStrategy
import Common


// see dF for blah blah
class ASUI_NM_df_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, with character: Character, appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.df(times: count, to: character, on: $0, &vimEngineState) }
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
        
        XCTAssertEqual(accessibilityElement.fileText.value, "here we gonna deletr than 🦴️!")
        XCTAssertEqual(accessibilityElement.caretLocation, 19)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "r")
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
        
        XCTAssertEqual(accessibilityElement.fileText.value, "g⛱️ df on this sentence")
        XCTAssertEqual(accessibilityElement.caretLocation, 1)
        XCTAssertEqual(accessibilityElement.selectedLength, 2)
    }
    
}


// PGR and Electron
extension ASUI_NM_df_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = "gonna us⛱️ df on this sentence"
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
       
        let accessibilityElement = applyMoveBeingTested(with: "s", appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, "g⛱️ df on this sentence")
        XCTAssertEqual(accessibilityElement.caretLocation, 1)
        XCTAssertEqual(accessibilityElement.selectedLength, 2)
    }
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = "gonna us⛱️ df on this sentence"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
       
        let accessibilityElement = applyMoveBeingTested(with: "s", appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, "g⛱️ df on this sentence")
        XCTAssertEqual(accessibilityElement.caretLocation, 1)
        XCTAssertEqual(accessibilityElement.selectedLength, 2)
    }

}
