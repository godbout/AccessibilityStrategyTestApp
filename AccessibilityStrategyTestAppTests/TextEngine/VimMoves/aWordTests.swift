@testable import AccessibilityStrategy
import XCTest


// aWord moves seem to be separated in two ways:
// 1. when caretLocation is on a whitespace (ignore forward linefeed, for example)
// 2. when caretLocation is on a non whitespace (doesn't ignore forward linefeed, for example)
// so we gonna separate the tests like this.
class aWordTests: TextEngineBaseTests {}


// caretLocation on whitespace
extension aWordTests {

    func test_that_if_the_text_is_only_whitespaces_it_returns_nil() {
        let text = "               "
        
        let wordRange = textEngine.aWord(startingAt: 7, in: text)
        
        XCTAssertNil(wordRange)
    }
    
    func test_that_if_there_is_a_word_after_whitespaces_it_goes_until_the_end_of_that_word() {
        let text = "        aWord and another"

        let wordRange = textEngine.aWord(startingAt: 2, in: text)
        
        XCTAssertEqual(wordRange?.lowerBound, 0)
        XCTAssertEqual(wordRange?.upperBound, 12)
    }
    
    func test_that_if_there_are_spaces_between_two_words_it_goes_from_the_end_of_the_word_backward_till_the_end_of_the_word_forward() {
        let text = "  aWord        aWord and another"

        let wordRange = textEngine.aWord(startingAt: 10, in: text)
        
        XCTAssertEqual(wordRange?.lowerBound, 7)
        XCTAssertEqual(wordRange?.upperBound, 19)
    }
    
    func test_that_it_does_not_stop_at_linefeeds_going_forward() {
        let text = """
there's 5 spaces at the end of this line     
   careful that Xcode doesn't delete them
"""

        let wordRange = textEngine.aWord(startingAt: 42, in: text)
        
        XCTAssertEqual(wordRange?.lowerBound, 40)
        XCTAssertEqual(wordRange?.upperBound, 55)
    }
    
    func test_that_it_does_not_stop_at_linefeeds_going_backward() {
        let text = """
there's 5 spaces at the end of this line     
   careful that Xcode doesn't delete them
"""

        let wordRange = textEngine.aWord(startingAt: 48, in: text)
        
        XCTAssertEqual(wordRange?.lowerBound, 46)
        XCTAssertEqual(wordRange?.upperBound, 55)
    }

}


// caretLocation not on whitespace
extension aWordTests {

    func test_that_if_the_text_is_empty_it_returns_nil() {
        let text = ""

        let wordRange = textEngine.aWord(startingAt: 0, in: text)

        XCTAssertNil(wordRange)
    }
    
    func test_that_if_there_are_no_trailing_spaces_and_no_leading_spaces_it_grabs_from_the_beginning_to_the_end_of_the_word() {
        let text = "aWord"
        
        let wordRange = textEngine.aWord(startingAt: 3, in: text)

        XCTAssertEqual(wordRange?.lowerBound, 0)
        XCTAssertEqual(wordRange?.upperBound, 4)
    }
    
    func test_that_if_there_are_trailing_spaces_until_the_beginning_of_a_word_forward_it_grabs_them_and_does_not_grab_leading_spaces() {
        let text = "this is aWord   can you believe it?"

        let wordRange = textEngine.aWord(startingAt: 11, in: text)

        XCTAssertEqual(wordRange?.lowerBound, 8)
        XCTAssertEqual(wordRange?.upperBound, 15)
    }
    
    func test_that_it_grabs_the_trailing_spaces_until_the_end_of_the_text_if_there_is_no_word_forward() {
        let text = "aWord      "

        let wordRange = textEngine.aWord(startingAt: 3, in: text)

        XCTAssertEqual(wordRange?.lowerBound, 0)
        XCTAssertEqual(wordRange?.upperBound, 10)
    }
    
    func test_that_if_there_are_no_trailing_spaces_until_the_beginning_of_a_word_forward_then_it_grabs_until_the_end_of_the_word_backward() {
        let text = "some     aWord(and another"

        let wordRange = textEngine.aWord(startingAt: 12, in: text)

        XCTAssertEqual(wordRange?.lowerBound, 4)
        XCTAssertEqual(wordRange?.upperBound, 13)
    }
    
    func test_that_if_there_are_no_trailing_spaces_until_the_beginning_of_a_word_forward_but_also_no_word_backward_then_it_grabs_from_the_beginning_of_the_current_word() {
        let text = "     aWord(and another"

        let wordRange = textEngine.aWord(startingAt: 7, in: text)

        XCTAssertEqual(wordRange?.lowerBound, 5)
        XCTAssertEqual(wordRange?.upperBound, 9)
    }
    
    func test_that_it_stops_at_linefeeds_when_looking_for_the_word_forward() {
        let text = """
this line ends with 3 spaces   
  and this line should be kept intact
"""
        let wordRange = textEngine.aWord(startingAt: 25, in: text)

        XCTAssertEqual(wordRange?.lowerBound, 22)
        XCTAssertEqual(wordRange?.upperBound, 30)
    }
    
    func test_that_it_stops_at_linefeeds_when_looking_for_the_word_backward() {
        let text = """
this line ends with 3 spaces   
  and this line should be kept intact
"""
        let wordRange = textEngine.aWord(startingAt: 25, in: text)

        XCTAssertEqual(wordRange?.lowerBound, 22)
        XCTAssertEqual(wordRange?.upperBound, 30)
    }
    

    
    
 
    
    
    
    
    

    




    func test_that_it_stops_at_linefeeds_going_backward() {
        let text = """
it should not
go
to another line
"""
        let wordRange = textEngine.aWord(startingAt: 14, in: text)

        XCTAssertEqual(wordRange?.lowerBound, 14)
        XCTAssertEqual(wordRange?.upperBound, 16)
    }


//
//    func test_that_a_line_ends_with_multiple_spaces_it_does_not_select_the_next_line_but_also_it_does_not_select_the_spaces_before_the_word_where_the_caret_is() {
//        let text = """
//need to deal with
//those faces 🥺️☹️😂️
//"""
//        let wordRange = textEngine.aWord(startingAt: 15, in: text)
//
//        XCTAssertEqual(wordRange?.lowerBound, 13)
//        XCTAssertEqual(wordRange?.upperBound, 20)
//    }
//
//
//
//    func test_that_it_knows_how_to_handle_ugly_emojis() {
//        let text = """
//need to deal with
//those faces 🥺️☹️😂️
//"""
//        let wordRange = textEngine.aWord(startingAt: 25, in: text)
//
//        XCTAssertEqual(wordRange?.lowerBound, 24)
//        XCTAssertEqual(wordRange?.upperBound, 29)
//    }

}
