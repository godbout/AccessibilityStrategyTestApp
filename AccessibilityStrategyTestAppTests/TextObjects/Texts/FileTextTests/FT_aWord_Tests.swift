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
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 15,
            caretLocation: 7,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 15,
                number: 1,
                start: 0,
                end: 15
            )
        )
        
        let wordRange = element.fileText.aWord(startingAt: 7)
        
        XCTAssertNil(wordRange)
    }
    
    func test_that_if_there_is_a_word_after_whitespaces_it_goes_until_the_end_of_that_word() {
        let text = "        aWord and another"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 25,
            caretLocation: 2,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 25,
                number: 1,
                start: 0,
                end: 25
            )
        )

        let wordRange = element.fileText.aWord(startingAt: 2)
        
        XCTAssertEqual(wordRange?.lowerBound, 0)
        XCTAssertEqual(wordRange?.upperBound, 12)
    }
    
    func test_that_if_there_are_spaces_between_two_words_it_goes_from_the_end_of_the_word_backward_till_the_end_of_the_word_forward() {
        let text = "  aWord        aWord and another"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 32,
            caretLocation: 10,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 32,
                number: 1,
                start: 0,
                end: 15
            )
        )

        let wordRange = element.fileText.aWord(startingAt: 10)
        
        XCTAssertEqual(wordRange?.lowerBound, 7)
        XCTAssertEqual(wordRange?.upperBound, 19)
    }
    
    func test_that_it_does_not_stop_at_linefeeds_going_forward() {
        let text = """
there's 5 spaces at the end of this line     
   careful that Xcode doesn't delete them
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 86,
            caretLocation: 42,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 86,
                number: 4,
                start: 31,
                end: 45
            )
        )

        let wordRange = element.fileText.aWord(startingAt: 42)
        
        XCTAssertEqual(wordRange?.lowerBound, 40)
        XCTAssertEqual(wordRange?.upperBound, 55)
    }
    
    func test_that_it_does_not_stop_at_linefeeds_going_backward() {
        let text = """
there's 5 spaces at the end of this line     
   careful that Xcode doesn't delete them
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 87,
            caretLocation: 48,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 87,
                number: 5,
                start: 46,
                end: 57
            )
        )

        let wordRange = element.fileText.aWord(startingAt: 48)
        
        XCTAssertEqual(wordRange?.lowerBound, 46)
        XCTAssertEqual(wordRange?.upperBound, 55)
    }

}


// caretLocation not on whitespace
extension FT_aWord_Tests {

    func test_that_if_the_text_is_empty_it_returns_nil() {
        let text = ""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 0,
            caretLocation: 0,
            selectedLength: 0,
            selectedText: "",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 0,
                number: 1,
                start: 0,
                end: 0
            )
        )

        let wordRange = element.fileText.aWord(startingAt: 0)

        XCTAssertNil(wordRange)
    }
    
    func test_that_if_the_caret_is_at_the_last_empty_line_it_returns_nil() {
        let text = """
that's gonna be a text where
the last line is empty

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 52,
            caretLocation: 52,
            selectedLength: 0,
            selectedText: "",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 52,
                number: 7,
                start: 52,
                end: 52
            )
        )
        
        let wordRange = element.fileText.aWord(startingAt: 52)

        XCTAssertNil(wordRange)
    }
        
    func test_that_if_there_are_no_trailing_spaces_and_no_leading_spaces_it_grabs_from_the_beginning_to_the_end_of_the_word() {
        let text = "aWord"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 5,
            caretLocation: 3,
            selectedLength: 1,
            selectedText: "r",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 5,
                number: 1,
                start: 0,
                end: 5
            )
        )
        
        let wordRange = element.fileText.aWord(startingAt: 3)

        XCTAssertEqual(wordRange?.lowerBound, 0)
        XCTAssertEqual(wordRange?.upperBound, 4)
    }
    
    func test_that_if_there_are_trailing_spaces_until_the_beginning_of_a_word_forward_it_grabs_them_and_therefore_does_not_grab_leading_spaces() {
        let text = "this is aWord   can you believe it?"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 35,
            caretLocation: 11,
            selectedLength: 1,
            selectedText: "r",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 2,
                start: 8,
                end: 20
            )
        )

        let wordRange = element.fileText.aWord(startingAt: 11)

        XCTAssertEqual(wordRange?.lowerBound, 8)
        XCTAssertEqual(wordRange?.upperBound, 15)
    }
    
    func test_that_if_there_are_trailing_spaces_until_the_end_of_the_text_it_grabs_them_and_therefore_does_not_grab_leading_spaces() {
        let text = "this is something       "
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 24,
            caretLocation: 13,
            selectedLength: 1,
            selectedText: "h",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 24,
                number: 2,
                start: 8,
                end: 24
            )
        )

        let wordRange = element.fileText.aWord(startingAt: 13)

        XCTAssertEqual(wordRange?.lowerBound, 8)
        XCTAssertEqual(wordRange?.upperBound, 23)
    }
    
    func test_that_it_grabs_the_trailing_spaces_until_the_end_of_the_text_if_there_is_no_word_forward() {
        let text = "aWord      "
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 11,
            caretLocation: 3,
            selectedLength: 1,
            selectedText: "r",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 11,
                number: 1,
                start: 0,
                end: 11
            )
        )

        let wordRange = element.fileText.aWord(startingAt: 3)

        XCTAssertEqual(wordRange?.lowerBound, 0)
        XCTAssertEqual(wordRange?.upperBound, 10)
    }
    
    func test_that_if_there_are_no_trailing_spaces_until_the_beginning_of_a_word_forward_then_it_until_the_end_of_the_word_backward() {
        let text = "some     aWord(and another"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 26,
            caretLocation: 12,
            selectedLength: 1,
            selectedText: "r",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 26,
                number: 2,
                start: 9,
                end: 19
            )
        )

        let wordRange = element.fileText.aWord(startingAt: 12)

        XCTAssertEqual(wordRange?.lowerBound, 4)
        XCTAssertEqual(wordRange?.upperBound, 13)
    }
    
    func test_that_if_there_are_no_trailing_spaces_until_the_beginning_of_a_word_forward_but_also_no_word_backward_then_it_grabs_from_the_beginning_of_the_current_word() {
        let text = "     aWord(and another"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 22,
            caretLocation: 7,
            selectedLength: 1,
            selectedText: "o",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 22,
                number: 2,
                start: 5,
                end: 15
            )
        )

        let wordRange = element.fileText.aWord(startingAt: 7)

        XCTAssertEqual(wordRange?.lowerBound, 5)
        XCTAssertEqual(wordRange?.upperBound, 9)
    }
    
    func test_that_if_there_are_no_trailing_spaces_because_there_is_no_word_forward_but_also_no_word_backward_then_it_grabs_from_the_beginning_of_the_current_word() {
        let text = "           aWord"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 16,
            caretLocation: 14,
            selectedLength: 1,
            selectedText: "r",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 16,
                number: 2,
                start: 11,
                end: 16
            )
        )

        let wordRange = element.fileText.aWord(startingAt: 14)

        XCTAssertEqual(wordRange?.lowerBound, 11)
        XCTAssertEqual(wordRange?.upperBound, 15)
    }
    
    func test_that_if_there_are_no_trailing_spaces_because_there_is_no_word_forward_but_there_is_a_word_backward_then_it_grabs_from_the_end_of_word_backward_until_the_end_of_the_current_word() {
        let text = "  hello         aWord"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 21,
            caretLocation: 20,
            selectedLength: 1,
            selectedText: "d",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 21,
                number: 2,
                start: 16,
                end: 21
            )
        )

        let wordRange = element.fileText.aWord(startingAt: 20)

        XCTAssertEqual(wordRange?.lowerBound, 7)
        XCTAssertEqual(wordRange?.upperBound, 20)
    }
    
    func test_that_it_stops_at_linefeeds_when_looking_for_the_word_forward() {
        let text = """
this line ends with 3 spaces   
  and this line should be kept intact
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 69,
            caretLocation: 25,
            selectedLength: 1,
            selectedText: "c",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 69,
                number: 3,
                start: 22,
                end: 32
            )
        )
                
        let wordRange = element.fileText.aWord(startingAt: 25)

        XCTAssertEqual(wordRange?.lowerBound, 22)
        XCTAssertEqual(wordRange?.upperBound, 30)
    }
    
    func test_that_if_there_are_no_trailing_spaces_until_the_word_forward_it_stops_at_linefeeds_when_looking_for_the_word_backward() {
        let text = """
this line ends with 3 spaces   
  and(this line should be kept intact
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 69,
            caretLocation: 36,
            selectedLength: 1,
            selectedText: "d",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 69,
                number: 4,
                start: 32,
                end: 43
            )
        )
        
        let wordRange = element.fileText.aWord(startingAt: 36)

        XCTAssertEqual(wordRange?.lowerBound, 32)
        XCTAssertEqual(wordRange?.upperBound, 36)
    }
    
    func test_that_if_there_are_no_trailing_spaces_because_there_is_no_word_forward_and_the_previous_non_blank_before_the_word_is_a_linefeed_then_it_stops_at_the_linefeed_when_looking_for_the_word_backward() {
        let text = """
this line ends with 3 spaces   
  and
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 37,
            caretLocation: 34,
            selectedLength: 1,
            selectedText: "a",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 37,
                number: 4,
                start: 32,
                end: 37
            )
        )

        let wordRange = element.fileText.aWord(startingAt: 34)

        XCTAssertEqual(wordRange?.lowerBound, 34)
        XCTAssertEqual(wordRange?.upperBound, 36)
    }

    func test_that_it_knows_how_to_handle_ugly_emojis() {
        let text = """
need to deal with
those faces 🥺️☹️😂️ fart
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 43,
            caretLocation: 33,
            selectedLength: 2,
            selectedText: "☹️",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 43,
                number: 4,
                start: 30,
                end: 43
            )
        )
                
        let wordRange = element.fileText.aWord(startingAt: 33)

        XCTAssertEqual(wordRange?.lowerBound, 30)
        XCTAssertEqual(wordRange?.upperBound, 38)
    }
    
}
