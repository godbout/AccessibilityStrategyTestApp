import XCTest
@testable import AccessibilityStrategy


class ASUT_NM_caret_Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.caret(on: element) 
    }
    
}


// line
extension ASUT_NM_caret_Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
  this move stops at screen lines, which 		🇧🇶️eans it will
  stop even without a linefeed. that's 		how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 115,
            caretLocation: 29,
            selectedLength: 1,
            selectedText: "r",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 2,
                start: 27,
                end: 54
            )
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 2)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
     
}


// Both
extension ASUT_NM_caret_Tests {
    
    func test_that_in_normal_case_it_goes_to_the_first_non_blank_of_the_line() {
        let text = "    hehe ankulay"        
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 16,
            caretLocation: 11,
            selectedLength: 1,
            selectedText: "k",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 16,
                number: 2,
                start: 9,
                end: 16
            )
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 4)     
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_if_the_text_is_just_spaces_and_no_linefeed_then_the_caret_goes_at_the_end_of_the_text() {
        let text = """
a multiline
with a last line
without a linefeed but with spaces
                      
"""        
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 86,
            caretLocation: 68,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 86,
                number: 5,
                start: 64,
                end: 86
            )
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 85)  
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}


// TextViews 
extension ASUT_NM_caret_Tests {
    
    func test_that_for_spaces_and_a_linefeed_it_stops_before_the_linefeed_at_the_correct_end_limit() {
        let text = """
this time the
empty line has a linefeed
                      
 yes
"""        
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 67,
            caretLocation: 45,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 67,
                number: 6,
                start: 40,
                end: 63
            )
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 61)   
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
