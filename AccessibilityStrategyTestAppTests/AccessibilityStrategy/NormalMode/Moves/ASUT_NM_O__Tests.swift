@testable import AccessibilityStrategy
import XCTest


// O is a special move as it places the caret before the new linefeed
// it creates. i don't think it's possible with the AX API to not have to
// reposition the caret after pushing the new selectedText. therefore, unfortunately
// we have to call the ATEAdaptor from within the move. hence, tests have to be made
// in the UI Tests, as it's gonna modify the buffer. so most tests for O are there.
class ASNM_O__Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.O(on: element) 
    }
    
}


// line
extension ASNM_O__Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen lines. it will just pass by
them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 115,
            caretLocation: 92,
            selectedLength: 1,
            selectedText: "a",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 5,
                start: 80,
                end: 101
            )
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 62)
        XCTAssertEqual(returnedElement?.selectedLength, 0)
        XCTAssertEqual(returnedElement?.selectedText, "\n")
    }
     
}


// TextFields
extension ASNM_O__Tests {
    
    func test_that_for_a_TextField_it_does_nothing() {
        let text = "O shouldn't do anything in a TextField!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 39,
            caretLocation: 23,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 39,
                number: 1,
                start: 0,
                end: 39
            )
        )
        
		let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
