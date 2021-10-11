@testable import AccessibilityStrategy
import XCTest


// here we don't need much tests for what is a Vim word
// as this is already tested in other FileText funcs.
// innerWord is using beginningOfWordBackward and endOfWordForward
// for its calculation (which are already tested), except for whitespaces
// which is why it's more important to have the whitespaces tested here
class FT_innerWordTests_Tests: XCTestCase {}


// Both
extension FT_innerWordTests_Tests {
    
    func test_that_if_the_text_is_empty_it_returns_a_range_of_0_to_0() {
        let text = ""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 0,
            caretLocation: 0,
            selectedLength: 0,
            selectedText: "",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 0,
                number: 1,
                start: 0,
                end: 0
            )
        )
        
        let wordRange = element.fileText.innerWord(startingAt: 0)
        
        XCTAssertEqual(wordRange.lowerBound, 0)
        XCTAssertEqual(wordRange.upperBound, 0)
    }
    
    func test_that_if_the_caret_is_on_a_letter_if_finds_the_correct_inner_word() {
        let text = "ok we're gonna try to get the inner word here"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 45,
            caretLocation: 10,
            selectedLength: 1,
            selectedText: "o",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 45,
                number: 2,
                start: 9,
                end: 22
            )
        )
        
        let wordRange = element.fileText.innerWord(startingAt: 10)
        
        XCTAssertEqual(wordRange.lowerBound, 9)
        XCTAssertEqual(wordRange.upperBound, 13) 
    }
    
    func test_that_if_the_caret_is_on_a_space_the_inner_word_is_all_the_consecutive_spaces() {
        let text = "ok so now we have a lot of     spaces"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 37,
            caretLocation: 28,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 37,
                number: 3,
                start: 24,
                end: 31
            )
        )
        
        let wordRange = element.fileText.innerWord(startingAt: 28)
        
        XCTAssertEqual(wordRange.lowerBound, 26)
        XCTAssertEqual(wordRange.upperBound, 30)         
    }
    
    func test_that_if_the_caret_is_on_a_single_space_it_recognizes_it_as_an_inner_word() {
        let text = "a single space is an inner word"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 31,
            caretLocation: 20,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 2,
                start: 9,
                end: 21
            )
        )
        
        let wordRange = element.fileText.innerWord(startingAt: 20)
        
        XCTAssertEqual(wordRange.lowerBound, 20)
        XCTAssertEqual(wordRange.upperBound, 20) 
    }
    
    func test_that_if_the_TextField_starts_with_spaces_it_finds_the_correct_inner_word() {
        let text = "     that's lots of spaces"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 26,
            caretLocation: 4,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 26,
                number: 1,
                start: 0,
                end: 12
            )
        )
        
        let wordRange = element.fileText.innerWord(startingAt: 4)
        
        XCTAssertEqual(wordRange.lowerBound, 0)
        XCTAssertEqual(wordRange.upperBound, 4) 
    }
    
    func test_that_if_the_TextField_ends_with_spaces_it_still_gets_the_correct_inner_word() {
        let text = "that's lots of spaces again       "
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 34,
            caretLocation: 29,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 34,
                number: 3,
                start: 22,
                end: 34
            )
        )
        
        let wordRange = element.fileText.innerWord(startingAt: 29)
        
        XCTAssertEqual(wordRange.lowerBound, 27)
        XCTAssertEqual(wordRange.upperBound, 34) 
    }

}


// TextViews
extension FT_innerWordTests_Tests {
    
    func test_that_inner_word_stops_at_linefeeds_at_the_end_of_lines() {
        let text = """
this shouldn't
spill      
   on the next line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 46,
            caretLocation: 23,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 46,
                number: 3,
                start: 15,
                end: 27
            )
        )
        
        let wordRange = element.fileText.innerWord(startingAt: 23)
        
        XCTAssertEqual(wordRange.lowerBound, 20)
        XCTAssertEqual(wordRange.upperBound, 25)
    }
    
    func test_that_inner_word_stops_at_linefeeds_at_the_beginning_of_lines() {
        let text = """
this shouldn't
spill also    
    backwards
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 43,
            caretLocation: 33,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 43,
                number: 4,
                start: 30,
                end: 34
            )
        )
        
        let wordrange = element.fileText.innerWord(startingAt: 33)
        
        XCTAssertEqual(wordrange.lowerBound, 30)
        XCTAssertEqual(wordrange.upperBound, 33)
    }
    
}


// emojis
// emojis are symbols so as long as we take care of the emojis length, all the rest
// works exactly like symbols: passing, skipping, part or not of words, etc...
// so no need to test those parts again.
extension FT_innerWordTests_Tests {
    
    func test_that_it_handles_emojis() {
        let text = "emojis are symbols that 🔫️🔫️🔫️ are longer than 1 length"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 58,
            caretLocation: 27,
            selectedLength: 3,
            selectedText: "🔫️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 58,
                number: 3,
                start: 24,
                end: 38
            )
        )
        
        let wordRange = element.fileText.innerWord(startingAt: 27)
        
        XCTAssertEqual(wordRange.lowerBound, 24)
        XCTAssertEqual(wordRange.upperBound, 30)                
    }
    
    func test_that_it_does_not_do_shit_with_emojis_before_a_space() {
        let text = "emojis are symbols that 🔫️🔫️🔫️ are longer than 1 length"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 58,
            caretLocation: 33,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 58,
                number: 3,
                start: 24,
                end: 38
            )
        )
        
        let wordRange = element.fileText.innerWord(startingAt: 33)
        
        XCTAssertEqual(wordRange.lowerBound, 33)
        XCTAssertEqual(wordRange.upperBound, 33)                
    }
    
}
