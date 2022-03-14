@testable import AccessibilityStrategy
import XCTest

// see aWord for blah blah
class FT_aWORD__Tests: XCTestCase {}


// caretLocation on whitespace
extension FT_aWORD__Tests {

    func test_that_if_the_text_is_only_whitespaces_it_returns_nil() {
        let text = "               "

        let fileText = FileText(end: text.utf16.count, value: text)
        let WORDRange = fileText.aWORD(startingAt: 7)
        
        XCTAssertNil(WORDRange)
    }
    
    func test_that_if_there_is_a_WORD_after_whitespaces_it_goes_until_the_end_of_that_WORD() {
        let text = "        aWord-and another"

        let fileText = FileText(end: text.utf16.count, value: text)
        let WORDRange = fileText.aWORD(startingAt: 2)
        
        XCTAssertEqual(WORDRange?.lowerBound, 0)
        XCTAssertEqual(WORDRange?.count, 17)
    }
    
    func test_that_if_there_are_spaces_between_two_WORDS_it_goes_from_the_end_of_the_WORD_backward_till_the_end_of_the_WORD_forward() {
        let text = "  aWord        aWord-and another"

        let fileText = FileText(end: text.utf16.count, value: text)
        let WORDRange = fileText.aWORD(startingAt: 10)
        
        XCTAssertEqual(WORDRange?.lowerBound, 7)
        XCTAssertEqual(WORDRange?.count, 17)
    }
    
    func test_that_it_does_not_stop_at_linefeeds_going_forward() {
        let text = """
there's 5 spaces at the end of this line     
   careful-that Xcode doesn't delete them
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let WORDRange = fileText.aWORD(startingAt: 42)
        
        XCTAssertEqual(WORDRange?.lowerBound, 40)
        XCTAssertEqual(WORDRange?.count, 21)
    }
    
    func test_that_it_does_stop_at_linefeeds_going_backward() {
        let text = """
there's 5 spaces at the end of this line     
   careful-that Xcode doesn't delete them
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let WORDRange = fileText.aWORD(startingAt: 48)
        
        XCTAssertEqual(WORDRange?.lowerBound, 46)
        XCTAssertEqual(WORDRange?.count, 15)
    }

}


// caretLocation not on whitespace (in Vim Linefeed is not a whitespace :()
extension FT_aWORD__Tests {

    func test_that_if_the_text_is_empty_it_returns_nil() {
        let text = ""

        let fileText = FileText(end: text.utf16.count, value: text)
        let WORDRange = fileText.aWORD(startingAt: 0)

        XCTAssertNil(WORDRange)
    }
    
    func test_that_if_the_caret_is_at_the_last_empty_line_it_returns_nil() {
        let text = """
that's gonna be a text where
the last line is empty

"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let WORDRange = fileText.aWORD(startingAt: 52)

        XCTAssertNil(WORDRange)
    }
        
    func test_that_if_there_are_no_trailing_spaces_and_no_leading_spaces_it_grabs_from_the_beginning_to_the_end_of_the_WORD() {
        let text = "aWord-hehe"

        let fileText = FileText(end: text.utf16.count, value: text)
        let WORDRange = fileText.aWORD(startingAt: 3)

        XCTAssertEqual(WORDRange?.lowerBound, 0)
        XCTAssertEqual(WORDRange?.count, 10)
    }
    
    func test_that_if_there_are_trailing_spaces_until_the_beginning_of_a_WORD_forward_it_grabs_them_and_therefore_does_not_grab_leading_spaces() {
        let text = "this is-aWord   can you believe it?"

        let fileText = FileText(end: text.utf16.count, value: text)
        let WORDRange = fileText.aWORD(startingAt: 11)

        XCTAssertEqual(WORDRange?.lowerBound, 5)
        XCTAssertEqual(WORDRange?.count, 11)
    }
    
    func test_that_if_there_are_trailing_spaces_until_the_end_of_the_text_it_grabs_them_and_therefore_does_not_grab_leading_spaces() {
        let text = "this is-something       "

        let fileText = FileText(end: text.utf16.count, value: text)
        let WORDRange = fileText.aWORD(startingAt: 13)

        XCTAssertEqual(WORDRange?.lowerBound, 5)
        XCTAssertEqual(WORDRange?.count, 19)
    }
    
    func test_that_it_grabs_the_trailing_spaces_until_the_end_of_the_text_if_there_is_no_WORD_forward() {
        let text = "a-Word      "

        let fileText = FileText(end: text.utf16.count, value: text)
        let WORDRange = fileText.aWORD(startingAt: 3)

        XCTAssertEqual(WORDRange?.lowerBound, 0)
        XCTAssertEqual(WORDRange?.count, 12)
    }
    
    func test_that_if_there_are_no_trailing_spaces_until_the_beginning_of_a_WORD_forward_then_it_grabs_until_the_end_of_the_WORD_backward() {
        let text = "some     aWORD(and-another"

        let fileText = FileText(end: text.utf16.count, value: text)
        let WORDRange = fileText.aWORD(startingAt: 12)

        XCTAssertEqual(WORDRange?.lowerBound, 4)
        XCTAssertEqual(WORDRange?.count, 22)
    }
    
    func test_that_if_there_are_no_trailing_spaces_because_there_is_no_WORD_forward_but_also_no_WORD_backward_then_it_grabs_from_the_beginning_of_the_current_WORD() {
        let text = "           a-Word"

        let fileText = FileText(end: text.utf16.count, value: text)
        let WORDRange = fileText.aWORD(startingAt: 14)

        XCTAssertEqual(WORDRange?.lowerBound, 11)
        XCTAssertEqual(WORDRange?.count, 6)
    }
    
    func test_that_if_there_are_no_trailing_spaces_because_there_is_no_WORD_forward_but_there_is_a_WORD_backward_then_it_grabs_from_the_end_of_WORD_backward_until_the_end_of_the_current_WORD() {
        let text = "  hello         a-Word"

        let fileText = FileText(end: text.utf16.count, value: text)
        let WORDRange = fileText.aWORD(startingAt: 20)

        XCTAssertEqual(WORDRange?.lowerBound, 7)
        XCTAssertEqual(WORDRange?.count, 15)
    }
    
    func test_that_it_stops_at_linefeeds_when_looking_for_the_WORD_forward() {
        let text = """
this line ends with 3-spaces   
  and this line should be kept intact
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let WORDRange = fileText.aWORD(startingAt: 25)

        XCTAssertEqual(WORDRange?.lowerBound, 20)
        XCTAssertEqual(WORDRange?.count, 11)
    }
    
    func test_that_if_there_are_no_trailing_spaces_until_the_WORD_forward_it_stops_at_linefeeds_when_looking_for_the_WORD_backward() {
        let text = """
this line ends with 3 spaces   
  and(this-line-should-be-kept-intact
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let WORDRange = fileText.aWORD(startingAt: 36)

        XCTAssertEqual(WORDRange?.lowerBound, 34)
        XCTAssertEqual(WORDRange?.count, 35)
    }
    
    func test_that_if_there_are_no_trailing_spaces_because_there_is_no_WORD_forward_and_the_previous_non_blank_before_the_WORD_is_a_linefeed_then_it_stops_at_the_beginning_of_the_current_WORD() {
        let text = """
this line ends with 3 spaces   
  and
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let WORDRange = fileText.aWORD(startingAt: 34)

        XCTAssertEqual(WORDRange?.lowerBound, 34)
        XCTAssertEqual(WORDRange?.count, 3)
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
those faces 🥺️☹️-😂️ fart
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let WORDRange = fileText.aWORD(startingAt: 33)

        XCTAssertEqual(WORDRange?.lowerBound, 30)
        XCTAssertEqual(WORDRange?.count, 10)
    }
    
}
