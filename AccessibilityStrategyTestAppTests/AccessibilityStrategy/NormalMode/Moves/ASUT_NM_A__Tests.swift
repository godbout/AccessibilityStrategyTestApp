@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_A__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.A(on: element) 
    }
    
}


// line
extension ASUT_NM_A__Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen lines. it will just pass by
them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 115,
            caretLocation: 29,
            selectedLength: 1,
            selectedText: "r",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 2,
                start: 27,
                end: 54
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 61)
        XCTAssertEqual(returnedElement?.selectedLength, 0)
        XCTAssertNil(returnedElement?.selectedText)
    }
     
}


extension ASUT_NM_A__Tests {
    
    func test_that_if_a_file_line_ends_with_a_linefeed_it_goes_after_the_last_visible_character_of_that_line() {
        let text = """
there's no such thing anymore as going to the end
of a screen line 🖥️🖥️🖥️ most of the moves have to be file line
LMAO what a dumbass i am
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 140,
            caretLocation: 60,
            selectedLength: 1,
            selectedText: "n",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 140,
                number: 4,
                start: 50,
                end: 77
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 115)
        XCTAssertEqual(returnedElement?.selectedLength, 0)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_if_a_file_line_does_not_end_with_a_linefeed_it_goes_after_the_last_visible_character_of_that_line_which_means_before_the_linefeed() {
        let text = "yes A now goes to the end of file lines rather than screen lines because i was a dumbass LMAO"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 93,
            caretLocation: 18,
            selectedLength: 1,
            selectedText: "t",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 93,
                number: 1,
                start: 0,
                end: 52
            )!
        )    
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 93)
        XCTAssertEqual(returnedElement?.selectedLength, 0)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_if_a_file_line_is_empty_it_still_stops_before_the_linefeed_and_does_not_end_on_the_line_below() {
        let text = """
yeah so it always seems easy but actually it's fucking hard

and i'm doing this not because i'm a genius but because i'm pretty dumb LMAO
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 137,
            caretLocation: 60,
            selectedLength: 1,
            selectedText: "",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 137,
                number: 4,
                start: 60,
                end: 61
            )!
        )
            
       let returnedElement = applyMoveBeingTested(on: element)
       
       XCTAssertEqual(returnedElement?.caretLocation, 60)
       XCTAssertEqual(returnedElement?.selectedLength, 0)
       XCTAssertNil(returnedElement?.selectedText)
    }

}
