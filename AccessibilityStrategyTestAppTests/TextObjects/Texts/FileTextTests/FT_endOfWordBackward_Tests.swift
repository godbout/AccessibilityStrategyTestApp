@testable import AccessibilityStrategy
import XCTest


class FT_endOfWordBackward_Tests: XCTestCase {}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension FT_endOfWordBackward_Tests {
    
    func test_that_if_the_text_is_empty_then_it_returns_nil() {
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
            )
        )
        
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 0)
        
        XCTAssertNil(endOfWordBackwardLocation)
    }
    
    func test_that_if_the_caret_is_after_the_last_character_on_an_empty_line_then_it_still_goes_to_the_end_of_the_last_word() {
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 54,
                number: 5,
                start: 54,
                end: 54
            )
        )
        
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 54)
        
        XCTAssertEqual(endOfWordBackwardLocation, 52)
    }
    
}


// Both
extension FT_endOfWordBackward_Tests {
    
    func test_that_it_can_go_to_the_end_of_the_previous_word() {
        let text = "a few words to live by"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 22,
            caretLocation: 18,
            selectedLength: 1,
            selectedText: "e",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 22,
                number: 2,
                start: 12,
                end: 22
            )
        )
        
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 18)
        
        XCTAssertEqual(endOfWordBackwardLocation, 13)
    }
        
    func test_that_it_stops_at_the_end_of_a_punctuation() {
        let text = "textEngine....wordBackward(startingAt: 18, in: TextEngineText(from: text))"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 74,
            caretLocation: 17,
            selectedLength: 1,
            selectedText: "d",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 74,
                number: 2,
                start: 12,
                end: 24
            )
        )
        
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 17)
        
        XCTAssertEqual(endOfWordBackwardLocation, 13)
    }
    
    func test_that_it_passes_several_consecutive_punctuations() {
        let text = "textEngine....wordBackward(startingAt: 18, in: TextEngineText(from: text))"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 74,
            caretLocation: 13,
            selectedLength: 1,
            selectedText: ".",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 74,
                number: 2,
                start: 12,
                end: 24
            )
        )
        
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 13)
        
        XCTAssertEqual(endOfWordBackwardLocation, 9)
    }
    
    func test_that_it_does_not_stop_at_an_underscore() {
        let text = "func test_that_it_does_not_stop_at_an_underscore() {"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 52,
            caretLocation: 47,
            selectedLength: 1,
            selectedText: "e",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 52,
                number: 5,
                start: 41,
                end: 52
            )
        )
        
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 47)
        
        XCTAssertEqual(endOfWordBackwardLocation, 3)
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 3,
                start: 30,
                end: 35
            )
        )
        
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 30)
        
        XCTAssertEqual(endOfWordBackwardLocation, 21)
    }
    
    func test_that_if_the_caretLocation_is_at_the_beginning_of_the_text_before_the_move_is_applied_then_it_returns_nil() {
        let text = "starting already from the beginning of the text will return nil"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 63,
            caretLocation: 0,
            selectedLength: 1,
            selectedText: "s",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 63,
                number: 1,
                start: 0,
                end: 9
            )
        )
        
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 0)
        
        XCTAssertNil(endOfWordBackwardLocation)
    }
    
    func test_that_if_the_caretLocation_is_not_at_the_beginning_of_the_text_before_the_move_is_applied_but_ends_there_after_it_returns_0() {
        let text = "  yoooooo my man"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 16,
            caretLocation: 8,
            selectedLength: 1,
            selectedText: "o",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 16,
                number: 1,
                start: 0,
                end: 13
            )
        )
        
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 8)
        
        XCTAssertEqual(endOfWordBackwardLocation, 0)
    }
    
    func test_that_it_stops_at_punctuations_that_are_after_an_underscore() {
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 23,
                number: 3,
                start: 15,
                end: 23
            )
        )
                
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 22)
        
        XCTAssertEqual(endOfWordBackwardLocation, 20)
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 23,
                number: 3,
                start: 15,
                end: 23
            )
        )

        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 20)
        
        XCTAssertEqual(endOfWordBackwardLocation, 19)
    }
    
    func test_that_it_stops_at_symbols_that_are_before_a_whitespace() {
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
           currentScreenLine: ScreenLine(
               fullTextValue: text,
               fullTextLength: 23,
               number: 3,
               start: 15,
               end: 23
           )
       )
        
                
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 18)
        
        XCTAssertEqual(endOfWordBackwardLocation, 16)
    }
    
    func test_that_it_does_not_stop_at_numbers_when_part_of_a_word() {
        let text = "it is somewordwith5numbers in it"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 32,
            caretLocation: 24,
            selectedLength: 1,
            selectedText: "r",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 32,
                number: 3,
                start: 18,
                end: 30
            )
        )
        
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 24)
        
        XCTAssertEqual(endOfWordBackwardLocation, 4)
    }
    
    func test_that_it_does_stop_at_numbers_by_themselves() {
        let text = "numbers by themselves 8 are a word!"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 35,
            caretLocation: 26,
            selectedLength: 1,
            selectedText: "e",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 3,
                start: 24,
                end: 35
            )
        )
        
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 26)
        
        XCTAssertEqual(endOfWordBackwardLocation, 22)
    }
    
    func test_that_it_skips_consecutive_numbers() {
        let text = "numbers by themselves 8888 are a word!"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 38,
            caretLocation: 29,
            selectedLength: 1,
            selectedText: "e",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 38,
                number: 3,
                start: 22,
                end: 33
            )
        )
        
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 29)
        
        XCTAssertEqual(endOfWordBackwardLocation, 25)                
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 25,
                number: 3,
                start: 18,
                end: 25
            )
        )
        
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 19)
        
        XCTAssertEqual(endOfWordBackwardLocation, 15)
    }
    
    func test_that_it_skips_consecutive_symbols() {
        let text = "it is something=€=+else yeah"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 28,
            caretLocation: 18,
            selectedLength: 1,
            selectedText: "+",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 28,
                number: 3,
                start: 18,
                end: 28
            )
        )
        
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 18)
        
        XCTAssertEqual(endOfWordBackwardLocation, 14)
    }
    
    func test_that_it_does_not_stop_at_a_symbol_if_it_is_followed_by_a_punctuation() {
        let text = "ext[index] != 28"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 16,
            caretLocation: 12,
            selectedLength: 1,
            selectedText: "=",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 16,
                number: 2,
                start: 12,
                end: 16
            )
        )
        
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 12)
        
        XCTAssertEqual(endOfWordBackwardLocation, 9)
    }
    
    func test_that_letters_numbers_and_underscores_together_are_considered_a_word() {
        let text = "this is gonna be only one word__oh_my_55_a yes"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 46,
            caretLocation: 41,
            selectedLength: 1,
            selectedText: "a",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 46,
                number: 5,
                start: 38,
                end: 46
            )
        )
        
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 41)
        
        XCTAssertEqual(endOfWordBackwardLocation, 24)
    }
    
}


// TextViews
extension FT_endOfWordBackward_Tests {
    
    func test_that_it_does_not_get_blocked_on_a_line() {
        let text = """
to the previous line
ge can go
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 30,
            caretLocation: 22,
            selectedLength: 1,
            selectedText: "e",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 30,
                number: 4,
                start: 21,
                end: 30
            )
        )
        
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 22)
        
        XCTAssertEqual(endOfWordBackwardLocation, 19)
    }
    
    func test_that_it_stops_at_an_empty_line() {
        let text = """
ge should stop

at empty lines
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 30,
            caretLocation: 16,
            selectedLength: 1,
            selectedText: "a",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 30,
                number: 4,
                start: 16,
                end: 25
            )
        )
        
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 16)
        
        XCTAssertEqual(endOfWordBackwardLocation, 15)
    }
    
    func test_that_it_stops_at_an_empty_line_but_skip_the_whitespaces_on_the_current_line() {
        let text = """
ge should stop at empty lines and

    skip the whitespaces on this line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 72,
            caretLocation: 42,
            selectedLength: 1,
            selectedText: "p",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 72,
                number: 6,
                start: 35,
                end: 48
            )
        )
        
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 42)
        
        XCTAssertEqual(endOfWordBackwardLocation, 34)
    }
    
    func test_that_it_does_not_stop_at_a_line_that_has_just_whitespaces() {
        let text = """
ge shouldn't stop
at the previous line that looks empty but has
   
whitespaces
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 79,
            caretLocation: 73,
            selectedLength: 1,
            selectedText: "s",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 79,
                number: 9,
                start: 68,
                end: 79
            )
        )
        
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 73)
        
        XCTAssertEqual(endOfWordBackwardLocation, 62)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FT_endOfWordBackward_Tests {
    
    func test_that_it_handles_emojis() {
        let text = "emojis are symbols that 🔫️🔫️🔫️ are longer than 1 length"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 58,
            caretLocation: 30,
            selectedLength: 3,
            selectedText: "🔫️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 58,
                number: 3,
                start: 24,
                end: 38
            )
        )
        
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 30)
        
        XCTAssertEqual(endOfWordBackwardLocation, 22)                
    }
    
    func test_that_if_the_caret_is_on_the_last_empty_line_and_the_last_visible_character_on_the_previous_line_is_an_emoji_then_the_returned_position_is_correct() {
        let text = """
emojis are symbols that 🔫️🔫️🔫️ are longer than 1 length 🔫️

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 63,
            caretLocation: 63,
            selectedLength: 0,
            selectedText: "",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 63,
                number: 6,
                start: 63,
                end: 63
            )
        )
        
        let endOfWordBackwardLocation = element.fileText.endOfWordBackward(startingAt: 63)
        
        XCTAssertEqual(endOfWordBackwardLocation, 59)       
    }
    
}
