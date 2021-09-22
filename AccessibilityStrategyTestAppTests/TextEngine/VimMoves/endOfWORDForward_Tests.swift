@testable import AccessibilityStrategy
import XCTest


class endOfWORDForwardTests: TextEngineBaseTests {}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension endOfWORDForwardTests {
    
    func test_that_if_the_text_is_empty_then_it_returns_nil() {
        let text = ""
        
        let endOfWORDForwardLocation = textEngine.endOfWORDForward(startingAt: 0, in: TextEngineText(from: text))
        
        XCTAssertNil(endOfWORDForwardLocation)
    }
    
    func test_that_if_the_caret_is_after_the_last_character_on_an_empty_line_then_it_returns_nil() {
        let text = """
a couple of
lines but not
coke haha but
with linefeed

"""
        
        let endOfWORDForwardLocation = textEngine.endOfWORDForward(startingAt: 54, in: TextEngineText(from: text))
        
        XCTAssertNil(endOfWORDForwardLocation)
    }
    
}


// Both
extension endOfWORDForwardTests {
    
    func test_that_it_can_go_to_the_end_of_the_current_word() {
        let text = "some more words to live by..."
        
        let endOfWORDForwardLocation = textEngine.endOfWORDForward(startingAt: 11, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDForwardLocation, 14)
    }
    
    func test_that_it_does_not_stop_at_spaces() {
        let text = "yep, it should just jump over spaces!"
        
        let endOfWORDForwardLocation = textEngine.endOfWORDForward(startingAt: 13, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDForwardLocation, 18)
    }
    
    func test_that_it_considers_a_group_of_symbols_and_punctuations_including_underscore_as_a_word() {
        let text = "for index in text[anchorIndex..<endIndex].indices {"
        
        let endOfWORDForwardLocation = textEngine.endOfWORDForward(startingAt: 28, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDForwardLocation, 48)
    }
    
    func test_that_it_does_not_stop_at_spaces_after_symbols() {
        let text = "func e(on element: AccessibilityTextelement?) -> AccessibilityTextElement? {"
        
        let endOfWORDForwardLocation = textEngine.endOfWORDForward(startingAt: 44, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDForwardLocation, 47)
    }
    
    func test_that_it_should_skip_consecutive_whitespaces() {
        let text = "    continue"
        
        let endOfWORDForwardLocation = textEngine.endOfWORDForward(startingAt: 1, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDForwardLocation, 11)
    }
    
    func test_that_if_the_caretLocation_is_at_the_end_limit_of_the_text_before_applying_the_move_then_it_returns_nil() {
        let text = "all those moves are fucking weird"

        let beginningOfWORDForwardLocation = textEngine.beginningOfWORDForward(startingAt: 32, in: TextEngineText(from: text))

        XCTAssertNil(beginningOfWORDForwardLocation)
    }
    
    func test_that_if_the_text_ends_with_whitespaces_which_means_there_is_no_end_of_WORD_forward_then_it_returns_nil() {
        let text = "    continue        "

        let endOfWORDForwardLocation = textEngine.endOfWORDForward(startingAt: 11, in: TextEngineText(from: text))

        XCTAssertNil(endOfWORDForwardLocation)
    }
    
    func test_that_it_should_skip_whitespaces_before_symbols() {
        let text = "offsetBy: location + 1,"
        
        let endOfWORDForwardLocation = textEngine.endOfWORDForward(startingAt: 17, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDForwardLocation, 19)
    }
    
    func test_that_it_considers_consecutive_symbols_as_a_word() {
        let text = "if text[nextIndex].isWhitespace || text[nextIndex].isCharacterThatConstitutesAVimWord()"
        
        let endOfWORDForwardLocation = textEngine.endOfWORDForward(startingAt: 30, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDForwardLocation, 33)
    }
    
}


// TextViews
extension endOfWORDForwardTests {
    
    func test_that_it_should_not_stop_on_linefeeds() {
        let text = """
guard index != text.index(before: endIndex) else { return text.count - 1 }
let nextIndex = text.index(after: index)
"""
        
        let endOfWORDForwardLocation = textEngine.endOfWORDForward(startingAt: 73, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDForwardLocation, 77)
    }
    
    func test_that_it_skips_lines_that_are_just_made_of_whitespaces() {
        let text = """
let nextIndex = text.index(after: index)
               
if text[index].isCharacterThatConstitutesAVimWord() {
"""
        
        let endOfWORDForwardLocation = textEngine.endOfWORDForward(startingAt: 39, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDForwardLocation, 58)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension endOfWORDForwardTests {
    
    func test_that_it_goes_to_the_end_of_a_WORD_made_of_emojis() {
        let text = "emojis are symbols theEat 🔫️🔫️pistol🔫️ are longer than 1 length"
        
        let endOfWORDForwardLocation = textEngine.endOfWORDForward(startingAt: 24, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDForwardLocation, 38)                
    }
    
    func test_that_it_can_pass_the_end_of_a_WORD_made_of_emojis() {
        let text = "emojis are symbols theEat 🔫️🔫️pistol🔫️ are longer than 1 length"
        
        let endOfWORDForwardLocation = textEngine.endOfWORDForward(startingAt: 38, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfWORDForwardLocation, 44)                
    }
    
}
