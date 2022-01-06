@testable import AccessibilityStrategy
import XCTest


// this move uses a ScreenLine func. tested there. 
// only a few tests here, some for redundancy, some that are specific to the g^ move, like
// The 3 Cases, or the fact that it should not stop at the end of
// the line itself like firstNonBlank, but at the end limit.
class ASUT_NM_gCaret_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.gCaret(on: element) 
    }
    
}


// line
extension ASUT_NM_gCaret_Tests {
    
    // careful. there's tabs in this text. necessary to test that g^
    // goes at the first non blank of the screen line. if pasted from somewhere else
    // it needs to be pasted with `keep formatting` else Xcode will transform tabs into spaces.
    func test_conspicuously_that_it_stops_at_screen_lines() {
        let text = """
  this move stops at screen lines, which 		🇧🇶️eans it will
  stop even without a linefeed. that's 		how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 120,
            caretLocation: 57,
            selectedLength: 1,
            selectedText: "i",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 120,
                number: 2,
                start: 41,
                end: 61
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 43)
        XCTAssertEqual(returnedElement.selectedLength, 5)
        XCTAssertNil(returnedElement.selectedText)
    }
     
}


// Both
extension ASUT_NM_gCaret_Tests {
    
    func test_that_in_normal_case_it_goes_to_the_first_non_blank_of_the_line() {
        let text = "    hehe ankulay that's a long like that we gonna wrap"        
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 54,
            caretLocation: 18,
            selectedLength: 1,
            selectedText: "h",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 54,
                number: 1,
                start: 0,
                end: 26
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 4)     
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
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
            caretLocation: 72,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 86,
                number: 5,
                start: 64,
                end: 86
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 85)  
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// TextViews 
extension ASUT_NM_gCaret_Tests {
    
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
            caretLocation: 43,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 67,
                number: 6,
                start: 40,
                end: 63
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 61)   
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
