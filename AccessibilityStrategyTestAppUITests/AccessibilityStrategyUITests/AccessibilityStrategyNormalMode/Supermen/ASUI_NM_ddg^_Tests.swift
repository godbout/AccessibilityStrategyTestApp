import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_NM_ddgCaret_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement {
        var vimEngineState = VimEngineState()
        
        return applyMove { asNormalMode.ddgCaret(using: $0.currentFileLine, on: $0, &vimEngineState) }
    }
    
}


// same as ddg$ and ddg0. because ddg^ is only calling its `c` counterpart and selecting back the character,
// the cases have already been tested in the `c` counterpart. here we just need one test to prove that we indeed
// select back the character.
extension ASUI_NM_ddgCaret_Tests {

    func test_that_we_select_back_the_caretLocation_after_calling_the_c_counterpart_move() {
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

        XCTAssertEqual(accessibilityElement.fileText.value, """
ultimately this will show that this move is calling its `c` counterpart and that
   t a😂️d block cursor correctly
and that has to include emojis
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 84)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }

}


// PGR and Electron
// already tested in c^ and cg^
extension ASUI_NM_ddgCaret_Tests {}
