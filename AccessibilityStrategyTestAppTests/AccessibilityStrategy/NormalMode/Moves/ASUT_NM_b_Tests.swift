@testable import AccessibilityStrategy
import XCTest


// now TE funcs can return nil if a word is not found (backward, forward, etc.).
// the TE funcs are heavily tested by themselves. here we test only what is necessary for
// this move, which is the difference between when a TE func returns nil (can't find word) and returns a range (finds word).
class ASUT_NM_b_Tests: ASNM_BaseTests {
    
    private func applyMove(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.b(on: element) 
    }
    
}


// both
extension ASUT_NM_b_Tests {
    
    func test_that_when_there_is_no_word_backward_it_goes_to_0() {
        let text = "🚔️aretLocation at the first character of the text"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 50,
            caretLocation: 0,
            selectedLength: 3,
            selectedText: "🚔️",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 50,
                number: 1,
                start: 0,
                end: 50
            )
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 0)
        XCTAssertEqual(returnedElement?.selectedLength, 3)
        XCTAssertNil(returnedElement?.selectedText)
    }
       
    func test_that_when_there_is_a_word_backward_it_goes_to_the_beginning_of_it() {
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
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 2,
                start: 18,
                end: 31
            )
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 22)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
