@testable import AccessibilityStrategy
import XCTest


// see b for blah blah
// TODO: review comment above and in b once we reach there. new comment below for the time being
// the TE funcs have been updated to return nil now if a word cannot be found (this is because we use the TE funcs
// in many other places now, now just mimicking the Vim moves). the tests for the TE funcs are already done on their own.
// here we need to test the special cases, i.e. when the TE funcs return nil.

class ASNM_w_Tests: ASNM_BaseTests {
    
    private func applyMove(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.w(on: element)
    }
    
}

// both
extension ASNM_w_Tests {

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
beginningOfWordForward now
returns nil 😍️
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 42,
            caretLocation: 39,
            selectedLength: 3,
            selectedText: "😍️",
            currentLine: AccessibilityTextElementLine(
                fullValue: text,
                number: 2,
                start: 27,
                end: 42
            )
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 39)
        XCTAssertEqual(returnedElement?.selectedLength, 3)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
