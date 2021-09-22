@testable import AccessibilityStrategy
import XCTest


class endOfWORDBackwardTests: TextEngineBaseTests {}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension endOfWORDBackwardTests {
    
    func test_that_if_the_text_is_empty_then_it_returns_nil() {
        let text = ""
        
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 0, in: TextEngineText(from: text))
        
        XCTAssertNil(endOfWORDBackwardLocation)
    }
    
    func test_that_if_the_caret_is_after_the_last_character_on_an_empty_line_then_it_still_goes_to_the_end_of_the_last_word() {
        let text = """
a couple of
lines but not
coke haha but
with linefeed

"""
        
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 54, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDBackwardLocation, 52)
    }
    
}


// Both
extension endOfWORDBackwardTests {
    
    func test_that_it_can_go_to_the_end_of_the_previous_word() {
        let text = "a few words to live by"
        
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 18, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDBackwardLocation, 13)
    }
    
    func test_that_it_does_not_stop_at_a_punctuation() {
        let text = "textEngine....wordBackward(startingAt: 18, in: TextEngineText(from: text))"
        
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 17, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDBackwardLocation, 0)
    }
    
    func test_that_it_does_not_stop_at_an_underscore() {
        let text = "func test_that_it_does_not_stop_at_an_underscore() {"
        
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 47, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDBackwardLocation, 3)
    }
    
    func test_that_it_passes_several_consecutive_whitespaces() {
        let text = "this is some text with        space"
        
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 30, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDBackwardLocation, 21)
    }
    
    func test_that_if_the_caretLocation_is_at_the_beginning_of_the_text_before_the_move_is_applied_then_it_returns_nil() {
        let text = "sta(rtin()g already from the beginning of the text will return nil"
        
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 0, in: TextEngineText(from: text))
        
        XCTAssertNil(endOfWORDBackwardLocation)
    }
    
    func test_that_if_the_caretLocation_is_not_at_the_beginning_of_the_text_before_the_move_is_applied_but_ends_there_after_it_returns_0() {
        let text = "  (yo(oooo)o my man"
        
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 8, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDBackwardLocation, 0)
    }
    
    func test_that_it_stops_at_punctuations_that_are_after_an_underscore() {
        let text = """
if text[index] == "_" {
"""
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 22, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDBackwardLocation, 20)
    }
    
    func test_that_it_does_not_stop_at_underscores_that_are_part_of_a_WORD() {
        let text = """
if text[index] == "_" {
"""
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 20, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDBackwardLocation, 16)
    }
    
    func test_that_it_stops_at_symbols_that_are_before_a_whitespace() {
        let text = """
if text[index] == "_" {
"""
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 18, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDBackwardLocation, 16)
    }
    
    func test_that_it_does_not_stop_at_numbers_when_part_of_a_word() {
        let text = "it is somewordwith5numbers in it"
        
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 24, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDBackwardLocation, 4)
    }
    
    func test_that_it_does_stop_at_numbers_by_themselves() {
        let text = "numbers by themselves 8 are a word!"
        
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 26, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDBackwardLocation, 22)
    }
    
    func test_that_it_skips_consecutive_numbers() {
        let text = "numbers by themselves 8888 are a word!"
        
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 29, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDBackwardLocation, 25)                
    }
    
    func test_that_it_does_not_stop_at_symbols() {
        let text = "it is something+else yeah"
        
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 19, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDBackwardLocation, 4)
    }
    
    func test_that_it_skips_consecutive_symbols() {
        let text = "it is something=€=+else yeah"
        
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 18, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDBackwardLocation, 4)
    }
    
    func test_that_it_does_not_stop_at_a_symbol_if_it_is_followed_by_a_punctuation() {
        let text = "ext[index] != 28"
        
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 12, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDBackwardLocation, 9)
    }
    
    func test_that_letters_numbers_and_underscores_together_are_considered_a_word() {
        let text = "this is gonna be only one word__oh_my_55_a yes"
        
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 41, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDBackwardLocation, 24)
    }
    
}


// TextViews
extension endOfWORDBackwardTests {
    
    func test_that_it_does_not_get_blocked_on_a_line() {
        let text = """
to the previous line
ge can go
"""
        
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 22, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDBackwardLocation, 19)
    }
    
    func test_that_it_stops_at_an_empty_line() {
        let text = """
ge should stop

at empty lines
"""
        
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 16, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDBackwardLocation, 15)
    }
    
    func test_that_it_stops_at_an_empty_line_but_skip_the_whitespaces_on_the_current_line() {
        let text = """
ge should stop at empty lines and

    skip the whitespaces on this line
"""
        
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 42, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDBackwardLocation, 34)
    }
    
    func test_that_it_does_not_stop_at_a_line_that_has_just_whitespaces() {
        let text = """
ge shouldn't stop
at the previous line that looks empty but has
   
whitespaces
"""
        
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 73, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDBackwardLocation, 62)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension endOfWORDBackwardTests {
    
    func test_that_it_handles_emojis() {
        let text = "emojis are symbols that 🔫️🔫️🔫️ are longer than 1 length"
        
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 30, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDBackwardLocation, 22)                
    }
    
    func test_that_if_the_caret_is_on_the_last_empty_line_and_the_last_visible_character_on_the_previous_line_is_an_emoji_then_the_returned_position_is_correct() {
        let text = """
emojis are symbols that 🔫️🔫️🔫️ are longer than 1 length 🔫️

"""
        let endOfWORDBackwardLocation = textEngine.endOfWORDBackward(startingAt: 63, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDBackwardLocation, 59)       
    }
    
}
