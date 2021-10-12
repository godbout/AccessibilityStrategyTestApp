@testable import AccessibilityStrategy
import XCTest


class ASNM_cc_Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.cc(on: element) 
    }
    
}


// line
extension ASNM_cc_Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen lines. it will just pass by
them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 115,
            caretLocation: 34,
            selectedLength: 1,
            selectedText: "l",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 2,
                start: 27,
                end: 54
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 0)
        XCTAssertEqual(returnedElement?.selectedLength, 61)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
     
}


// Both
extension ASNM_cc_Tests {
    
    func test_that_if_a_file_line_ends_with_a_linefeed_it_deletes_up_to_but_not_including_the_linefeed() {
        let text = """
looks like it's late coz it's getting harder to reason
but actually it's only 21.43 LMAOOOOOOOO
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 95,
            caretLocation: 38,
            selectedLength: 1,
            selectedText: "h",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 95,
                number: 2,
                start: 25,
                end: 48
            )!
        )  
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 0)
        XCTAssertEqual(returnedElement?.selectedLength, 54)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
    
    func test_that_if_a_file_line_does_not_end_with_a_linefeed_it_deletes_up_to_the_end() {
        let text = "yeah exactly, it could be at the end of 🌻️🌻️🌻️ a TextArea or like a TextField like this one"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 94,
            caretLocation: 43,
            selectedLength: 3,
            selectedText: "🌻️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 94,
                number: 2,
                start: 29,
                end: 61
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 0)
        XCTAssertEqual(returnedElement?.selectedLength, 94)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
    
    func test_that_it_should_keep_the_indentation_of_the_current_line() {
        let text = """
but the indent should
   i delete a line
be kept
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 48,
            caretLocation: 37,
            selectedLength: 1,
            selectedText: "i",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 48,
                number: 5,
                start: 34,
                end: 41
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 25)
        XCTAssertEqual(returnedElement?.selectedLength, 15)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
    
}
