@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_cE__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        var state = VimEngineState(pgR: false)
        
        return asNormalMode.cE(on: element, &state)
    }
    
}


// both
extension ASUT_NM_cE__Tests {
    
    func test_that_in_normal_setting_it_selects_the_text_from_the_caret_to_the_character_found() {
        let text = "😂️😂️😂️😂️hehehehe gonna use ce on this sentence"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 50,
            caretLocation: 3,
            selectedLength: 3,
            selectedText: "😂️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 50,
                number: 1,
                start: 0,
                end: 50
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 3)
        XCTAssertEqual(returnedElement?.selectedLength, 17)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
   
}
