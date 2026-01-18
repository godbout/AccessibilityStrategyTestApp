@testable import AccessibilityStrategy
import XCTest


class FT_beginningOfWordForward_Tests: XCTestCase {}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension FT_beginningOfWordForward_Tests {
    
    func test_that_if_the_text_is_empty_then_it_returns_nil() {
        let text = ""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordForwardLocation = fileText.beginningOfWordForward(startingAt: 0)
        
        XCTAssertNil(beginningOfWordForwardLocation)
    }
    
    func test_that_if_the_caret_is_after_the_last_character_on_an_EmptyLine_then_it_returns_nil() {
        let text = """
a couple of
lines but not
coke haha but
with linefeed

"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordForwardLocation = fileText.beginningOfWordForward(startingAt: 54)
        
        XCTAssertNil(beginningOfWordForwardLocation)
    }
    
}
    

// TextFields and TextViews
extension FT_beginningOfWordForward_Tests {
    
    func test_that_it_can_go_to_the_beginning_of_the_next_word() {
        let text = "a few words to live by"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordForwardLocation = fileText.beginningOfWordForward(startingAt: 6)
        
        XCTAssertEqual(beginningOfWordForwardLocation, 12)
    }
    
    func test_that_it_stops_at_punctuations() {
        let text = "class wordForwardTests: XCTestCase {"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordForwardLocation = fileText.beginningOfWordForward(startingAt: 8)
        
        XCTAssertEqual(beginningOfWordForwardLocation, 22)
    }
    
    func test_that_it_does_not_get_blocked_at_a_punctuation() {
        let text = "textEngine.wordForward"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordForwardLocation = fileText.beginningOfWordForward(startingAt: 10)
        
        XCTAssertEqual(beginningOfWordForwardLocation, 11)
    }
    
    func test_that_it_does_not_stop_at_an_underscore() {
        let text = "func test_that_it_does_not_stop_at_an_underscore() {"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordForwardLocation = fileText.beginningOfWordForward(startingAt: 5)
        
        XCTAssertEqual(beginningOfWordForwardLocation, 48)
    }
    
    func test_that_it_passes_several_consecutive_whitespaces() {
        let text = "this is some text with        space"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordForwardLocation = fileText.beginningOfWordForward(startingAt: 20)
        
        XCTAssertEqual(beginningOfWordForwardLocation, 30)
    }
        
    func test_that_if_the_caretLocation_is_at_the_end_limit_of_the_text_before_applying_the_move_then_it_returns_nil() {
        let text = "w at the end of the buffer shouldn't craaaash"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordForwardLocation = fileText.beginningOfWordForward(startingAt: 44)

        XCTAssertNil(beginningOfWordForwardLocation)
    }
    
    func test_that_if_the_caretLocation_is_not_at_the_end_limit_of_the_text_before_applying_the_move_but_ends_there_after_then_it_returns_the_end_limit_of_the_text() {
        let text = "w at the end of the buffer shouldn't craaaash"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordForwardLocation = fileText.beginningOfWordForward(startingAt: 42)

        XCTAssertEqual(beginningOfWordForwardLocation, 44)
    }
    
    func test_that_it_passes_several_consecutive_punctuations() {
        let text = "for index in text[anchorIndex..<endIndex].indices {"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordForwardLocation = fileText.beginningOfWordForward(startingAt: 29)
        
        XCTAssertEqual(beginningOfWordForwardLocation, 32)
    }
    
    func test_that_it_does_not_stop_at_a_space_after_a_punctuation() {
        let text = "let anchorIndex = text.index(text.startIndex, offsetBy: location)"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordForwardLocation = fileText.beginningOfWordForward(startingAt: 54)
        
        XCTAssertEqual(beginningOfWordForwardLocation, 56)
    }
    
    func test_that_it_does_not_stop_at_a_space_after_a_symbol() {
        let text = "guard index != text.index(before: endIndex) else { return text.count - 1 }"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordForwardLocation = fileText.beginningOfWordForward(startingAt: 12)
        
        XCTAssertEqual(beginningOfWordForwardLocation, 15)
    }
    
    func test_that_it_does_not_stop_at_a_space_after_a_number() {
        let text = "guard index != text.index(before: endIndex) else { return text.count - 1 }"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordForwardLocation = fileText.beginningOfWordForward(startingAt: 71)
        
        XCTAssertEqual(beginningOfWordForwardLocation, 73)
    }
    
    func test_that_it_stops_at_underscores_that_are_not_part_of_a_word() {
        let text = """
if text[nextIndex] == "_" {
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordForwardLocation = fileText.beginningOfWordForward(startingAt: 22)
        
        XCTAssertEqual(beginningOfWordForwardLocation, 23)
    }
    
    func test_that_it_stops_at_punctuations_that_are_preceded_by_an_underscore() {
        let text = """
if text[nextIndex] == "_" {
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordForwardLocation = fileText.beginningOfWordForward(startingAt: 23)
        
        XCTAssertEqual(beginningOfWordForwardLocation, 24)
    }
    
    func test_that_it_does_not_stop_at_numbers_that_are_part_of_a_word() {
        let text = "saf sadfhasdf4asdf dfd"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordForwardLocation = fileText.beginningOfWordForward(startingAt: 5)
        
        XCTAssertEqual(beginningOfWordForwardLocation, 19)
    }
    
    func test_that_letters_numbers_and_underscores_together_are_considered_a_word() {
        let text = "this is gonna be only one word__oh_my_55_a yes"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordForwardLocation = fileText.beginningOfWordForward(startingAt: 26)
        
        XCTAssertEqual(beginningOfWordForwardLocation, 43)
    }
    
    func test_that_it_does_not_stop_after_an_underscore_that_finishes_a_word() {
        let text = "but who writes stuff like_ this"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordForwardLocation = fileText.beginningOfWordForward(startingAt: 23)
        
        XCTAssertEqual(beginningOfWordForwardLocation, 27)
    }

}

// TextViews
extension FT_beginningOfWordForward_Tests {

    func test_that_it_does_not_get_blocked_on_a_line() {
        let text = """
w can go
to the next line
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordForwardLocation = fileText.beginningOfWordForward(startingAt: 7)

        XCTAssertEqual(beginningOfWordForwardLocation, 9)
    }
    
    func test_that_it_stops_at_an_EmptyLine() {
        let text = """
w should stop

at empty lines
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordForwardLocation = fileText.beginningOfWordForward(startingAt: 12)
        
        XCTAssertEqual(beginningOfWordForwardLocation, 14)
    }

    func test_that_it_does_not_stop_at_a_line_that_has_just_whitespaces() {
        let text = """
w shouldn't stop
at the following line that looks empty but has
   
whitespaces
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordForwardLocation = fileText.beginningOfWordForward(startingAt: 62)

        XCTAssertEqual(beginningOfWordForwardLocation, 68)
    }

}


// emojis
// see beginningOfWordBackward for the blah blah
extension FT_beginningOfWordForward_Tests {

    func test_that_it_handles_emojis() {
        let text = "emojis are symbols that 🔫️🔫️🔫️ are longer than 1 length"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWordForwardLocation = fileText.beginningOfWordForward(startingAt: 27)
        
        XCTAssertEqual(beginningOfWordForwardLocation, 34)
    }
    
}
