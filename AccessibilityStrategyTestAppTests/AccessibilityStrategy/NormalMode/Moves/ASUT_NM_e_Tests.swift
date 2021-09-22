@testable import AccessibilityStrategy
import XCTest


// see b for blah blah
class ASUT_NM_e_Tests: ASNM_BaseTests {
    
    private func applyMove(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.e(on: element) 
    }
    
}


// both
extension ASUT_NM_e_Tests {
    
    func test_that_when_there_is_no_word_forward_it_goes_to_the_end_limit() {
        let text = "in that sentence the move can't find a word forward...        "
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 62,
            caretLocation: 54,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullText: text,
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
       
    func test_that_when_there_is_a_word_forward_it_goes_to_the_end_of_it() {
        let text = """
now we're talking
you little mf hehe
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 36,
            caretLocation: 27,
            selectedLength: 1,
            selectedText: "t",
            currentLine: AccessibilityTextElementLine(
                fullText: text,
                number: 2,
                start: 18,
                end: 36
            )
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 30)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
