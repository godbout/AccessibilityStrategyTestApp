@testable import AccessibilityStrategy
import XCTest


// see b for blah blah
class ASUT_W__Tests: ASNM_BaseTests {
    
    private func applyMove(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.W(on: element)
    }
    
}


// both
extension ASUT_W__Tests {
    
    func test_that_it_handles_empty_fields() {
        let text = ""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 0,
            caretLocation: 0,
            selectedLength: 0,
            selectedText: "",
            currentLine: AccessibilityTextElementLine(
                fullValue: text,
                number: 1,
                start: 0,
                end: 0
            )
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 0)
        XCTAssertEqual(returnedElement?.selectedLength, 0)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_it_handles_fields_that_are_not_empty_but_where_there_is_no_word_forward() {
        let text = """
beginningOfWORDForward now
returns nil😍️😍️😍️
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 47,
            caretLocation: 36,
            selectedLength: 1,
            selectedText: "i",
            currentLine: AccessibilityTextElementLine(
                fullValue: text,
                number: 2,
                start: 27,
                end: 47
            )
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 44)
        XCTAssertEqual(returnedElement?.selectedLength, 3)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
