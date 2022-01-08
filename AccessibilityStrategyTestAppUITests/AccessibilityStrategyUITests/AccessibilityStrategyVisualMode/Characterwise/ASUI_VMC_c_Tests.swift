import XCTest
@testable import AccessibilityStrategy
import VimEngineState


class ASUI_VMC_c_Tests: ASUI_VM_BaseTests {
    
    var state = VimEngineState(visualStyle: .characterwise)
    
    
    private func applyMoveBeingTested(pgR: Bool) -> AccessibilityTextElement {
        state.pgR = pgR
        
        return applyMove { asVisualMode.c(on: $0, &state) }
    }

}


// PGR
extension ASUI_VMC_c_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "ok so VM c (hahaha) on a single line"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.f(times: 2, to: "h", on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.f(to: "i", on: $0, state) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement.fileText.value, "ok so VM c (hngle line")
        XCTAssertEqual(accessibilityElement.caretLocation, 13)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}
