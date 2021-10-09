@testable import AccessibilityStrategy
import XCTest


class FT_beginningOfWordBackward__Tests: XCTestCase {}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension FT_beginningOfWordBackward__Tests {
    
    func test_that_if_the_text_is_empty_then_it_returns_nil() {
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
        
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 0)
        
        XCTAssertNil(beginningOfWordBackwardLocation)
    }
    
    func test_that_if_the_caret_is_after_the_last_character_on_an_empty_line_then_it_still_goes_to_the_beginning_of_the_last_word() {
        let text = """
a couple of
lines but not
coke haha but
with linefeed

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 54,
            caretLocation: 54,
            selectedLength: 0,
            selectedText: "",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 54,
                number: 8,
                start: 54,
                end: 54
            )
        )
        
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 54)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 45)
    }
    
}


// Both
extension FT_beginningOfWordBackward__Tests {
    
    func test_that_it_can_go_to_the_beginning_of_the_current_word() {
        let text = "a few words to live by"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 22,
            caretLocation: 18,
            selectedLength: 1,
            selectedText: "e",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 22,
                number: 2,
                start: 12,
                end: 22
            )
        )
        
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 18)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 15)
    }
    
    func test_that_it_can_go_to_the_beginning_of_the_previous_word() {
        let text = "a few words to live by"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 22,
            caretLocation: 15,
            selectedLength: 1,
            selectedText: "l",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 22,
                number: 2,
                start: 12,
                end: 22
            )
        )
        
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 15)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 12)
    }
    
    func test_that_it_stops_at_the_beginning_of_a_word_before_a_punctuation() {
        let text = "textEngine.wordBackward(startingAt: 18, in: TextEngineText(from: text))"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 71,
            caretLocation: 20,
            selectedLength: 1,
            selectedText: "a",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 71,
                number: 2,
                start: 12,
                end: 24
            )
        )
        
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 20)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 11)
    }
    
    func test_that_it_stops_at_the_beginning_of_a_punctuation() {
        let text = "textEngine....wordBackward(startingAt: 18, in: TextEngineText(from: text))"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 74,
            caretLocation: 11,
            selectedLength: 1,
            selectedText: ".",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 74,
                number: 1,
                start: 0,
                end: 12
            )
        )
        
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 11)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 10)
    }
    
    func test_that_it_passes_several_consecutive_punctuations() {
        let text = "textEngine....wordBackward(startingAt: 18, in: TextEngineText(from: text))"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 74,
            caretLocation: 14,
            selectedLength: 1,
            selectedText: "w",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 74,
                number: 2,
                start: 12,
                end: 24
            )
        )
        
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 14)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 10)
    }
    
    func test_that_it_does_not_stop_at_an_underscore() {
        let text = "func test_that_it_does_not_stop_at_an_underscore() {"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 52,
            caretLocation: 48,
            selectedLength: 1,
            selectedText: "(",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 52,
                number: 5,
                start: 41,
                end: 52
            )
        )
        
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 48)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 5)
    }
    
    func test_that_it_passes_several_consecutive_whitespaces() {
        let text = "this is some text with        space"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 35,
            caretLocation: 30,
            selectedLength: 1,
            selectedText: "s",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 3,
                start: 30,
                end: 35
            )
        )
        
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 30)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 18)
    }
        
    func test_that_if_the_caretLocation_is_at_the_beginning_of_the_text_before_the_move_is_applied_then_it_returns_nil() {
        let text = "yoooooo my man"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 14,
            caretLocation: 0,
            selectedLength: 1,
            selectedText: "y",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 14,
                number: 1,
                start: 0,
                end: 11
            )
        )
        
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 0)
        
        XCTAssertNil(beginningOfWordBackwardLocation)
    }
    
    func test_that_if_the_caretLocation_is_not_at_the_beginning_of_the_text_before_the_move_is_applied_but_ends_there_after_it_returns_0() {
        let text = "               yoooo my man"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 27,
            caretLocation: 5,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 27,
                number: 1,
                start: 0,
                end: 15
            )
        )
        
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 5)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 0)
    }
    
    func test_that_it_stops_at_punctuations_that_are_before_an_underscore() {
        let text = """
if text[index] == "_" {
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 23,
            caretLocation: 22,
            selectedLength: 1,
            selectedText: "{",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 23,
                number: 3,
                start: 15,
                end: 23
            )
        )
                
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 22)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 20)
    }
    
    func test_that_it_stops_at_underscores_that_are_not_part_of_a_word() {
        let text = """
if text[index] == "_" {
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 23,
            caretLocation: 20,
            selectedLength: 1,
            selectedText: "\"",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 23,
                number: 3,
                start: 15,
                end: 23
            )
        )
                
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 20)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 19)
    }
    
    func test_that_it_stops_at_symbols_that_are_after_a_whitespace() {
        let text = """
if text[index] == "_" {
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 23,
            caretLocation: 18,
            selectedLength: 1,
            selectedText: "\"",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 23,
                number: 3,
                start: 15,
                end: 23
            )
        )
                
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 18)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 15)
    }
    
    func test_that_it_does_not_stop_at_numbers_when_part_of_a_word() {
        let text = "it is somewordwith5numbers in it"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 32,
            caretLocation: 16,
            selectedLength: 1,
            selectedText: "t",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 32,
                number: 2,
                start: 6,
                end: 18
            )
        )
        
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 16)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 6)
    }
    
    func test_that_it_does_stop_at_numbers_by_themselves() {
        let text = "numbers by themselves 8 are a word!"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 35,
            caretLocation: 24,
            selectedLength: 1,
            selectedText: "a",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 3,
                start: 24,
                end: 35
            )
        )
        
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 24)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 22)
    }
    
    func test_that_it_skips_consecutive_numbers() {
        let text = "numbers by themselves 8888 are a word!"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 38,
            caretLocation: 27,
            selectedLength: 1,
            selectedText: "a",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 38,
                number: 3,
                start: 22,
                end: 33
            )
        )
        
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 27)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 22)                
    }
    
    func test_that_it_stops_at_symbols() {
        let text = "it is something+else yeah"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 25,
            caretLocation: 19,
            selectedLength: 1,
            selectedText: "e",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 25,
                number: 3,
                start: 18,
                end: 25
            )
        )
        
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 19)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 16)
    }
    
    func test_that_it_skips_consecutive_symbols() {
        let text = "it is something=€=+else yeah"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 28,
            caretLocation: 19,
            selectedLength: 1,
            selectedText: "e",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 28,
                number: 3,
                start: 18,
                end: 28
            )
        )
        
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 19)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 15)
    }
    
    func test_that_it_does_not_stop_at_a_symbol_if_it_is_preceded_by_a_punctuation_except_underscore() {
        let text = "ext[index] != 28"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 16,
            caretLocation: 14,
            selectedLength: 1,
            selectedText: "2",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 16,
                number: 2,
                start: 12,
                end: 16
            )
        )
        
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 14)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 11)
    }
    
    func test_that_letters_numbers_and_underscores_together_are_considered_a_word() {
        let text = "this is gonna be only one word__oh_my_55_a yes"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 46,
            caretLocation: 43,
            selectedLength: 1,
            selectedText: "y",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 46,
                number: 5,
                start: 38,
                end: 46
            )
        )
        
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 43)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 26)
    }
        
}
    

// TextViews
extension FT_beginningOfWordBackward__Tests {
    
    func test_that_it_does_not_get_blocked_on_a_line() {
        let text = """
to the previous line
b can go
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 29,
            caretLocation: 21,
            selectedLength: 1,
            selectedText: "b",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 29,
                number: 4,
                start: 21,
                end: 29
            )
        )
        
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 21)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 16)
    }
    
    func test_that_it_stops_at_an_empty_line() {
        let text = """
b should stop

at empty lines
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 29,
            caretLocation: 15,
            selectedLength: 1,
            selectedText: "a",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 29,
                number: 4,
                start: 15,
                end: 24
            )
        )
        
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 15)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 14)
    }
    
    func test_that_it_stops_at_an_empty_line_but_skip_the_whitespaces_on_the_current_line() {
        let text = """
b should stop at empty lines and 

    skip the whitespaces on this line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 72,
            caretLocation: 39,
            selectedLength: 1,
            selectedText: "s",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 72,
                number: 6,
                start: 35,
                end: 48
            )
        )
        
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 39)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 34)
    }
    
    func test_that_it_does_not_stop_at_a_line_that_has_just_whitespaces() {
        let text = """
b shouldn't stop
at the previous line that looks empty but has
   
whitespaces
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 78,
            caretLocation: 67,
            selectedLength: 1,
            selectedText: "w",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 78,
                number: 9,
                start: 67,
                end: 78
            )
        )
        
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 67)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 59)
    }
    
}


// emojis
// emojis are symbols so as long as we take care of the emojis length, all the rest
// works exactly like symbols: passing, skipping, part or not of words, etc...
// so no need to test those parts again.
extension FT_beginningOfWordBackward__Tests {

    func test_that_it_handles_emojis() {
        let text = "emojis are symbols that 🔫️🔫️🔫️ are longer than 1 length"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 58,
            caretLocation: 30,
            selectedLength: 3,
            selectedText: "🔫️",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 58,
                number: 3,
                start: 24,
                end: 38
            )
        )
        
        let beginningOfWordBackwardLocation = element.currentFileText.beginningOfWordBackward(startingAt: 30)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 24)                
    }
    
}