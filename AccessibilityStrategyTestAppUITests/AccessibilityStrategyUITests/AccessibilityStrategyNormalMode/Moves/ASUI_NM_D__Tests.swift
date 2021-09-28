import XCTest
@testable import AccessibilityStrategy


// internally this is calling C that is already tested, so we're not gonna repeat
// every case scenario here. we're just gonna test the cases where we know we need to pay attention.
// the UI Tests are for the block cursor repositioning after the move.
class UIASNM_D_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asNormalMode.D(on: $0) }
    }
    
}


// yes, only one test. i know you will want to add 32 ones when you see that in 2 weeks
// but here's the reason:
// 1. as stated above, here we only need to test the caret repositioning (D calls C, C is already tested)
// 2. the caret position will always go to the line endLimit, whether the line is empty or not. this is
// tested in the endLimit tests. so where we mostly have nothing to do! :D
extension UIASNM_D_Tests {

    func test_that_in_any_case_the_caret_location_will_end_up_at_the_line_end_limit() {
        let textInAXFocusedElement = """
D will delete till the end of line but not
the linefeed (tested in C) and will go to the end
limit even if the line is empty which😂️means it will not
up one line and this is tested in the endLimit!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.text.value, """
D will delete till the end of line but not
the linefeed (tested in C) and will go to the end
limit even if the line is empty which😂️
up one line and this is tested in the endLimit!
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 130)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }

}
