@testable import AccessibilityStrategy
import XCTest


// see b for blah blah
class ASUT_NM_w_Tests: ASNM_BaseTests {
    
    private func applyMove(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.w(on: element)
    }
    
}


// both
extension ASUT_NM_w_Tests {
    
    func test_that_when_there_is_no_word_forward_it_goes_to_the_end_limit_of_the_text() {
        let text = "in that sentence the move can't find a word forward...        "
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 62,
            caretLocation: 55,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 62,
                number: 1,
                start: 0,
                end: 62
            )
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 61)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
       
    func test_that_when_there_is_a_word_forward_it_goes_to_the_beginning_of_it() {
        let text = """
now we're talking
you little mf
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 31,
            caretLocation: 24,
            selectedLength: 1,
            selectedText: "t",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 2,
                start: 18,
                end: 31
            )
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 29)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
