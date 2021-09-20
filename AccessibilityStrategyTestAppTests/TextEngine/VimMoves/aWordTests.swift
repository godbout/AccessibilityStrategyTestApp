@testable import AccessibilityStrategy
import XCTest


class aWordTests: TextEngineBaseTests {}


extension aWordTests {
    
    func test_that_if_the_text_is_empty_it_returns_a_range_of_0_to_0() {
        let text = ""
        
        let wordRange = textEngine.aWord(startingAt: 0, in: text)
        
        XCTAssertEqual(wordRange.lowerBound, 0)
        XCTAssertEqual(wordRange.upperBound, 0)
    }
    
    func test_that_it_finds_a_single_word_by_itself() {
        let text = "aWord"
        
        let wordRange = textEngine.aWord(startingAt: 3, in: text)
        
        XCTAssertEqual(wordRange.lowerBound, 0)
        XCTAssertEqual(wordRange.upperBound, 4)
    }
    
    func test_that_it_returns_the_correct_range_if_the_last_character_of_the_text_is_the_beginning_of_a_new_word() {
        let text = "aWord("
        
        let wordRange = textEngine.aWord(startingAt: 3, in: text)
        
        XCTAssertEqual(wordRange.lowerBound, 0)
        XCTAssertEqual(wordRange.upperBound, 4)
    }
    
    func test_that_if_there_are_trailing_spaces_before_the_beginning_of_the_word_forward_then_it_includes_them_and_does_not_include_the_leading_spaces() {
        let text = "this is aWord   can you believe it?"
        
        let wordRange = textEngine.aWord(startingAt: 11, in: text)
        
        XCTAssertEqual(wordRange.lowerBound, 8)
        XCTAssertEqual(wordRange.upperBound, 15)
    }
    
    func test_that_if_there_are_no_trailing_spaces_before_the_beginning_of_the_word_forward_then_it_includes_the_leading_spaces() {
        let text = "this is     aWord(😂️y darling)"
        
        let wordRange = textEngine.aWord(startingAt: 14, in: text)
        
        XCTAssertEqual(wordRange.lowerBound, 7)
        XCTAssertEqual(wordRange.upperBound, 16)
    }
    
    func test_that_if_the_caret_location_is_on_a_space_it_gets_from_the_beginning_of_those_spaces_until_the_end_of_the_word_forward() {
        let text = "     aWord"
        
        let wordRange = textEngine.aWord(startingAt: 2, in: text)
        
        XCTAssertEqual(wordRange.lowerBound, 0)
        XCTAssertEqual(wordRange.upperBound, 9)
    }
    
    func test_that_if_the_caret_location_is_on_a_space_between_two_words_it_gets_the_spaces_between_the_two_words_and_the_second_word_and_nothing_else() {
        let text = "trying    some a shit"
        
        let wordRange = textEngine.aWord(startingAt: 8, in: text)
        
        XCTAssertEqual(wordRange.lowerBound, 6)
        XCTAssertEqual(wordRange.upperBound, 13)
    }
    
    func test_that_if_the_caret_location_is_at_the_first_character_of_a_word_that_is_followed_by_a_space_it_returns_from_that_first_character_to_the_word_after_the_following_space() {
        let text = "trying some a shit"
        
        let wordRange = textEngine.aWord(startingAt: 7, in: text)
        
        XCTAssertEqual(wordRange.lowerBound, 7)
        XCTAssertEqual(wordRange.upperBound, 11)
    }
    
    func test_that_if_the_text_ends_with_a_word_followed_by_only_one_whitespace_it_returns_from_the_beginning_of_the_word_to_that_whitespace() {
        let text = """
trying some
other   shit 
""" 
        let wordRange = textEngine.aWord(startingAt: 22, in: text)
        
        XCTAssertEqual(wordRange.lowerBound, 20)
        XCTAssertEqual(wordRange.upperBound, 24)
    }
    
    func test_that_it_stops_at_linefeeds_going_backward() {
        let text = """
it should not
go
to another line
"""
        let wordRange = textEngine.aWord(startingAt: 14, in: text)
        
        XCTAssertEqual(wordRange.lowerBound, 14)
        XCTAssertEqual(wordRange.upperBound, 16)
    }
    
    func test_that_it_stops_at_linefeeds_going_forward() {
        let text = """
it should not
go to another
line
"""
        let wordRange = textEngine.aWord(startingAt: 11, in: text)
        
        XCTAssertEqual(wordRange.lowerBound, 9)
        XCTAssertEqual(wordRange.upperBound, 12)
    }
       
    func test_that_a_line_ends_with_multiple_spaces_it_does_not_select_the_next_line_but_also_it_does_not_select_the_spaces_before_the_word_where_the_caret_is() {
        let text = """
need to deal with    
those faces 🥺️☹️😂️
"""
        let wordRange = textEngine.aWord(startingAt: 15, in: text)
        
        XCTAssertEqual(wordRange.lowerBound, 13)
        XCTAssertEqual(wordRange.upperBound, 20)
    }
    
    
    
    func test_that_it_knows_how_to_handle_ugly_emojis() {
        let text = """
need to deal with
those faces 🥺️☹️😂️
"""
        let wordRange = textEngine.aWord(startingAt: 25, in: text)
        
        XCTAssertEqual(wordRange.lowerBound, 24)
        XCTAssertEqual(wordRange.upperBound, 29)
    }
    
}
