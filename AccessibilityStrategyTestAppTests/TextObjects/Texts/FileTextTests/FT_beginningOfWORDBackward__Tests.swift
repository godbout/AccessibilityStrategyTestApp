@testable import AccessibilityStrategy
import XCTest


class FT_beginningOfWORDBackward_Tests: XCTestCase {}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension FT_beginningOfWORDBackward_Tests {
    
    func test_that_if_the_text_is_empty_then_it_returns_nil() {
        let text = ""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWORDBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 0)
        
        XCTAssertNil(beginningOfWORDBackwardLocation)
    }
    
    func test_that_if_the_caret_is_after_the_last_character_on_an_EmptyLine_then_it_still_goes_to_the_beginning_of_the_last_word() {
        let text = """
a couple of
lines but not
coke haha but
with linefeed

"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWORDBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 54)
        
        
        XCTAssertEqual(beginningOfWORDBackwardLocation, 45)
    }
    
}


// TextFields and TextViews
extension FT_beginningOfWORDBackward_Tests {
    
    func test_that_it_can_go_to_the_beginning_of_the_current_word() {
        let text = "a few words to live by"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWORDBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 18)
        
        XCTAssertEqual(beginningOfWORDBackwardLocation, 15)
    }
    
    func test_that_it_can_go_to_the_beginning_of_the_previous_word() {
        let text = "a few words to live by"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWORDBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 15)
        
        XCTAssertEqual(beginningOfWORDBackwardLocation, 12)
    }
    
    func test_that_it_does_not_stop_at_the_beginning_of_a_word_before_a_punctuation() {
        let text = "textEngine.wordBackward(startingAt: 18, in: TextEngineText(from: text))"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWORDBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 20)
        
        XCTAssertEqual(beginningOfWORDBackwardLocation, 0)
    }
    
    func test_that_it_does_not_stop_at_the_beginning_of_a_punctuation() {
        let text = "textEngine....wordBackward(startingAt: 18, in: TextEngineText(from: text))"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWORDBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 11)
        
        XCTAssertEqual(beginningOfWORDBackwardLocation, 0)
    }
    
    func test_that_it_passes_several_consecutive_punctuations() {
        let text = "textEngine....wordBackward(startingAt: 18, in: TextEngineText(from: text))"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWORDBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 14)
        
        XCTAssertEqual(beginningOfWORDBackwardLocation, 0)
    }
    
    func test_that_it_does_not_stop_at_an_underscore() {
        let text = "func test_that_it_does_not_stop_at_an_underscore() {"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWORDBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 48)
        
        XCTAssertEqual(beginningOfWORDBackwardLocation, 5)
    }
    
    func test_that_it_passes_several_consecutive_whitespaces() {
        let text = "this is some text with        space"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWORDBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 30)
        
        XCTAssertEqual(beginningOfWORDBackwardLocation, 18)
    }
    
    func test_that_if_the_caretLocation_is_at_the_beginning_of_the_text_before_the_move_is_applied_then_it_returns_nil() {
        let text = "yoo(ooo)o my man"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 0)
        
        XCTAssertNil(beginningOfWordBackwardLocation)
    }
    
    func test_that_if_the_caretLocation_is_not_at_the_beginning_of_the_text_before_the_move_is_applied_but_ends_there_after_it_returns_0() {
        let text = "               y(ooo)o my man"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 5)
        
        XCTAssertEqual(beginningOfWordBackwardLocation, 0)
    }
    
    func test_that_it_does_not_stop_at_punctuations_that_are_before_an_underscore() {
        let text = """
if text[index] == "_" {
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWORDBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 22)
        
        XCTAssertEqual(beginningOfWORDBackwardLocation, 18)
    }
    
    func test_that_it_does_not_stop_at_underscores_that_are_not_part_of_a_word() {
        let text = """
if text[index] == "_" {
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWORDBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 20)
        
        XCTAssertEqual(beginningOfWORDBackwardLocation, 18)
    }
    
    func test_that_it_stops_at_symbols_that_are_after_a_whitespace() {
        let text = """
if text[index] == "_" {
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWORDBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 18)
        
        XCTAssertEqual(beginningOfWORDBackwardLocation, 15)
    }
    
    func test_that_it_does_not_stop_at_numbers_when_part_of_a_word() {
        let text = "it is somewordwith5numbers in it"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWORDBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 16)
        
        XCTAssertEqual(beginningOfWORDBackwardLocation, 6)
    }
    
    func test_that_it_does_stop_at_numbers_by_themselves() {
        let text = "numbers by themselves 8 are a word!"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWORDBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 24)
        
        XCTAssertEqual(beginningOfWORDBackwardLocation, 22)
    }
    
    func test_that_it_skips_consecutive_numbers() {
        let text = "numbers by themselves 8888 are a word!"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWORDBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 27)
        
        XCTAssertEqual(beginningOfWORDBackwardLocation, 22)                
    }
    
    func test_that_it_does_not_stop_at_symbols() {
        let text = "it is something+else yeah"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWORDBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 19)
        
        XCTAssertEqual(beginningOfWORDBackwardLocation, 6)
    }
            
    func test_that_letters_numbers_and_underscores_together_are_considered_a_word() {
        let text = "this is gonna be only one word__oh_my_55_a yes"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWORDBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 43)
        
        XCTAssertEqual(beginningOfWORDBackwardLocation, 26)
    }
    
}


// TextViews
extension FT_beginningOfWORDBackward_Tests {
    
    func test_that_it_does_not_get_blocked_on_a_line() {
        let text = """
to the previous line
b can go
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWORDBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 21)
        
        XCTAssertEqual(beginningOfWORDBackwardLocation, 16)
    }
    
    func test_that_it_stops_at_an_EmptyLine() {
        let text = """
b should stop

at empty lines
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWORDBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 15)
        
        XCTAssertEqual(beginningOfWORDBackwardLocation, 14)
    }
    
    func test_that_it_stops_at_an_EmptyLine_but_skip_the_whitespaces_on_the_current_line() {
        let text = """
b should stop at empty lines and 

    skip the whitespaces on this line
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWORDBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 39)
        
        XCTAssertEqual(beginningOfWORDBackwardLocation, 34)
    }
    
    func test_that_it_does_not_stop_at_a_line_that_has_just_whitespaces() {
        let text = """
b shouldn't stop
at the previous line that looks empty but has
   
whitespaces
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWORDBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 67)
        
        XCTAssertEqual(beginningOfWORDBackwardLocation, 59)
    }
    
}

// emojis
// see beginningOfWordBackward for the blah blah
extension FT_beginningOfWORDBackward_Tests {
    
    func test_that_it_handles_emojis() {
        let text = "emojis are symbols that 🔫️🔫️hehe🔫️ are longer than 1 length"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWORDBackwardLocation = fileText.beginningOfWORDBackward(startingAt: 34)
        
        XCTAssertEqual(beginningOfWORDBackwardLocation, 24)                
    }
    
}
