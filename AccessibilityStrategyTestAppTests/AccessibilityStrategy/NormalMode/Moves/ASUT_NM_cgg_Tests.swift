@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_cgg_Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.cgg(on: element) 
    }
    
}


// line
extension ASUT_NM_cgg_Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen lines. it will just pass by
them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 115,
            caretLocation: 68,
            selectedLength: 1,
            selectedText: "i",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 4,
                start: 62,
                end: 80
            )
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 0)
        XCTAssertEqual(returnedElement?.selectedLength, 115)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
     
}


// Both
extension ASUT_NM_cgg_Tests {
    
    func test_that_it_deletes_the_whole_line() {
        let text = "this is a single line ‼️‼️‼️"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 28,
            caretLocation: 10,
            selectedLength: 1,
            selectedText: "s",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 28,
                number: 1,
                start: 0,
                end: 22
            )
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 0)
        XCTAssertEqual(returnedElement?.selectedLength, 28)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
    
}


// TextViews
extension ASUT_NM_cgg_Tests {
    
    func test_that_it_deletes_from_right_before_the_linefeed_of_the_current_line_if_any_until_the_beginning_of_the_text() {
        let text = """
blah blah some line
some more
haha geh
need to deal with
those faces 🥺️☹️😂️

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 78,
            caretLocation: 35,
            selectedLength: 1,
            selectedText: "g",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 78,
                number: 4,
                start: 30,
                end: 39
            )
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 0)
        XCTAssertEqual(returnedElement?.selectedLength, 38)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
    
}
