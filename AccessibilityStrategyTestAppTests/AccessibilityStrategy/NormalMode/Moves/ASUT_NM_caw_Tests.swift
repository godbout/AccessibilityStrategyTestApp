@testable import AccessibilityStrategy
import XCTest


// see ciw for blah blah
class ASUT_NM_caw_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?, _ bipped: inout Bool) -> AccessibilityTextElement? {
        return asNormalMode.caw(on: element, pgR: false, &bipped)
    }
    
}


// copy deleted text
extension ASUT_NM_caw_Tests {
    
    func test_that_it_copies_the_deleted_text_in_the_pasteboard() {
        let text = "that's some cute      text in here don't you think?"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 51,
            caretLocation: 14,
            selectedLength: 1,
            selectedText: "t",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 51,
                number: 1,
                start: 0,
                end: 51
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var bipped = false
        _ = applyMoveBeingTested(on: element, &bipped)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "cute      ")
    }
    
}


// Both
extension ASUT_NM_caw_Tests {
    
    func test_that_when_it_finds_a_word_it_selects_the_range_and_will_delete_the_selection() {
        let text = "that's some cute      text in here don't you think?"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 51,
            caretLocation: 14,
            selectedLength: 1,
            selectedText: "t",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 51,
                number: 1,
                start: 0,
                end: 51
            )!
        )
        
        var bipped = false
        let returnedElement = applyMoveBeingTested(on: element, &bipped)
        
        XCTAssertEqual(returnedElement?.caretLocation, 12)
        XCTAssertEqual(returnedElement?.selectedLength, 10)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }

    func test_that_when_it_cannot_find_a_word_the_caret_goes_to_the_end_limit_of_the_text() {
        let text = """
some text
and also a lot of spaces at the end of this line        
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 66,
            caretLocation: 60,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 66,
                number: 2,
                start: 10,
                end: 66
            )!
        )
        
        var bipped = false
        let returnedElement = applyMoveBeingTested(on: element, &bipped)
        
        XCTAssertEqual(returnedElement?.caretLocation, 65)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
   }
    
}


// bipped
extension ASUT_NM_caw_Tests {
    
    func test_that_it_does_not_Bip_when_it_can_find_aWord() {
        let text = "that's some cute      text in here don't you think?"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 51,
            caretLocation: 13,
            selectedLength: 1,
            selectedText: "u",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 51,
                number: 1,
                start: 0,
                end: 51
            )!
        )
        
        var bipped = false
        let _ = applyMoveBeingTested(on: element, &bipped)
        
        XCTAssertFalse(bipped)
    }
        
    func test_that_it_Bips_when_it_cannot_find_aWord() {
        let text = """
some text
and also a lot of spaces at the end of this line        
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 66,
            caretLocation: 60,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 66,
                number: 2,
                start: 10,
                end: 66
            )!
        )
        
        var bipped = false
        let _ = applyMoveBeingTested(on: element, &bipped)
        
        XCTAssertTrue(bipped)
    }
       
}
