import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_NM_ddg0_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement {
        var state = VimEngineState()
        
        return applyMove { asNormalMode.ddgZero(using: $0.currentFileLine, on: $0, &state) }
    }
    
}


extension ASUI_NM_ddg0_Tests {

    func test_that_in_any_case_the_caret_location_will_end_up_at_the_start_of_the_currentFileLine() {
        let textInAXFocusedElement = """
ultimately this will show that this move is calling its `c` counterpart and that
it will reposition the caret a😂️d block cursor correctly
and that has to include emojis
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        x
        XCTAssertEqual(accessibilityElement.fileText.value, """
ultimately this will show that this move is calling its `c` counterpart and that
😂️d block cursor correctly
and that has to include emojis
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 81)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }

}


// PGR and Electron
// tested in c0, not called in d0
extension ASUI_NM_ddg0_Tests {}
