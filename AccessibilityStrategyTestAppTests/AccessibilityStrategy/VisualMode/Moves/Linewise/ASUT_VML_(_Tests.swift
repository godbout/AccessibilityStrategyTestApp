import XCTest
import AccessibilityStrategy
import Common


class ASUT_VML_leftParenthesis_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let state = VimEngineState(visualStyle: .linewise)
        
        return asVisualMode.leftParenthesis(on: element, state)
    }
   
}


// Both
extension ASUT_VML_leftParenthesis_Tests {
    
    func test_to_make_sure_we_dont_skip_this_lol() {
        XCTAssertTrue(false)
    }
    
}


// TextViews
extension ASUT_VML_leftParenthesis_Tests {


}
