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

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 0)
        
        XCTAssertNil(endOfWordBackwardLocation)
    }
    
    func test_that_if_the_caret_is_after_the_last_character_on_an_EmptyLine_then_it_still_goes_to_the_end_of_the_last_word() {
        let text = """
a couple of
lines but not
coke haha but
with linefeed

"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 54)
        
        XCTAssertEqual(endOfWordBackwardLocation, 52)
    }
    
}


// Both
extension FT_endOfWordBackward_Tests {
    
    func test_that_it_can_go_to_the_end_of_the_previous_word() {
        let text = "a few words to live by"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 18)
        
        XCTAssertEqual(endOfWordBackwardLocation, 13)
    }
        
    func test_that_it_stops_at_the_end_of_a_punctuation() {
        let text = "textEngine....wordBackward(startingAt: 18, in: TextEngineText(from: text))"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 17)
        
        XCTAssertEqual(endOfWordBackwardLocation, 13)
    }
    
    func test_that_it_passes_several_consecutive_punctuations() {
        let text = "textEngine....wordBackward(startingAt: 18, in: TextEngineText(from: text))"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 13)
        
        XCTAssertEqual(endOfWordBackwardLocation, 9)
    }
    
    func test_that_it_does_not_stop_at_an_underscore() {
        let text = "func test_that_it_does_not_stop_at_an_underscore() {"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 47)
        
        XCTAssertEqual(endOfWordBackwardLocation, 3)
    }
    
    func test_that_it_passes_several_consecutive_whitespaces() {
        let text = "this is some text with        space"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 30)
        
        XCTAssertEqual(endOfWordBackwardLocation, 21)
    }
    
    func test_that_if_the_caretLocation_is_at_the_beginning_of_the_text_before_the_move_is_applied_then_it_returns_nil() {
        let text = "starting already from the beginning of the text will return nil"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 0)
        
        XCTAssertNil(endOfWordBackwardLocation)
    }
    
    func test_that_if_the_caretLocation_is_not_at_the_beginning_of_the_text_before_the_move_is_applied_but_ends_there_after_it_returns_0() {
        let text = "  yoooooo my man"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 8)
        
        XCTAssertEqual(endOfWordBackwardLocation, 0)
    }
    
    func test_that_it_stops_at_punctuations_that_are_after_an_underscore() {
        let text = """
if text[index] == "_" {
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 22)
        
        XCTAssertEqual(endOfWordBackwardLocation, 20)
    }
    
    func test_that_it_stops_at_underscores_that_are_not_part_of_a_word() {
        let text = """
if text[index] == "_" {
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 20)
        
        XCTAssertEqual(endOfWordBackwardLocation, 19)
    }
    
    func test_that_it_stops_at_symbols_that_are_before_a_whitespace() {
        let text = """
if text[index] == "_" {
"""

        let fileText = FileText(end: text.utf16.count, value: text)
                
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 18)
        
        XCTAssertEqual(endOfWordBackwardLocation, 16)
    }
    
    func test_that_it_does_not_stop_at_numbers_when_part_of_a_word() {
        let text = "it is somewordwith5numbers in it"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 24)
        
        XCTAssertEqual(endOfWordBackwardLocation, 4)
    }
    
    func test_that_it_does_stop_at_numbers_by_themselves() {
        let text = "numbers by themselves 8 are a word!"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 26)
        
        XCTAssertEqual(endOfWordBackwardLocation, 22)
    }
    
    func test_that_it_skips_consecutive_numbers() {
        let text = "numbers by themselves 8888 are a word!"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 29)
        
        XCTAssertEqual(endOfWordBackwardLocation, 25)                
    }
    
    func test_that_it_stops_at_symbols() {
        let text = "it is something+else yeah"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 19)
        
        XCTAssertEqual(endOfWordBackwardLocation, 15)
    }
    
    func test_that_it_skips_consecutive_symbols() {
        let text = "it is something=€=+else yeah"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 18)
        
        XCTAssertEqual(endOfWordBackwardLocation, 14)
    }
    
    func test_that_it_does_not_stop_at_a_symbol_if_it_is_followed_by_a_punctuation() {
        let text = "ext[index] != 28"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 12)
        
        XCTAssertEqual(endOfWordBackwardLocation, 9)
    }
    
    func test_that_letters_numbers_and_underscores_together_are_considered_a_word() {
        let text = "this is gonna be only one word__oh_my_55_a yes"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 41)
        
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

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 22)
        
        XCTAssertEqual(endOfWordBackwardLocation, 19)
    }
    
    func test_that_it_stops_at_an_EmptyLine() {
        let text = """
ge should stop

at empty lines
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 16)
        
        XCTAssertEqual(endOfWordBackwardLocation, 15)
    }
    
    func test_that_it_stops_at_an_EmptyLine_but_skip_the_whitespaces_on_the_current_line() {
        let text = """
ge should stop at empty lines and

    skip the whitespaces on this line
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 42)
        
        XCTAssertEqual(endOfWordBackwardLocation, 34)
    }
    
    func test_that_it_does_not_stop_at_a_line_that_has_just_whitespaces() {
        let text = """
ge shouldn't stop
at the previous line that looks empty but has
   
whitespaces
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 73)
        
        XCTAssertEqual(endOfWordBackwardLocation, 62)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FT_endOfWordBackward_Tests {
    
    func test_that_it_handles_emojis() {
        let text = "emojis are symbols that 🔫️🔫️🔫️ are longer than 1 length"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 30)
        
        XCTAssertEqual(endOfWordBackwardLocation, 22)                
    }
    
    func test_that_if_the_caret_is_on_the_last_EmptyLine_and_the_last_visible_character_on_the_previous_line_is_an_emoji_then_the_returned_position_is_correct() {
        let text = """
emojis are symbols that 🔫️🔫️🔫️ are longer than 1 length 🔫️

"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWordBackwardLocation = fileText.endOfWordBackward(startingAt: 63)
        
        XCTAssertEqual(endOfWordBackwardLocation, 59)       
    }
    
}
