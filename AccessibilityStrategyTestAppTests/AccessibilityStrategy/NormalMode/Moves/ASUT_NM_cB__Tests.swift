@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_cB__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?, pgR: Bool = false) -> AccessibilityTextElement? {
        return asNormalMode.cB(on: element, pgR: pgR)
    }
    
}


// both
extension ASUT_NM_cB__Tests {
    
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
        
        XCTAssertEqual(returnedElement?.caretLocation, 6)
        XCTAssertEqual(returnedElement?.selectedLength, 14)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
   
}
