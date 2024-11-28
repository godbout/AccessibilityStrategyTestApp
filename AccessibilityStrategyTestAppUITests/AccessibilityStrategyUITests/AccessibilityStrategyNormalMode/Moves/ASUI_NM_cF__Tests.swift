@testable import AccessibilityStrategy
import XCTest
import Common


class ASUI_NM_cF__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, to character: Character, appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.cF(times: count, to: character, on: $0, &state) }
    }
    
}


// count
extension ASUI_NM_cF__Tests {
    
    func test_that_it_implements_the_count_system() {
        let textInAXFocusedElement = "here we gonna delete up to 🕑️ characters rather than 🦴️!"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.slash(to: "e up", on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(times: 2, to: "e")
        
        XCTAssertEqual(accessibilityElement.fileText.value, "here we gonna de up to 🕑️ characters rather than 🦴️!")
        XCTAssertEqual(accessibilityElement.caretLocation, 15)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}


// Both
extension ASUI_NM_cF__Tests {
    
    func test_that_in_normal_setting_it_selects_from_the_character_found_to_the_caret() {
        let textInAXFocusedElement = "gonna use cF on that sentence"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.h(times: 3, on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(to: "F")
        
        XCTAssertEqual(accessibilityElement.fileText.value, "gonna use cence")
        XCTAssertEqual(accessibilityElement.caretLocation, 11)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
    func test_that_if_the_character_is_not_found_then_it_does_nothing() {
        let textInAXFocusedElement = """
gonna look
for a character
that is not there
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.l(times: 3, on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(to: "z")
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
gonna look
for a character
that is not there
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 14)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
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
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
cF on a multiline
should work
e
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 30)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}


// PGR and Electron
extension ASUI_NM_cF__Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
cF on a multiline
should work
on a 📏️📏️ line
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(to: "o", appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
cF on a multiline
should work
e
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 30)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
cF on a multiline
should work
on a 📏️📏️ line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(to: "o", appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
cF on a multiline
should work
e
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 30)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}
