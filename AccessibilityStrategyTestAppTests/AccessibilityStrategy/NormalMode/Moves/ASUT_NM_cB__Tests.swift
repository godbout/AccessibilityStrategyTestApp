@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_cB__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?, _ bipped: inout Bool) -> AccessibilityTextElement? {
        return asNormalMode.cB(on: element, pgR: false, &bipped)
    }
    
}


// copy deleted text
extension ASUT_NM_cB__Tests {
    
    func test_that_it_copies_the_deleted_text_in_the_pasteboard() {
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
        
        copyToClipboard(text: "some fake shit")
        var bipped = false
        _ = applyMoveBeingTested(on: element, &bipped)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "gonna⏰️⏰️tryto")
    }
    
}


// bipped
extension ASUT_NM_cB__Tests {
    
    func test_that_it_does_not_Bip_when_it_can_find() {
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
        
        var bipped = false
        let _ = applyMoveBeingTested(on: element, &bipped)
        
        XCTAssertFalse(bipped)
    }
        
    func test_that_it_Bips_when_it_cannot_find() {
        let text = ""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 0,
            caretLocation: 0,
            selectedLength: 0,
            selectedText: "",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 0,
                number: 1,
                start: 0,
                end: 0
            )!
        )
        
        var bipped = false
        _ = applyMoveBeingTested(on: element, &bipped)
        
        XCTAssertTrue(bipped)
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
        
        var bipped = false
        let returnedElement = applyMoveBeingTested(on: element, &bipped)
        
        XCTAssertEqual(returnedElement?.caretLocation, 6)
        XCTAssertEqual(returnedElement?.selectedLength, 14)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
   
}
