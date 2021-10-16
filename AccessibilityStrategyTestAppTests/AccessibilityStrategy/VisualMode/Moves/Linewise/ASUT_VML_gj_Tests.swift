import XCTest
import AccessibilityStrategy


class ASUT_VML_gj_Tests: ASVM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asVisualMode.gjForVisualStyleLinewise(on: element)
    }

}


// TextFields
extension ASUT_VML_gj_Tests {
    
    func test_that_for_TextFields_it_returns_nil_coz_we_want_the_KS_to_take_over() {
        let text = "VM jk in TextFields will do ⛱️nothing"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 37,
            caretLocation: 17,
            selectedLength: 17,
            selectedText: "ds will do ⛱️noth",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 37,
                number: 1,
                start: 0,
                end: 37
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 17
        AccessibilityStrategyVisualMode.head = 33
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertNil(returnedElement)
    }
    
}
