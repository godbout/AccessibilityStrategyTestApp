@testable import AccessibilityStrategy
import XCTest


class beginningOfWORDForwardTests: TextEngineBaseTests {}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension beginningOfWORDForwardTests {
    
    func test_that_if_the_text_is_empty_then_it_returns_nil() {
        let text = ""
        
        let beginningOfWORDForwardLocation = textEngine.beginningOfWORDForward(startingAt: 0, in: TextEngineText(from: text))
        
        XCTAssertNil(beginningOfWORDForwardLocation)
    }
    
    func test_that_if_the_caret_is_after_the_last_character_on_an_empty_line_then_it_returns_nils() {
        let text = """
a couple of
lines but not
coke haha but
with linefeed

"""
        
        let beginningOfWORDForwardLocation = textEngine.beginningOfWORDForward(startingAt: 54, in: TextEngineText(from: text))
        
        XCTAssertNil(beginningOfWORDForwardLocation)
    }
    
}


// Both
extension beginningOfWORDForwardTests {
    
    func test_that_it_can_go_to_the_beginning_of_the_next_WORD() {
        let text = "a few words to live by"
        
        let beginningOfWORDForwardLocation = textEngine.beginningOfWORDForward(startingAt: 6, in: TextEngineText(from: text))
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 12)
    }
    
    func test_that_it_does_not_stop_at_punctuations() {
        let text = "class wordForwardTests: XCTestCase {"
        
        let beginningOfWORDForwardLocation = textEngine.beginningOfWORDForward(startingAt: 8, in: TextEngineText(from: text))
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 24)
    }    
    
    func test_that_it_passes_several_consecutive_whitespaces() {
        let text = "this is some text with        space"
        
        let beginningOfWORDForwardLocation = textEngine.beginningOfWORDForward(startingAt: 22, in: TextEngineText(from: text))
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 30)
    }
    
    func test_that_if_it_reaches_the_end_of_the_buffer_it_and_therefore_cannot_find_a_word_forward_it_returns_nil() {
        let text = "w at the end of the buffer shouldn't craaaash"
        
        let beginningOfWORDForwardLocation = textEngine.beginningOfWORDForward(startingAt: 42, in: TextEngineText(from: text))
        
        XCTAssertNil(beginningOfWORDForwardLocation)
    }
    
    func test_that_it_passes_several_consecutive_punctuations() {
        let text = "for index in text[anchorIndex..<endIndex].indices {"
        
        let beginningOfWORDForwardLocation = textEngine.beginningOfWORDForward(startingAt: 29, in: TextEngineText(from: text))
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 50)
    }
    
    func test_that_it_does_not_stop_at_a_space_after_a_punctuation() {
        let text = "let anchorIndex = text.index(text.startIndex, offsetBy: location)"
        
        let beginningOfWORDForwardLocation = textEngine.beginningOfWORDForward(startingAt: 54, in: TextEngineText(from: text))
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 56)
    }
    
    func test_that_it_does_not_stop_at_a_space_after_a_symbol() {
        let text = "guard index != text.index(before: endIndex) else { return text.count - 1 }"
        
        let beginningOfWORDForwardLocation = textEngine.beginningOfWORDForward(startingAt: 12, in: TextEngineText(from: text))
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 15)
    }
    
    func test_that_it_does_not_stop_at_a_space_after_a_number() {
        let text = "guard index != text.index(before: endIndex) else { return text.count - 1 }"
        
        let beginningOfWORDForwardLocation = textEngine.beginningOfWORDForward(startingAt: 71, in: TextEngineText(from: text))
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 73)
    }
    
    func test_that_it_does_not_stop_at_underscores_that_are_not_part_of_a_word() {
        let text = """
if text[nextIndex] == "_" {
"""
        
        let beginningOfWORDForwardLocation = textEngine.beginningOfWORDForward(startingAt: 22, in: TextEngineText(from: text))
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 26)
    }
    
    func test_that_it_does_not_stop_at_punctuations_that_are_preceded_by_an_underscore() {
        let text = """
if text[nextIndex] == "_" {
"""
        
        let beginningOfWORDForwardLocation = textEngine.beginningOfWORDForward(startingAt: 23, in: TextEngineText(from: text))
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 26)
    }
    
    func test_that_it_does_not_stop_at_numbers_that_are_part_of_a_word() {
        let text = "saf sadfhasdf4asdf dfd"
        
        let beginningOfWORDForwardLocation = textEngine.beginningOfWORDForward(startingAt: 5, in: TextEngineText(from: text))
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 19)
    }
    
    func test_that_letters_numbers_and_underscores_together_are_considered_a_word() {
        let text = "this is gonna be only one word__oh_my_55_a yes"
        
        let beginningOfWORDForwardLocation = textEngine.beginningOfWORDForward(startingAt: 26, in: TextEngineText(from: text))
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 43)
    }
    
    func test_that_it_does_not_stop_after_an_underscore_that_finishes_a_word() {
        let text = "but who writes stuff like_ this"
        
        let beginningOfWORDForwardLocation = textEngine.beginningOfWORDForward(startingAt: 23, in: TextEngineText(from: text))
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 27)
    }
    
}


// TextViews
extension beginningOfWORDForwardTests {
    
    func test_that_it_does_not_get_blocked_on_a_line() {
        let text = """
w can go
to the next line
"""
        
        let beginningOfWORDForwardLocation = textEngine.beginningOfWORDForward(startingAt: 7, in: TextEngineText(from: text))
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 9)
    }
    
    func test_that_it_stops_at_an_empty_line() {
        let text = """
w should stop

at empty lines
"""
        
        let beginningOfWORDForwardLocation = textEngine.beginningOfWORDForward(startingAt: 12, in: TextEngineText(from: text))
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 14)
    }
    
    func test_that_it_does_not_stop_at_a_line_that_has_just_whitespaces() {
        let text = """
w shouldn't stop
at the following line that looks empty but has
   
whitespaces
"""
        
        let beginningOfWORDForwardLocation = textEngine.beginningOfWORDForward(startingAt: 63, in: TextEngineText(from: text))
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 68)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension beginningOfWORDForwardTests {

    func test_that_it_handles_emojis() {
        let text = "emojis are symbols that 🔫️🔫️haha🔫️ are longer than 1 length"

        let beginningOfWORDForwardLocation = textEngine.beginningOfWORDForward(startingAt: 27, in: TextEngineText(from: text))

        XCTAssertEqual(beginningOfWORDForwardLocation, 38)
    }

}
