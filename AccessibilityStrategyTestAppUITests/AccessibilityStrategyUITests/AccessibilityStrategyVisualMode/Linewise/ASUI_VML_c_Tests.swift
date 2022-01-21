import XCTest
@testable import AccessibilityStrategy
import VimEngineState


class ASUI_VML_c_Tests: ASUI_VM_BaseTests {
    
    var state = VimEngineState(visualStyle: .linewise)
    
       
    private func applyMoveBeingTested(appFamily: VimEngineAppFamily = .auto) -> AccessibilityTextElement {
        state.appFamily = appFamily
        
        return applyMove { asVisualMode.c(on: $0, &state) }
    }

}


// PGR
extension ASUI_VML_c_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
VM c in Linewise
will delete the selected lines
but the below line will not go up
at least if we're not at the end of the text
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.j(on: $0) }
        applyMove { asVisualMode.VFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, state) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
VM c in Linewise
at least if we're not at the end of the text
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 16)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}
