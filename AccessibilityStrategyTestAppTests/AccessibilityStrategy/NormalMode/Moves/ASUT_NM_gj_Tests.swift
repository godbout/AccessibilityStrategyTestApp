@testable import AccessibilityStrategy
import XCTest


// only testing for when KS takes over here, rest is in UI Tests
class ASUT_NM_gj_Tests: ASNM_BaseTests {
    
    private func applyMove(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.gj(on: element) 
    }
    
}


extension ASUT_NM_gj_Tests {
    
    func test_that_for_TextFields_it_returns_nil_coz_we_want_the_KS_to_take_over() {
        let text = "j on a TextField shouldn't use the AS! think Alfred"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 51,
            caretLocation: 23,
            selectedLength: 1,
            selectedText: "n",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 51,
                number: 1,
                start: 0,
                end: 51
            )!
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertNil(returnedElement)
    }
    
}
