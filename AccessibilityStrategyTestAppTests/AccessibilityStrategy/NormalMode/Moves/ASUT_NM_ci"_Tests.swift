@testable import AccessibilityStrategy
import XCTest


// the ciDoubleQuote move uses the AS.ciInnerQuotedString function, so
// the tests related to grabbing the content within quotes is done there.
// here we just have the tests that are specific to ciDoubleQuote, which is checking
// the selectedText returned depending on whether the move succeeded or not (found
// quotes and deleted the content within). this selectedText status will be used
// by KVE to decide whether we should go in IM or stay in NM.
class ASNM_ciDoubleQuote_Tests: ASNM_BaseTests {
    
    private func applyMove(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.ciDoubleQuote(on: element) 
    }
    
}

// Both
extension ASNM_ciDoubleQuote_Tests {
    
    func test_that_if_it_succeeds_then_the_selectedText_is_empty() {
        let text = "so if that one \"succeeds\" it's gonna drop the bc in its own way"        
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 63,
            caretLocation: 15,
            selectedLength: 1,
            selectedText: "\"",
            currentLine: AccessibilityTextElementLine(
                fullText: text,
                number: 1,
                start: 0,
                end: 63
            )
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
    
    func test_that_if_it_does_not_succeed_then_the_selectedText_is_nil() {
        let text = "that one is gonna fail coz no quote"        
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 35,
            caretLocation: 28,
            selectedLength: 1,
            selectedText: "o",
            currentLine: AccessibilityTextElementLine(
                fullText: text,
                number: 1,
                start: 0,
                end: 35
            )
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertNil(returnedElement?.selectedText)
    }
  
}
