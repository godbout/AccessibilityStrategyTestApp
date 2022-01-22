import XCTest
import AccessibilityStrategy
import Common


class ASUI_VMC_k_Tests: ASUI_VM_BaseTests {

    var state = VimEngineState(visualStyle: .characterwise)
    
    
    private func applyMoveBeingTested() -> AccessibilityTextElement {
        return applyMove { asVisualMode.k(on: $0, state) }
    }

}


// TextViews
extension ASUI_VMC_k_Tests {
       
    func test_that_if_the_ATE_ColumnNumbers_are_nil_k_goes_to_the_end_limit_of_the_previous_line() {
        let text = """
and also to the end of the next next line!
coz used $ to go end of line📏️
globalColumnNumber is nil
"""

        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(text)
        
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.dollarSign(on: $0, state) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.caretLocation, 74)
        XCTAssertEqual(accessibilityElement.selectedLength, 21)
        
        let secondPass = applyMoveBeingTested()
                
        XCTAssertEqual(secondPass.caretLocation, 42)
        XCTAssertEqual(secondPass.selectedLength, 53)
        
        // see VMC j Tests for blah blah
        let applyJ = applyMove { asVisualMode.j(on: $0, state) }
        
        XCTAssertEqual(applyJ.caretLocation, 74)
        XCTAssertEqual(applyJ.selectedLength, 21)

        let applyKAgain = applyMoveBeingTested()
        
        XCTAssertEqual(applyKAgain.caretLocation, 42)
        XCTAssertEqual(applyKAgain.selectedLength, 53)
    }
       
}
