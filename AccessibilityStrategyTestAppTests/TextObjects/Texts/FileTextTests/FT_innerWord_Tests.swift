@testable import AccessibilityStrategy
import XCTest


// here we don't need much tests for what is a Vim word
// as this is already tested in other FileText funcs.
// innerWord is using beginningOfWordBackward and endOfCurrentWord
// for its calculation (which are already tested), except for whitespaces
// which is why it's more important to have the whitespaces tested here
class FT_innerWordTests_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Range<Int> {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.innerWord(startingAt: caretLocation)
    }
    
}


// TextFields and TextViews
extension FT_innerWordTests_Tests {
    
    func test_that_if_the_text_is_empty_it_returns_a_range_of_0_to_0() {
        let text = ""
        
        let wordRange = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(wordRange.lowerBound, 0)
        XCTAssertEqual(wordRange.count, 0)
    }
    
    func test_that_if_the_text_is_a_single_word_it_grabs_from_the_beginning_to_the_end_of_the_word() {
        let text = "salut"

        let wordRange = applyFuncBeingTested(on: text, startingAt: 0)

        XCTAssertEqual(wordRange.lowerBound, 0)
        XCTAssertEqual(wordRange.count, 5)
    }
    
    func test_that_if_the_caret_is_on_a_letter_if_finds_the_correct_inner_word() {
        let text = "ok we're gonna-try to get the inner word here"
        
        let wordRange = applyFuncBeingTested(on: text, startingAt: 10)

        XCTAssertEqual(wordRange.lowerBound, 9)
        XCTAssertEqual(wordRange.count, 5) 
    }
    
    func test_that_if_the_caret_is_on_a_space_the_inner_word_is_all_the_consecutive_spaces() {
        let text = "ok so now we have a lot of     --spaces"
        
        let wordRange = applyFuncBeingTested(on: text, startingAt: 28)

        XCTAssertEqual(wordRange.lowerBound, 26)
        XCTAssertEqual(wordRange.count, 5)         
    }
    
    func test_that_if_the_caret_is_on_a_single_space_it_recognizes_it_as_an_inner_word() {
        let text = "a single space is an-- ^^inner word"
        
        let wordRange = applyFuncBeingTested(on: text, startingAt: 22)

        XCTAssertEqual(wordRange.lowerBound, 22)
        XCTAssertEqual(wordRange.count, 1) 
    }
    
    func test_that_if_the_TextField_starts_with_spaces_it_finds_the_correct_inner_word() {
        let text = "     **that's lots of spaces"
        
        let wordRange = applyFuncBeingTested(on: text, startingAt: 4)

        XCTAssertEqual(wordRange.lowerBound, 0)
        XCTAssertEqual(wordRange.count, 5) 
    }
    
    func test_that_if_the_TextField_ends_with_spaces_it_still_gets_the_correct_inner_word() {
        let text = "that's lots of spaces again**       "
        
        let wordRange = applyFuncBeingTested(on: text, startingAt: 31)

        XCTAssertEqual(wordRange.lowerBound, 29)
        XCTAssertEqual(wordRange.count, 7) 
    }
    
    func test_that_if_the_text_is_a_single_character_it_grabs_from_the_beginning_to_the_end_of_the_word() {
        let text = "a"

        let wordRange = applyFuncBeingTested(on: text, startingAt: 0)

        XCTAssertEqual(wordRange.lowerBound, 0)
        XCTAssertEqual(wordRange.count, 1)
    }
       
    func test_that_if_the_text_starts_with_a_single_character_and_the_caretLocation_is_on_this_character_then_it_finds_the_correct_innerWord() {
        let text = "a word"

        let wordRange = applyFuncBeingTested(on: text, startingAt: 0)

        XCTAssertEqual(wordRange.lowerBound, 0)
        XCTAssertEqual(wordRange.count, 1)
    }
        
    func test_that_if_the_last_word_of_a_text_is_a_single_character_it_grabs_the_correct_innerWord() {
        let text = "a-"

        let wordRange = applyFuncBeingTested(on: text, startingAt: 0)

        XCTAssertEqual(wordRange.lowerBound, 0)
        XCTAssertEqual(wordRange.count, 1)
    }
    
    func test_that_if_the_caret_is_on_a_single_punction_it_grabs_the_correct_innerWord() {
        let text = "many new.bugs :("
        
        let wordRange = applyFuncBeingTested(on: text, startingAt: 8)

        XCTAssertEqual(wordRange.lowerBound, 8)
        XCTAssertEqual(wordRange.count, 1)
    }
    
    func test_that_if_the_text_starts_with_a_innerWord_made_of_a_single_character_followed_by_space_if_the_caret_is_on_the_space_then_it_grabs_the_correct_innerWord() {
        let text = "a bug more"
        
        let wordRange = applyFuncBeingTested(on: text, startingAt: 1)

        XCTAssertEqual(wordRange.lowerBound, 1)
        XCTAssertEqual(wordRange.count, 1)
    }

}


// TextViews
extension FT_innerWordTests_Tests {
    
    func test_that_inner_word_stops_at_Newlines_at_the_end_of_lines() {
        let text = """
this shouldn't
spill      
   on the next line--
"""
        
        let wordRange = applyFuncBeingTested(on: text, startingAt: 23)

        XCTAssertEqual(wordRange.lowerBound, 20)
        XCTAssertEqual(wordRange.count, 6)
    }
    
    func test_that_inner_word_stops_at_Newlines_at_the_beginning_of_lines() {
        let text = """
this shouldn't
spill also    
    backwards
"""
        
        let wordRange = applyFuncBeingTested(on: text, startingAt: 33)

        XCTAssertEqual(wordRange.lowerBound, 30)
        XCTAssertEqual(wordRange.count, 4)
    }
    
    func test_that_innerWord_stops_at_Newlines_both_at_beginning_and_end_of_lines_that_is_on_EmptyLines() {
        let text = """
this shouldn't

    backwards
"""
        
        let wordRange = applyFuncBeingTested(on: text, startingAt: 15)

        XCTAssertEqual(wordRange.lowerBound, 15)
        XCTAssertEqual(wordRange.count, 0)
    }
    
}


// emojis
// emojis are symbols so as long as we take care of the emojis length, all the rest
// works exactly like symbols: passing, skipping, part or not of words, etc...
// so no need to test those parts again.
extension FT_innerWordTests_Tests {
    
    func test_that_it_handles_emojis() {
        let text = "emojis are symbols that 🔫️🔫️🔫️*** are longer than 1 length"
        
        let wordRange = applyFuncBeingTested(on: text, startingAt: 27)

        XCTAssertEqual(wordRange.lowerBound, 24)
        XCTAssertEqual(wordRange.count, 9)                
    }
    
    func test_that_it_does_not_do_shit_with_emojis_before_a_space() {
        let text = "emojis are symbols that ***🔫️🔫️🔫️ are longer than 1 length"
        
        let wordRange = applyFuncBeingTested(on: text, startingAt: 36)

        XCTAssertEqual(wordRange.lowerBound, 36)
        XCTAssertEqual(wordRange.count, 1)                
    }
    
}
