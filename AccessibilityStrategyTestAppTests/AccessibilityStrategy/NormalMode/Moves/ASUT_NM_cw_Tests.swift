@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_cw_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.cw(on: element, pgR: false) 
    }
    
}


// copy deleted text
extension ASUT_NM_cw_Tests {
    
    func test_that_it_copies_the_deleted_text_in_the_pasteboard() {
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
        
        copyToClipboard(text: "some fake shit")
        _ = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "😂️😂️😂️")
    }
    
}


// both
extension ASUT_NM_cw_Tests {
    
    // careful with "end of word". if the caret is already on the end of the current word, it goes to the end of the next word.
    // this is how `e` behaves.
    func test_that_if_the_caret_is_on_a_non_blank_or_a_non_punctuation_it_selects_the_text_from_the_caret_to_the_end_of_word() {
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
        XCTAssertEqual(returnedElement?.selectedLength, 9)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
    
    func test_that_if_the_caret_is_on_a_blank_it_selects_the_text_from_the_caret_to_the_beginning_of_the_next_word() {
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
    
    func test_that_if_the_caret_is_on_a_punctuation_it_selects_the_text_from_the_caret_to_the_beginning_of_the_next_word() {
        let text = "😂️😂️😂️😂️hehehe     full-time         gonna use cw on this sentence"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 70,
            caretLocation: 27,
            selectedLength: 1,
            selectedText: "-",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 70,
                number: 1,
                start: 0,
                end: 70
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 27)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
   
}
