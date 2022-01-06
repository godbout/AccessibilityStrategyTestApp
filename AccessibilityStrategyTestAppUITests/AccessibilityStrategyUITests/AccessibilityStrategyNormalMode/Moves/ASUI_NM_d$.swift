import XCTest
@testable import AccessibilityStrategy


// internally this is calling C that is already tested, so we're not gonna repeat
// every case scenario here. we're just gonna test the cases where we know we need to pay attention.
// the UI Tests are for the block cursor repositioning after the move.
class ASUI_NM_dDollarSign_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(_ vimEngineState: inout VimEngineState) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.dDollarSign(on: $0, &vimEngineState) }
    }
    
}


// yes, only one test. i know you will want to add 32 other ones when you see that in 2 weeks
// but here's the reason:
// 1. as stated above, here we only need to test the caret repositioning (D calls C, C is already tested)
// 2. the caret position will always go to the line endLimit, whether the line is empty or not. this is
// tested in the endLimit tests. so here we mostly have nothing to do. :D
extension ASUI_NM_dDollarSign_Tests {

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
        var state = VimEngineState()
        let accessibilityElement = applyMoveBeingTested(&state)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
D will delete till the end of line but not the linefeed (tested in C) and will go to the end limit even if the line is empty
which😂️
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 130)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }

}


// PGR
extension ASUI_NM_dDollarSign_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
D will delete till the end of line but not the linefeed (tested in C) and will go to the end limit even if the line is empty
which😂️means it will not up one line and this is tested in the endLimit!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        var state = VimEngineState(pgR: true)
        let accessibilityElement = applyMoveBeingTested(&state)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
D will delete till the end of line but not the linefeed (tested in C) and will go to the end limit even if the line is empty
which
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 129)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
}
