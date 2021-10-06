@testable import AccessibilityStrategy
import XCTest


class FT_beginningOfParagraphBackward_Tests: XCTestCase {}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension FT_beginningOfParagraphBackward_Tests {
    
    func test_that_if_the_text_is_empty_then_it_returns_0() {
        let text = ""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 0,
            caretLocation: 0,
            selectedLength: 0,
            selectedText: "",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 0,
                number: 1,
                start: 0,
                end: 0
            )
        )
        
        let beginningOfParagraphBackwardLocation = element.currentFileText.beginningOfParagraphBackward(startingAt: 0)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 0)
    }
    
    func test_that_if_the_caret_is_after_the_last_character_on_an_empty_line_then_it_still_goes_to_the_beginning_of_the_paragraph() {
        let text = """
a couple of


lines but not
coke haha but
with linefeed

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 56,
            caretLocation: 56,
            selectedLength: 0,
            selectedText: "",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 56,
                number: 10,
                start: 56,
                end: 56
            )
        )
        
       	let beginningOfParagraphBackwardLocation = element.currentFileText.beginningOfParagraphBackward(startingAt: 56)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 13)
    }
    
}


// Both
extension FT_beginningOfParagraphBackward_Tests {
    
    func test_that_if_the_text_does_not_have_linefeed_then_it_stops_at_the_beginning_of_the_text() {
        let text = "like a TextField really"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 23,
            caretLocation: 19,
            selectedLength: 1,
            selectedText: "a",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 23,
                number: 1,
                start: 0,
                end: 23
            )
        )
        
        let beginningOfParagraphBackwardLocation = element.currentFileText.beginningOfParagraphBackward(startingAt: 19)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 0)
    }
    
}

// TextFields
extension FT_beginningOfParagraphBackward_Tests {
    
    func test_that_it_can_go_to_the_beginning_of_the_current_paragraph() {
        let text = """
some poetry
that is beautiful

and some more blah blah
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 54,
            caretLocation: 42,
            selectedLength: 1,
            selectedText: "r",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 54,
                number: 6,
                start: 40,
                end: 50
            )
        )
        
        let beginningOfParagraphBackwardLocation = element.currentFileText.beginningOfParagraphBackward(startingAt: 42)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 30)
    }
    
    func test_that_if_the_caret_is_already_on_an_empty_line_it_skips_all_the_consecutive_empty_lines() {
        let text = """
other hello

hello



some more
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 32,
            caretLocation: 21,
            selectedLength: 1,
            selectedText: "\n",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 32,
                number: 6,
                start: 21,
                end: 22
            )
        )
        
        let beginningOfParagraphBackwardLocation = element.currentFileText.beginningOfParagraphBackward(startingAt: 21)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 12)
    }
    
    func test_that_if_it_does_not_find_an_empty_line_it_stops_at_the_beginning_of_the_text() {
        let text = """
this
text
does not have
an empty line!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 38,
            caretLocation: 22,
            selectedLength: 1,
            selectedText: "e",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 38,
                number: 4,
                start: 19,
                end: 24
            )
        )
        
        let beginningOfParagraphBackwardLocation = element.currentFileText.beginningOfParagraphBackward(startingAt: 23)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 0)
    }
    
    func test_that_it_does_not_crash_if_the_location_is_on_the_first_line_which_is_a_linefeed() {
        let text = """

hehe first line
is a linefeed
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 30,
            caretLocation: 0,
            selectedLength: 1,
            selectedText: "\n",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 30,
                number: 1,
                start: 0,
                end: 1
            )
        )
        
        let beginningOfParagraphBackwardLocation = element.currentFileText.beginningOfParagraphBackward(startingAt: 0)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 0)
    }
    
    func test_that_it_does_not_crash_if_the_location_is_at_the_end_of_the_text() {
        let text = """
yes this can happen when the

caret is after the last character
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 63,
            caretLocation: 62,
            selectedLength: 1,
            selectedText: "r",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 63,
                number: 3,
                start: 30,
                end: 63
            )
        )
                
        let beginningOfParagraphBackwardLocation = element.currentFileText.beginningOfParagraphBackward(startingAt: 63)
        
		XCTAssertEqual(beginningOfParagraphBackwardLocation, 29)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FT_beginningOfParagraphBackward_Tests {
    
    func test_that_it_handles_emojis() {
        let text = """
yes 🐰️🐰️🐰️🐰️ this can happen🐰️🐰️ when the



🐰️🐰️car🐰️et is after the last character🐰️🐰️🐰️
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 102,
            caretLocation: 96,
            selectedLength: 3,
            selectedText: "🐰️",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 102,
                number: 5,
                start: 51,
                end: 102
            )
        )
        
        let beginningOfParagraphBackwardLocation = element.currentFileText.beginningOfParagraphBackward(startingAt: 96)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 50)
    }
    
}
