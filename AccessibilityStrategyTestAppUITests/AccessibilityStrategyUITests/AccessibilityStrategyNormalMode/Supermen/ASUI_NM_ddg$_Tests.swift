import XCTest
@testable import AccessibilityStrategy
import Common


// internally this is calling C that is already tested, so we're not gonna repeat
// every case scenario here. we're just gonna test the cases where we know we need to pay attention.
// the UI Tests are for the block cursor repositioning after the move.
class ASUI_NM_ddgDollarSign_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement {
        var vimEngineState = VimEngineState()
        
        return applyMove { asNormalMode.ddgDollarSign(using: $0.currentFileLine, on: $0, &vimEngineState) }
    }
    
}


// yes, only one test. i know you will want to add 32 other ones when you see that in 2 weeks
// but here's the reason:
// 1. as stated above, here we only need to test the caret repositioning (D calls C, C is already tested)
// 2. the caret position will always go to the line endLimit, whether the line is empty or not. this is
// tested in the endLimit tests. so here we mostly have nothing to do. :D
// UPDATE: 2. is not valid anymore as ddgDollarSign may be passed the ScreenLine, in which case the caret position will not
// end up at the line endLimit, but will not move instead. that part is tested in ASUI dg$ test.
extension ASUI_NM_ddgDollarSign_Tests {

    func test_that_in_any_case_the_caret_location_will_end_up_at_the_line_end_limit() {
        let textInAXFocusedElement = """
D will delete till the end of line but not the linefeed (tested in C) and will go to the end limit even if the line is empty
which😂️means it will not up one line and this is tested in the endLimit!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
D will delete till the end of line but not the linefeed (tested in C) and will go to the end limit even if the line is empty
which😂️
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 130)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }

}


// PGR and Electron
// already tested in c$
extension ASUI_NM_ddgDollarSign_Tests {}
