@testable import AccessibilityStrategy
import XCTest


// `ce` uses `e` that uses `FileText.endOfWordForward` that are heavily tested.
// here we just test what's specific to ce.
class ASUT_NM_ce_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.ce(on: element, pgR: false)
    }
    
}


// copy deleted text
extension ASUT_NM_ce_Tests {
    
    func test_that_it_copies_the_deleted_text_in_the_pasteboard() {
        let text = "😂️😂️😂️😂️ gonna use ce on this sentence"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 3,
            selectedLength: 3,
            selectedText: "😂️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        _ = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "😂️😂️😂️")
    }
    
}


// both
extension ASUT_NM_ce_Tests {
    
    func test_that_in_normal_setting_it_selects_the_text_from_the_caret_to_the_character_found() {
        let text = "😂️😂️😂️😂️ gonna use ce on this sentence"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 3,
            selectedLength: 3,
            selectedText: "😂️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 3)
        XCTAssertEqual(returnedElement?.selectedLength, 9)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
   
}
