@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_cW__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.cW(on: element, pgR: false) 
    }
    
}


// both
extension ASUT_NM_cW__Tests {
    
    // see `cw` for blah blah
    func test_that_if_the_caret_is_on_a_non_blank_it_selects_the_text_from_the_caret_to_the_end_of_WORD() {
        let text = "😂️😂️😂️😂️hehehe gonna use cw on this sentence"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 48,
            caretLocation: 3,
            selectedLength: 3,
            selectedText: "😂️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 48,
                number: 1,
                start: 0,
                end: 48
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 3)
        XCTAssertEqual(returnedElement?.selectedLength, 15)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
    
    func test_that_if_the_caret_is_on_a_blank_it_selects_the_text_from_the_caret_to_the_beginning_of_the_next_WORD() {
        let text = "😂️😂️😂️😂️hehehe                   gonna use cw on this sentence"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 66,
            caretLocation: 21,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 66,
                number: 1,
                start: 0,
                end: 66
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 21)
        XCTAssertEqual(returnedElement?.selectedLength, 16)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
   
}
