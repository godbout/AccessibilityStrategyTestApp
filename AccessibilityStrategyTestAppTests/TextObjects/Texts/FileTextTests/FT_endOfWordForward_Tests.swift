@testable import AccessibilityStrategy
import XCTest


class FT_endOfWordForward_Tests: XCTestCase {}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension FT_endOfWordForward_Tests {
    
    func test_that_if_the_text_is_empty_then_it_returns_nil() {
        let text = ""
        let element = AccessibilityTextElement(
            role: .textField,
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
        
        let endOfWordForwardLocation = element.fileText.endOfWordForward(startingAt: 0)
        
        XCTAssertNil(endOfWordForwardLocation)
    }
    
    func test_that_if_the_caret_is_after_the_last_character_on_an_empty_line_then_it_returns_nil() {
        let text = """
a couple of
lines but not
coke haha but
with linefeed

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 54,
            caretLocation: 54,
            selectedLength: 0,
            selectedText: "",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 54,
                number: 8,
                start: 54,
                end: 54
            )
        )
        
        let endOfWordForwardLocation = element.fileText.endOfWordForward(startingAt: 54)
        
        XCTAssertNil(endOfWordForwardLocation)
    }
    
}

// Both
extension FT_endOfWordForward_Tests {

    func test_that_it_can_go_to_the_end_of_the_current_word() {
        let text = "some more words to live by..."
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 29,
            caretLocation: 11,
            selectedLength: 1,
            selectedText: "o",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 29,
                number: 2,
                start: 10,
                end: 19
            )
        )

        let endOfWordForwardLocation = element.fileText.endOfWordForward(startingAt: 11)

        XCTAssertEqual(endOfWordForwardLocation, 14)
    }

    func test_that_it_does_not_stop_at_spaces() {
        let text = "yep, it should just jump over spaces!"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 37,
            caretLocation: 13,
            selectedLength: 1,
            selectedText: "d",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 37,
                number: 2,
                start: 8,
                end: 20
            )
        )

        let endOfWordForwardLocation = element.fileText.endOfWordForward(startingAt: 13)

        XCTAssertEqual(endOfWordForwardLocation, 18)
    }

    func test_that_it_considers_a_group_of_symbols_and_punctuations_except_underscore_as_a_word() {
        let text = "for index in text[anchorIndex..<endIndex].indices {"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 51,
            caretLocation: 28,
            selectedLength: 1,
            selectedText: "x",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 51,
                number: 3,
                start: 25,
                end: 37
            )
        )

        let endOfWordForwardLocation = element.fileText.endOfWordForward(startingAt: 28)

        XCTAssertEqual(endOfWordForwardLocation, 31)
    }

    func test_that_it_does_not_stop_at_spaces_after_symbols() {
        let text = "func e(on element: AccessibilityTextelement?) -> AccessibilityTextElement? {"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 76,
            caretLocation: 44,
            selectedLength: 1,
            selectedText: ")",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 76,
                number: 5,
                start: 43,
                end: 49
            )
        )

        let endOfWordForwardLocation = element.fileText.endOfWordForward(startingAt: 44)

        XCTAssertEqual(endOfWordForwardLocation, 47)
    }

    func test_that_it_should_skip_consecutive_whitespaces() {
        let text = "    continue"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 12,
            caretLocation: 1,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 12,
                number: 1,
                start: 0,
                end: 12
            )
        )

        let endOfWordForwardLocation = element.fileText.endOfWordForward(startingAt: 1)

        XCTAssertEqual(endOfWordForwardLocation, 11)
    }
       
    func test_that_if_the_caretLocation_is_at_the_end_limit_of_the_text_before_applying_the_move_then_it_returns_nil() {
        let text = "all those moves are fucking weird"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 33,
            caretLocation: 32,
            selectedLength: 1,
            selectedText: "d",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 33,
                number: 4,
                start: 28,
                end: 33
            )
        )

        let beginningOfWordForwardLocation = element.fileText.endOfWordForward(startingAt: 33)

        XCTAssertNil(beginningOfWordForwardLocation)
    }
    
    func test_that_if_the_text_ends_with_whitespaces_which_means_there_is_no_end_of_word_forward_then_it_returns_nil() {
        let text = "    continue        "
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 20,
            caretLocation: 11,
            selectedLength: 1,
            selectedText: "e",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 20,
                number: 1,
                start: 0,
                end: 20
            )
        )

        let endOfWordForwardLocation = element.fileText.endOfWordForward(startingAt: 11)

        XCTAssertNil(endOfWordForwardLocation)
    }

    func test_that_it_should_skip_whitespaces_before_symbols() {
        let text = "offsetBy: location + 1,"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 23,
            caretLocation: 17,
            selectedLength: 1,
            selectedText: "n",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 23,
                number: 2,
                start: 10,
                end: 21
            )
        )

        let endOfWordForwardLocation = element.fileText.endOfWordForward(startingAt: 17)

        XCTAssertEqual(endOfWordForwardLocation, 19)
    }

    func test_that_it_considers_consecutive_symbols_as_a_word() {
        let text = "if text[nextIndex].isWhitespace || text[nextIndex].isCharacterThatConstitutesAVimWord()"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 87,
            caretLocation: 30,
            selectedLength: 1,
            selectedText: "e",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 87,
                number: 4,
                start: 27,
                end: 35
            )
        )

        let endOfWordForwardLocation = element.fileText.endOfWordForward(startingAt: 30)

        XCTAssertEqual(endOfWordForwardLocation, 33)
    }

}


// TextViews
extension FT_endOfWordForward_Tests {

    func test_that_it_should_not_stop_on_linefeeds() {
        let text = """
guard index != text.index(before: endIndex) else { return text.count - 1 }
let nextIndex = text.index(after: index)
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 115,
            caretLocation: 73,
            selectedLength: 1,
            selectedText: "}",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 9,
                start: 71,
                end: 75
            )
        )

        let endOfWordForwardLocation = element.fileText.endOfWordForward(startingAt: 73)

        XCTAssertEqual(endOfWordForwardLocation, 77)
    }

    func test_that_it_skips_lines_that_are_just_made_of_whitespaces() {
        let text = """
let nextIndex = text.index(after: index)
               
if text[index].isCharacterThatConstitutesAVimWord() {
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 110,
            caretLocation: 39,
            selectedLength: 1,
            selectedText: ")",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 110,
                number: 4,
                start: 28,
                end: 41
            )
        )

        let endOfWordForwardLocation = element.fileText.endOfWordForward(startingAt: 39)

        XCTAssertEqual(endOfWordForwardLocation, 58)
    }

}


// emojis
// see beginningOfWordBackward for the blah blah
extension FT_endOfWordForward_Tests {
    
    func test_that_it_goes_to_the_end_of_a_word_made_of_emojis() {
        let text = "emojis are symbols that 🔫️🔫️🔫️ are longer than 1 length"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 58,
            caretLocation: 24,
            selectedLength: 3,
            selectedText: "🔫️",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 58,
                number: 3,
                start: 24,
                end: 38
            )
        )
        
        let endOfWordForwardLocation = element.fileText.endOfWordForward(startingAt: 24)
        
        XCTAssertEqual(endOfWordForwardLocation, 30)                
    }
    
    func test_that_it_can_pass_the_end_of_a_word_made_of_emojis() {
        let text = "emojis are symbols that 🔫️🔫️🔫️ are longer than 1 length"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 58,
            caretLocation: 30,
            selectedLength: 3,
            selectedText: "🔫️",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 58,
                number: 3,
                start: 24,
                end: 38
            )
        )
        
        let endOfWordForwardLocation = element.fileText.endOfWordForward(startingAt: 30)
        
        XCTAssertEqual(endOfWordForwardLocation, 36)                
    }
    
}
