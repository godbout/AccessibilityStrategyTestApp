import XCTest
@testable import AccessibilityStrategy
import Common


// see dF for blah blah
class ASUI_NM_dT__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, with character: Character, appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.dT(times: count, to: character, on: $0, &state) }
    }
    
}


// count
extension ASUI_NM_dT__Tests {
    
    func test_that_it_implements_the_count_system() {
        let textInAXFocusedElement = "here we gonna delete up to 🕑️ characters rather than 🦴️!"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.F(to: "u", on: $0) }
        applyMove { asNormalMode.ge(on: $0) }
        let accessibilityElement = applyMoveBeingTested(times: 2, with: "e")
        
        XCTAssertEqual(accessibilityElement.fileText.value, "here we gonna dee up to 🕑️ characters rather than 🦴️!")
        XCTAssertEqual(accessibilityElement.caretLocation, 16)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "e")
    }
    
}


extension ASUI_NM_dT__Tests {
    
    func test_that_the_block_cursor_is_repositioned_correctly_after_the_deletion() {
        let textInAXFocusedElement = """
dT on a multiline
should wor⛱️
on a line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.dollarSign(on: $0) }
        let accessibilityElement = applyMoveBeingTested(with: "w")
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
dT on a multiline
should w⛱️
on a line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 26)
        XCTAssertEqual(accessibilityElement.selectedLength, 2)
    }
    
}


// PGR and Electron
extension ASUI_NM_dT__Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
dT on a multiline
should wor⛱️
on a line
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.dollarSign(on: $0) }
        let accessibilityElement = applyMoveBeingTested(with: "w", appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
dT on a multiline
should w⛱️
on a line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 26)
        XCTAssertEqual(accessibilityElement.selectedLength, 2)
    }
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_and_deletes_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
dT on a multiline
should wor⛱️
on a line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.dollarSign(on: $0) }
        let accessibilityElement = applyMoveBeingTested(with: "w", appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
dT on a multiline
should w⛱️
on a line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 26)
        XCTAssertEqual(accessibilityElement.selectedLength, 2)
    }
    
}

