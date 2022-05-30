@testable import AccessibilityStrategy
import XCTest


class FT_endOfWORDForward__Tests: XCTestCase {}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension FT_endOfWORDForward__Tests {
    
    func test_that_if_the_text_is_empty_then_it_returns_nil() {
        let text = ""

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWORDForwardLocation = fileText.endOfWORDForward(startingAt: 0)
        
        XCTAssertNil(endOfWORDForwardLocation)
    }
    
    func test_that_if_the_caret_is_after_the_last_character_on_an_empty_line_then_it_returns_nil() {
        let text = """
a couple of
lines but not
coke haha but
with linefeed

"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWORDForwardLocation = fileText.endOfWORDForward(startingAt: 54)
        
        XCTAssertNil(endOfWORDForwardLocation)
    }
    
}


// Both
extension FT_endOfWORDForward__Tests {
    
    func test_that_it_can_go_to_the_end_of_the_current_word() {
        let text = "some more words to live by..."

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWORDForwardLocation = fileText.endOfWORDForward(startingAt: 11)
        
        XCTAssertEqual(endOfWORDForwardLocation, 14)
    }
    
    func test_that_if_it_is_at_the_end_of_the_current_WORD_it_goes_to_the_end_of_the_next_WORD_instead() {
        let text = "yep, it should just jump over spaces!"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWORDForwardLocation = fileText.endOfWORDForward(startingAt: 13)
        
        XCTAssertEqual(endOfWORDForwardLocation, 18)
    }
    
    func test_that_it_considers_a_group_of_symbols_and_punctuations_including_underscore_as_a_word() {
        let text = "for index in text[anchorIndex..<endIndex].indices {"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWORDForwardLocation = fileText.endOfWORDForward(startingAt: 28)
        
        XCTAssertEqual(endOfWORDForwardLocation, 48)
    }
    
    func test_that_it_does_not_stop_at_spaces_after_symbols() {
        let text = "func e(on element: AccessibilityTextelement?) -> AccessibilityTextElement? {"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWORDForwardLocation = fileText.endOfWORDForward(startingAt: 44)
        
        XCTAssertEqual(endOfWORDForwardLocation, 47)
    }
    
    func test_that_it_should_skip_consecutive_whitespaces() {
        let text = "    continue"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWORDForwardLocation = fileText.endOfWORDForward(startingAt: 1)
        
        XCTAssertEqual(endOfWORDForwardLocation, 11)
    }
    
    func test_that_if_the_caretLocation_is_at_the_end_limit_of_the_text_before_applying_the_move_then_it_returns_nil() {
        let text = "all those moves are fucking weird"

        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfWORDForwardLocation = fileText.endOfWORDForward(startingAt: 32)

        XCTAssertNil(beginningOfWORDForwardLocation)
    }
    
    func test_that_if_the_text_ends_with_whitespaces_which_means_there_is_no_end_of_WORD_forward_then_it_returns_nil() {
        let text = "    continue        "

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWORDForwardLocation = fileText.endOfWORDForward(startingAt: 11)

        XCTAssertNil(endOfWORDForwardLocation)
    }
    
    func test_that_it_should_skip_whitespaces_before_symbols() {
        let text = "offsetBy: location + 1,"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWORDForwardLocation = fileText.endOfWORDForward(startingAt: 17)
        
        XCTAssertEqual(endOfWORDForwardLocation, 19)
    }
    
    func test_that_it_considers_consecutive_symbols_as_a_word() {
        let text = "if text[nextIndex].isWhitespace || text[nextIndex].isCharacterThatConstitutesAVimWord()"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWORDForwardLocation = fileText.endOfWORDForward(startingAt: 30)
        
        XCTAssertEqual(endOfWORDForwardLocation, 33)
    }
    
}


// TextViews
extension FT_endOfWORDForward__Tests {
    
    func test_that_it_should_not_stop_on_linefeeds() {
        let text = """
guard index != text.index(before: endIndex) else { return text.count - 1 }
let nextIndex = text.index(after: index)
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWORDForwardLocation = fileText.endOfWORDForward(startingAt: 73)
        
        XCTAssertEqual(endOfWORDForwardLocation, 77)
    }
    
    func test_that_it_skips_lines_that_are_just_made_of_whitespaces() {
        let text = """
let nextIndex = text.index(after: index)
               
if text[index].isCharacterThatConstitutesAVimWord() {
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWORDForwardLocation = fileText.endOfWORDForward(startingAt: 39)
        
        XCTAssertEqual(endOfWORDForwardLocation, 58)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FT_endOfWORDForward__Tests {
    
    func test_that_it_goes_to_the_end_of_a_WORD_made_of_emojis() {
        let text = "emojis are symbols theEat 🔫️🔫️pistol🔫️ are longer than 1 length"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWORDForwardLocation = fileText.endOfWORDForward(startingAt: 24)
        
        XCTAssertEqual(endOfWORDForwardLocation, 38)                
    }
    
    func test_that_it_can_pass_the_end_of_a_WORD_made_of_emojis() {
        let text = "emojis are symbols theEat 🔫️🔫️pistol🔫️ are longer than 1 length"

        let fileText = FileText(end: text.utf16.count, value: text)
        let endOfWORDForwardLocation = fileText.endOfWORDForward(startingAt: 38)
        
        XCTAssertEqual(endOfWORDForwardLocation, 44)                
    }
    
}
