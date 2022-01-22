import XCTest
import AccessibilityStrategy
import Common


// most of the tests are in UT as j uses FL, not SL. this one is just to mega confirm.
class ASUI_VMC_j_Tests: ASUI_VM_BaseTests {
    
    var state = VimEngineState(visualStyle: .characterwise)
    
    
    private func applyMoveBeingTested() -> AccessibilityTextElement {
        return applyMove { asVisualMode.j(on: $0, state) }
    }

}


// TextViews
extension ASUI_VMC_j_Tests {
        
    func test_that_if_the_ATE_ColumnNumbers_are_nil_j_goes_to_the_end_limit_of_the_next_line() {        
        let textInAXFocusedElement = """
globalColumnNumber is nil
coz used $ to go end of line📏️
and also to the end of the next next line!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.dollarSign(on: $0, state) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.caretLocation, 19)
        XCTAssertEqual(accessibilityElement.selectedLength, 39)
        
        let secondPass = applyMoveBeingTested()
        
        XCTAssertEqual(secondPass.caretLocation, 19)
        XCTAssertEqual(secondPass.selectedLength, 81)
        
        // here we're actually testing that k works in this configuration (mix of j and k). probably would have been better
        // to have its own test cases but would double the number of tests (it's like the tests we have for
        // k but now with GCN being nil) and UI Tests are expensive and it's Sunday and that's enough.
        let applyK = applyMove { asVisualMode.k(on: $0, state) }
        
        XCTAssertEqual(applyK.caretLocation, 19)
        XCTAssertEqual(applyK.selectedLength, 39)

        let applyJAgain = applyMoveBeingTested()
        
        XCTAssertEqual(applyJAgain.caretLocation, 19)
        XCTAssertEqual(applyJAgain.selectedLength, 81)
    }

}


