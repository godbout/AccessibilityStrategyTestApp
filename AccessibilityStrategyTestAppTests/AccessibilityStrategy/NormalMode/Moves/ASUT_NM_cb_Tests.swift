@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_cb_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.cb(on: element, pgR: false)
    }
    
}


// both
extension ASUT_NM_cb_Tests {
    
    func test_that_in_normal_setting_it_selects_the_text_from_the_caret_to_the_character_found() {
        let text = "so we gonna⏰️⏰️trytouse cb here and see 😂️😂️ if it works ⏰️"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 61,
            caretLocation: 20,
            selectedLength: 1,
            selectedText: "u",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 61,
                number: 1,
                start: 0,
                end: 61
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 15)
        XCTAssertEqual(returnedElement?.selectedLength, 5)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
   
}
