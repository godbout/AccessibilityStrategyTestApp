import XCTest
@testable import AccessibilityStrategy
import Common


// this calls cF which is already tested in UT. here all we need to test is that
// the block cursor is repositioned correctly when we found the character.
class ASUI_NM_dF__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, with character: Character, appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.dF(times: count, to: character, on: $0, &state) }
    }
    
}


// count
extension ASUI_NM_dF__Tests {
    
    func test_that_it_implements_the_count_system() {
        let textInAXFocusedElement = "here we gonna delete up to 🕑️ characters rather than 🦴️!"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.F(to: "u", on: $0) }
        applyMove { asNormalMode.ge(on: $0) }
        let accessibilityElement = applyMoveBeingTested(times: 2, with: "e")
        
        XCTAssertEqual(accessibilityElement.fileText.value, "here we gonna de up to 🕑️ characters rather than 🦴️!")
        XCTAssertEqual(accessibilityElement.caretLocation, 15)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "e")
    }
    
}


extension ASUI_NM_dF__Tests {
    
    func test_that_the_block_cursor_is_repositioned_correctly_after_the_deletion() {
        let textInAXFocusedElement = """
dF on a multiline
should work
on a lin😂️
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested(with: "o")
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
dF on a multiline
should work
😂️
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 30)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
   
}


// PGR and Electron
extension ASUI_NM_dF__Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
dF on a multiline
should work
on a lin😂️
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested(with: "o", appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
dF on a multiline
should work
n😂️
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 30)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
dF on a multiline
should work
on a lin😂️
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested(with: "o", appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
dF on a multiline
should work
n😂️
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 30)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
}
