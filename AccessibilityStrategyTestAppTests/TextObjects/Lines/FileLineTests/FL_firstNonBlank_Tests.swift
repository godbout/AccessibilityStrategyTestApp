@testable import AccessibilityStrategy
import XCTest


class FL_firstNonBlank_Tests: XCTestCase {}


// Both
extension FL_firstNonBlank_Tests {
    
    func test_that_if_the_line_starts_with_spaces_it_returns_the_correct_location() {
        let text = "     some spaces are found at the beginning of this text"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 56,
            caretLocation: 23,
            selectedLength: 1,
            selectedText: "s",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 56,
                number: 1,
                start: 0,
                end: 56
            )
        )
        
        let characterFoundLocation = element.currentFileLine.firstNonBlank
        
        XCTAssertEqual(characterFoundLocation, 5)     
    }
    
    func test_that_if_the_line_starts_with_a_tab_character_it_still_returns_the_correct_location() {
        let text = "\t\ttwo tabs now are found at the beginning of this text"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 54,
            caretLocation: 17,
            selectedLength: 1,
            selectedText: "t",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 54,
                number: 1,
                start: 0,
                end: 15
            )
        )
        
        let characterFoundLocation = element.currentFileLine.firstNonBlank
        
        XCTAssertEqual(characterFoundLocation, 2)   
    }
    
    func test_that_if_the_line_starts_with_a_fucking_mix_of_tabs_and_spaces_it_still_returns_the_correct_location() {
        let text = "  \twho writes shits like this?"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 30,
            caretLocation: 11,
            selectedLength: 1,
            selectedText: "w",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 30,
                number: 1,
                start: 0,
                end: 20
            )
        )
                
        let characterFoundLocation = element.currentFileLine.firstNonBlank
        
        XCTAssertEqual(characterFoundLocation, 3)   
    }
    
    func test_that_if_the_line_starts_with_non_blank_characters_then_the_caret_location_is_0() {
        let text = "non whitespace at the beginning here"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 36,
            caretLocation: 30,
            selectedLength: 1,
            selectedText: "g",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 36,
                number: 2,
                start: 18,
                end: 36
            )
        )
        
        let characterFoundLocation = element.currentFileLine.firstNonBlank
        
        XCTAssertEqual(characterFoundLocation, 0)
    }
    
    func test_that_if_the_line_is_empty_it_returns_nil() {
        let text = ""
        let element = AccessibilityTextElement(
            role: .textArea,
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
                
        let characterFoundLocation = element.currentFileLine.firstNonBlank
        
        XCTAssertNil(characterFoundLocation)
    }
   
    func test_that_if_the_TextField_only_contains_spaces_it_returns_nil() {
        let text = "        "
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 8,
            caretLocation: 5,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 8,
                number: 1,
                start: 0,
                end: 8
            )
        )
                
        let characterFoundLocation = element.currentFileLine.firstNonBlank
        
        XCTAssertNil(characterFoundLocation)
    }
    
}


// TextViews
extension FL_firstNonBlank_Tests {
    
    func test_that_for_a_line_with_linefeed_the_caret_goes_to_the_end_of_the_line_before_the_linefeed() {
        let text = """
            
and a line is empty!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 34,
            caretLocation: 7,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 34,
                number: 1,
                start: 0,
                end: 13
            )
        )
        
        let characterFoundLocation = element.currentFileLine.firstNonBlank
        
        XCTAssertEqual(characterFoundLocation, 12)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FL_firstNonBlank_Tests {
    
    // actually this function especially doesn't need anything special to handle emojis as it is counting only
    // the blank characters and will stop at the first non blank found. still for consistency so that i'm not wondering
    // later here it is.
    func test_that_it_handles_emojis() {
        let text = "     😂️"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 8,
            caretLocation: 1,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 8,
                number: 1,
                start: 0,
                end: 8
            )
        )
                
        let characterFoundLocation = element.currentFileLine.firstNonBlank
        
        XCTAssertEqual(characterFoundLocation, 5)                
    }
    
}
