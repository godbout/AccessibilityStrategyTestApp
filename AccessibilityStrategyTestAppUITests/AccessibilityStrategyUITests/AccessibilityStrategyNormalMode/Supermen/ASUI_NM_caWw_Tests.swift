@testable import AccessibilityStrategy
import XCTest
import Common


class ASUI_NM_caWw_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(appFamily: AppFamily) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.caWw(on: $0, using: $0.fileText.aWord, &state) }
    }
    
}


// PGR and Electron
extension ASUI_NM_caWw_Tests {

    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = "that's some cute      text in here don't you think?"
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) } 
        applyMove { asNormalMode.F(to: "c", on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
           
        XCTAssertEqual(accessibilityElement.fileText.value, "that's some text in here don't you think?")
        XCTAssertEqual(accessibilityElement.caretLocation, 12)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_and_deletes_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = "that's some cute      text in here don't you think?"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.F(to: "c", on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
           
        XCTAssertEqual(accessibilityElement.fileText.value, "that's some text in here don't you think?")
        XCTAssertEqual(accessibilityElement.caretLocation, 12)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}
