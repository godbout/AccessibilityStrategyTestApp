@testable import AccessibilityStrategy
import XCTest


// yy doesn't touch the caret position or anything else, it just copies
// the line into the NSPasteBoard.
class ASUT_NM_yy_Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.yy(on: element) 
    }
    
}


// line
extension ASUT_NM_yy_Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen lines. it will just pass by
them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 115,
            caretLocation: 40,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 2,
                start: 27,
                end: 54
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "this move does not stop at screen lines. it will just pass by\n")
        XCTAssertEqual(returnedElement?.caretLocation, 40)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
     
}



// Both
extension ASUT_NM_yy_Tests {
    
    func test_that_in_normal_setting_it_copies_the_line_into_the_buffer() {
        let text = "is that gonna be copied?"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 24,
            caretLocation: 12,
            selectedLength: 1,
            selectedText: "a",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 24,
                number: 1,
                start: 0,
                end: 24
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), text)
        XCTAssertEqual(returnedElement?.caretLocation, 12)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_it_includes_the_end_of_the_line_linefeed() {
        let text = 
"""
some very long multiple lines just to be sure that it
workd properly my friend
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 78,
            caretLocation: 39,
            selectedLength: 1,
            selectedText: "e",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 78,
                number: 2,
                start: 24,
                end: 46
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some very long multiple lines just to be sure that it\n")
        XCTAssertEqual(returnedElement?.caretLocation, 39)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_it_does_not_include_the_linefeed_of_the_previous_line() {
        let text = 
            """
some more long multiple lines for you because you're my best friend
again yes i know i've said 😂️ this but i need them long
my friend
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 135,
            caretLocation: 95,
            selectedLength: 3,
            selectedText: "😂️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 135,
                number: 5,
                start: 95,
                end: 120
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "again yes i know i've said 😂️ this but i need them long\n")
        XCTAssertEqual(returnedElement?.caretLocation, 95)
        XCTAssertEqual(returnedElement?.selectedLength, 3)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_if_the_text_is_empty_it_works_and_copies_the_empty_line() {
        let text = ""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 0,
            caretLocation: 0,
            selectedLength: 0,
            selectedText: "",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 0,
                number: 1,
                start: 0,
                end: 0
            )!
        )
        
        copyToClipboard(text: "test 1 of The 3 Cases")
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "")
        XCTAssertEqual(returnedElement?.caretLocation, 0)
        XCTAssertEqual(returnedElement?.selectedLength, 0)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_if_the_caret_is_at_the_last_character_of_the_text_and_on_an_empty_line_on_its_own_it_works_and_copies_the_line() {
        let text = """
caret is on its
own empty
line

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 31,
            caretLocation: 31,
            selectedLength: 0,
            selectedText: "",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 4,
                start: 31,
                end: 31
            )!
        )
        
        copyToClipboard(text: "test 3 of The 3 cases")
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "")
        XCTAssertEqual(returnedElement?.caretLocation, 31)
        XCTAssertEqual(returnedElement?.selectedLength, 0)
        XCTAssertNil(returnedElement?.selectedText)
    }    
    
}
