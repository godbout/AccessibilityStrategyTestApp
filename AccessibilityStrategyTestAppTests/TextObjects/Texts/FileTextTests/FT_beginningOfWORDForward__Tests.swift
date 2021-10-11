@testable import AccessibilityStrategy
import XCTest


class FT_beginningOfWORDForward__Tests: XCTestCase {}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension FT_beginningOfWORDForward__Tests {
    
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
        
        let beginningOfWORDForwardLocation = element.fileText.beginningOfWORDForward(startingAt: 0)
        
        XCTAssertNil(beginningOfWORDForwardLocation)
    }
    
    func test_that_if_the_caret_is_after_the_last_character_on_an_empty_line_then_it_returns_nils() {
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
        
        let beginningOfWORDForwardLocation = element.fileText.beginningOfWORDForward(startingAt: 54)
        
        XCTAssertNil(beginningOfWORDForwardLocation)
    }
    
}


// Both
extension FT_beginningOfWORDForward__Tests {
    
    func test_that_it_can_go_to_the_beginning_of_the_next_WORD() {
        let text = "a few words to live by"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 22,
            caretLocation: 6,
            selectedLength: 1,
            selectedText: "w",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 22,
                number: 1,
                start: 0,
                end: 12
            )
        )
        
        let beginningOfWORDForwardLocation = element.fileText.beginningOfWORDForward(startingAt: 6)
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 12)
    }
    
    func test_that_it_does_not_stop_at_punctuations() {
        let text = "class wordForwardTests: XCTestCase {"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 36,
            caretLocation: 8,
            selectedLength: 1,
            selectedText: "r",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 36,
                number: 2,
                start: 6,
                end: 18
            )
        )
        
        let beginningOfWORDForwardLocation = element.fileText.beginningOfWORDForward(startingAt: 8)
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 24)
    }    
    
    func test_that_it_passes_several_consecutive_whitespaces() {
        let text = "this is some text with        space"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 35,
            caretLocation: 22,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 2,
                start: 13,
                end: 30
            )
        )
        
        let beginningOfWORDForwardLocation = element.fileText.beginningOfWORDForward(startingAt: 22)
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 30)
    }
    
    func test_that_if_the_caretLocation_is_at_the_end_limit_of_the_text_before_applying_the_move_then_it_returns_nil() {
        let text = "w at the end of the buffer shouldn't craaaash"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 45,
            caretLocation: 44,
            selectedLength: 1,
            selectedText: "h",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 45,
                number: 5,
                start: 37,
                end: 45
            )
        )

        let beginningOfWordForwardLocation = element.fileText.beginningOfWORDForward(startingAt: 44)

        XCTAssertNil(beginningOfWordForwardLocation)
    }
    
    func test_that_if_the_caretLocation_is_not_at_the_end_limit_of_the_text_before_applying_the_move_but_ends_there_after_then_it_returns_the_end_limit_of_the_text() {
        let text = "w at the end of the buffer shouldn't craaaash"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 45,
            caretLocation: 42,
            selectedLength: 1,
            selectedText: "a",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 45,
                number: 5,
                start: 37,
                end: 45
            )
        )

        let beginningOfWordForwardLocation = element.fileText.beginningOfWORDForward(startingAt: 42)

        XCTAssertEqual(beginningOfWordForwardLocation, 44)
    }
    
    func test_that_it_passes_several_consecutive_punctuations() {
        let text = "for index in text[anchorIndex..<endIndex].indices {"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 51,
            caretLocation: 29,
            selectedLength: 1,
            selectedText: ".",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 51,
                number: 3,
                start: 25,
                end: 37
            )
        )
        
        let beginningOfWORDForwardLocation = element.fileText.beginningOfWORDForward(startingAt: 29)
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 50)
    }
    
    func test_that_it_does_not_stop_at_a_space_after_a_punctuation() {
        let text = "let anchorIndex = text.index(text.startIndex, offsetBy: location)"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 65,
            caretLocation: 54,
            selectedLength: 1,
            selectedText: ":",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 65,
                number: 7,
                start: 46,
                end: 56
            )
        )
        
        let beginningOfWORDForwardLocation = element.fileText.beginningOfWORDForward(startingAt: 54)
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 56)
    }
    
    func test_that_it_does_not_stop_at_a_space_after_a_symbol() {
        let text = "guard index != text.index(before: endIndex) else { return text.count - 1 }"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 74,
            caretLocation: 12,
            selectedLength: 1,
            selectedText: "!",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 74,
                number: 2,
                start: 6,
                end: 15
            )
        )
        
        let beginningOfWORDForwardLocation = element.fileText.beginningOfWORDForward(startingAt: 12)
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 15)
    }
    
    func test_that_it_does_not_stop_at_a_space_after_a_number() {
        let text = "guard index != text.index(before: endIndex) else { return text.count - 1 }"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 74,
            caretLocation: 71,
            selectedLength: 1,
            selectedText: "1",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 74,
                number: 9,
                start: 71,
                end: 74
            )
        )
        
        let beginningOfWORDForwardLocation = element.fileText.beginningOfWORDForward(startingAt: 71)
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 73)
    }
    
    func test_that_it_does_not_stop_at_underscores_that_are_not_part_of_a_word() {
        let text = """
if text[nextIndex] == "_" {
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 27,
            caretLocation: 22,
            selectedLength: 1,
            selectedText: "\"",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 27,
                number: 3,
                start: 15,
                end: 27
            )
        )
        
        let beginningOfWORDForwardLocation = element.fileText.beginningOfWORDForward(startingAt: 22)
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 26)
    }
    
    func test_that_it_does_not_stop_at_punctuations_that_are_preceded_by_an_underscore() {
        let text = """
if text[nextIndex] == "_" {
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 27,
            caretLocation: 23,
            selectedLength: 1,
            selectedText: "_",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 27,
                number: 3,
                start: 15,
                end: 27
            )
        )
        
        let beginningOfWORDForwardLocation = element.fileText.beginningOfWORDForward(startingAt: 23)
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 26)
    }
    
    func test_that_it_does_not_stop_at_numbers_that_are_part_of_a_word() {
        let text = "saf sadfhasdf4asdf dfd"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 22,
            caretLocation: 5,
            selectedLength: 1,
            selectedText: "a",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 22,
                number: 2,
                start: 4,
                end: 16
            )
        )
        
        let beginningOfWORDForwardLocation = element.fileText.beginningOfWORDForward(startingAt: 5)
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 19)
    }
    
    func test_that_letters_numbers_and_underscores_together_are_considered_a_word() {
        let text = "this is gonna be only one word__oh_my_55_a yes"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 46,
            caretLocation: 26,
            selectedLength: 1,
            selectedText: "w",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 46,
                number: 4,
                start: 26,
                end: 38
            )
        )
        
        let beginningOfWORDForwardLocation = element.fileText.beginningOfWORDForward(startingAt: 26)
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 43)
    }
    
    func test_that_it_does_not_stop_after_an_underscore_that_finishes_a_word() {
        let text = "but who writes stuff like_ this"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 31,
            caretLocation: 23,
            selectedLength: 1,
            selectedText: "k",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 3,
                start: 21,
                end: 31
            )
        )
        
        let beginningOfWORDForwardLocation = element.fileText.beginningOfWORDForward(startingAt: 23)
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 27)
    }
    
}


// TextViews
extension FT_beginningOfWORDForward__Tests {
    
    func test_that_it_does_not_get_blocked_on_a_line() {
        let text = """
w can go
to the next line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 25,
            caretLocation: 7,
            selectedLength: 1,
            selectedText: "o",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 25,
                number: 1,
                start: 0,
                end: 9
            )
        )
        
        let beginningOfWORDForwardLocation = element.fileText.beginningOfWORDForward(startingAt: 7)
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 9)
    }
    
    func test_that_it_stops_at_an_empty_line() {
        let text = """
w should stop

at empty lines
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 29,
            caretLocation: 12,
            selectedLength: 1,
            selectedText: "p",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 29,
                number: 2,
                start: 9,
                end: 14
            )
        )
        
        let beginningOfWORDForwardLocation = element.fileText.beginningOfWORDForward(startingAt: 12)
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 14)
    }
    
    func test_that_it_does_not_stop_at_a_line_that_has_just_whitespaces() {
        let text = """
w shouldn't stop
at the following line that looks empty but has
   
whitespaces
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 79,
            caretLocation: 62,
            selectedLength: 1,
            selectedText: "s",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 79,
                number: 7,
                start: 56,
                end: 64
            )
        )
        
        let beginningOfWORDForwardLocation = element.fileText.beginningOfWORDForward(startingAt: 62)
        
        XCTAssertEqual(beginningOfWORDForwardLocation, 68)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FT_beginningOfWORDForward__Tests {

    func test_that_it_handles_emojis() {
        let text = "emojis are symbols that 🔫️🔫️haha🔫️ are longer than 1 length"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 62,
            caretLocation: 27,
            selectedLength: 3,
            selectedText: "🔫️",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 62,
                number: 3,
                start: 24,
                end: 38
            )
        )

        let beginningOfWORDForwardLocation = element.fileText.beginningOfWORDForward(startingAt: 27)

        XCTAssertEqual(beginningOfWORDForwardLocation, 38)
    }

}