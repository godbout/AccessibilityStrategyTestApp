@testable import AccessibilityStrategy
import XCTest

// aWord moves seem to be separated in two ways:
// 1. when caretLocation is on a whitespace (ignore forward linefeed, for example)
// 2. when caretLocation is on a non whitespace (doesn't ignore forward linefeed, for example)
// so we gonna separate the tests like this.
class FT_aWord_Tests: XCTestCase {}


// caretLocation on whitespace
extension FT_aWord_Tests {

    func test_that_if_the_text_is_only_whitespaces_it_returns_nil() {
        let text = "               "

        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.aWord(startingAt: 7)
        
        XCTAssertNil(wordRange)
    }
    
    func test_that_if_there_is_a_word_after_whitespaces_it_goes_until_the_end_of_that_word() {
        let text = "        aWord-and another"

        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.aWord(startingAt: 2)
        
        XCTAssertEqual(wordRange?.lowerBound, 0)
        XCTAssertEqual(wordRange?.count, 13)
    }
    
    func test_that_if_there_are_spaces_between_two_words_it_goes_from_the_end_of_the_word_backward_till_the_end_of_the_word_forward() {
        let text = "  aWord        aWord-and another"

        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.aWord(startingAt: 10)
        
        XCTAssertEqual(wordRange?.lowerBound, 7)
        XCTAssertEqual(wordRange?.count, 13)
    }
    
    func test_that_it_does_not_stop_at_linefeeds_going_forward() {
        let text = """
there's 5 spaces at the end of this line     
   careful-that Xcode doesn't delete them
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.aWord(startingAt: 42)
        
        XCTAssertEqual(wordRange?.lowerBound, 40)
        XCTAssertEqual(wordRange?.count, 16)
    }
    
    func test_that_it_does_stop_at_linefeeds_going_backward() {
        let text = """
there's 5 spaces at the end of this line     
   careful-that Xcode doesn't delete them
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.aWord(startingAt: 48)
        
        XCTAssertEqual(wordRange?.lowerBound, 46)
        XCTAssertEqual(wordRange?.count, 10)
    }

}


// caretLocation not on whitespace (linefeed is not a whitespace for Vim)
extension FT_aWord_Tests {

    func test_that_if_the_text_is_empty_it_returns_nil() {
        let text = ""

        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.aWord(startingAt: 0)

        XCTAssertNil(wordRange)
    }
    
    func test_that_if_the_caret_is_at_the_last_empty_line_it_returns_nil() {
        let text = """
that's gonna be a text where
the last line is empty

"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.aWord(startingAt: 52)

        XCTAssertNil(wordRange)
    }
        
    func test_that_if_there_are_no_trailing_spaces_and_no_leading_spaces_it_grabs_from_the_beginning_to_the_end_of_the_word() {
        let text = "aWord-hehe"

        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.aWord(startingAt: 3)

        XCTAssertEqual(wordRange?.lowerBound, 0)
        XCTAssertEqual(wordRange?.count, 5)
    }
    
    func test_that_if_there_are_trailing_spaces_until_the_beginning_of_a_word_forward_it_grabs_them_and_therefore_does_not_grab_leading_spaces() {
        let text = "this is-aWord   can you believe it?"

        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.aWord(startingAt: 11)

        XCTAssertEqual(wordRange?.lowerBound, 8)
        XCTAssertEqual(wordRange?.count, 8)
    }
    
    func test_that_if_there_are_trailing_spaces_until_the_end_of_the_text_it_grabs_them_and_therefore_does_not_grab_leading_spaces() {
        let text = "this is something       "

        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.aWord(startingAt: 13)

        XCTAssertEqual(wordRange?.lowerBound, 8)
        XCTAssertEqual(wordRange?.count, 16)
    }
    
    func test_that_it_grabs_the_trailing_spaces_until_the_end_of_the_text_if_there_is_no_word_forward() {
        let text = "a-Word      "

        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.aWord(startingAt: 3)

        XCTAssertEqual(wordRange?.lowerBound, 2)
        XCTAssertEqual(wordRange?.count, 10)
    }
    
    func test_that_if_there_are_no_trailing_spaces_until_the_beginning_of_a_word_forward_then_it_grabs_until_the_end_of_the_word_backward() {
        let text = "some     aWord(and another"

        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.aWord(startingAt: 12)

        XCTAssertEqual(wordRange?.lowerBound, 4)
        XCTAssertEqual(wordRange?.count, 10)
    }
    
    func test_that_if_there_are_no_trailing_spaces_until_the_beginning_of_a_word_forward_but_also_no_word_backward_then_it_grabs_from_the_beginning_of_the_current_word() {
        let text = "     aWord(and another"

        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.aWord(startingAt: 7)

        XCTAssertEqual(wordRange?.lowerBound, 5)
        XCTAssertEqual(wordRange?.count, 5)
    }
    
    func test_that_if_there_are_no_trailing_spaces_because_there_is_no_word_forward_but_also_no_word_backward_then_it_grabs_from_the_beginning_of_the_current_word() {
        let text = "           aWord"

        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.aWord(startingAt: 14)

        XCTAssertEqual(wordRange?.lowerBound, 11)
        XCTAssertEqual(wordRange?.count, 5)
    }
    
    func test_that_if_there_are_no_trailing_spaces_because_there_is_no_word_forward_but_there_is_a_word_backward_then_it_grabs_from_the_end_of_word_backward_until_the_end_of_the_current_word() {
        let text = "  hello         aWord"

        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.aWord(startingAt: 20)

        XCTAssertEqual(wordRange?.lowerBound, 7)
        XCTAssertEqual(wordRange?.count, 14)
    }
    
    func test_that_it_stops_at_linefeeds_when_looking_for_the_word_forward() {
        let text = """
this line ends with 3-spaces   
  and this line should be kept intact
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.aWord(startingAt: 25)

        XCTAssertEqual(wordRange?.lowerBound, 22)
        XCTAssertEqual(wordRange?.count, 9)
    }
    
    func test_that_if_there_are_no_trailing_spaces_until_the_word_forward_it_stops_at_the_beginning_of_the_current_word_when_looking_for_the_word_backward() {
        let text = """
this line ends with 3 spaces   
  and(this line should be kept intact
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.aWord(startingAt: 36)

        XCTAssertEqual(wordRange?.lowerBound, 34)
        XCTAssertEqual(wordRange?.count, 3)
    }
    
    func test_that_if_there_are_no_trailing_spaces_because_there_is_no_word_forward_then_it_stops_at_the_beginning_of_the_current_word_when_looking_for_the_word_backward() {
        let text = """
this line ends with 3 spaces   
  and
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.aWord(startingAt: 34)

        XCTAssertEqual(wordRange?.lowerBound, 34)
        XCTAssertEqual(wordRange?.count, 3)
    }
    
    // this test contains blanks
    func test_that_if_it_is_on_a_Linefeed_it_does_not_delete_too_much() {
        let text = """
this line ends with 3 spaces   

  and   this is something
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.aWord(startingAt: 32)

        XCTAssertEqual(wordRange?.lowerBound, 32)
        XCTAssertEqual(wordRange?.count, 6)
    }
    
    func test_that_it_knows_how_to_handle_ugly_emojis() {
        let text = """
need to deal with
those faces 🥺️☹️😂️ fart
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.aWord(startingAt: 33)

        XCTAssertEqual(wordRange?.lowerBound, 30)
        XCTAssertEqual(wordRange?.count, 9)
    }
    
}
