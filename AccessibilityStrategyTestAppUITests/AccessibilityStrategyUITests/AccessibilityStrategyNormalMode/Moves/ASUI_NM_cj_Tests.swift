@testable import AccessibilityStrategy
import XCTest
import Common


class ASUI_NM_cj_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(appFamily: AppFamily) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.cj(on: $0, &state) }
    }
    
}


// PGR and Electron
extension ASUI_NM_cj_Tests {

    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
but the indent should
   i delete a line
be kept
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gk(on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
but the indent should
   
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 25)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
but the indent should
   i delete a line
be kept
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gk(on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
but the indent should
   
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 25)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}
