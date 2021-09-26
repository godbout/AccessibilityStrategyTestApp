@testable import AccessibilityStrategy
import XCTest


// there were no tests before for ATELine but 
// well now we're trying the emojis and it breaks everything so here we go.
// we gonna test with and without emojis coz i'm still not
// familiar with that utf16 shit.
// part 2: i'm now dealing with wrapped lines and isTheLastLine and isNotTheLastLine
// need to be tested more thoroughly too so here we go, 2 new tests. this is because
// the definition of isTheLastLine before was correct only for non wrapped lines. now
// it's updated to take in consideration wrapped lines, and tested.
class AccessibilityTextElementLineTests: XCTestCase {}


// without emojis
// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension AccessibilityTextElementLineTests {
    
    func test_that_without_emojis_if_the_TextElement_is_empty_the_computed_properties_are_correctly_calculated() {
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
        
        XCTAssertEqual(element.currentLine.text.value, "")
        XCTAssertEqual(element.currentLine.length, 0)
        XCTAssertEqual(element.currentLine.lengthWithoutLinefeed, 0)
        XCTAssertEqual(element.currentLine.endLimit, 0)
        XCTAssertEqual(element.currentLine.relativeEndLimit, 0)
        XCTAssertEqual(element.currentLine.isAnEmptyLine, true)
        XCTAssertEqual(element.currentLine.isNotAnEmptyLine, false)
        XCTAssertEqual(element.currentLine.isTheFirstLine, true)
        XCTAssertEqual(element.currentLine.isNotTheFirstLine, false)
        XCTAssertEqual(element.currentLine.isTheLastLine, true)
        XCTAssertEqual(element.currentLine.isNotTheLastLine, false)
    }
    
    func test_that_without_emojis_if_the_caret_is_at_the_last_character_of_the_TextElement_and_on_an_empty_line_the_computed_properties_are_correctly_calculated() {
        let text = """
caret is on its
own empty
line

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 31,
            caretLocation: 31,
            selectedLength: 0,
            selectedText: "",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 4,
                start: 31,
                end: 31
            )
        )
        
        XCTAssertEqual(element.currentLine.text.value, "")
        XCTAssertEqual(element.currentLine.length, 0)
        XCTAssertEqual(element.currentLine.lengthWithoutLinefeed, 0)
        XCTAssertEqual(element.currentLine.endLimit, 31)
        XCTAssertEqual(element.currentLine.relativeEndLimit, 0)
        XCTAssertEqual(element.currentLine.isAnEmptyLine, true)
        XCTAssertEqual(element.currentLine.isNotAnEmptyLine, false)
        XCTAssertEqual(element.currentLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentLine.isTheLastLine, true)
        XCTAssertEqual(element.currentLine.isNotTheLastLine, false)
    }
    
}


// without emojis
// other cases
extension AccessibilityTextElementLineTests {
    
    func test_that_without_emojis_for_a_line_without_a_linefeed_the_computed_properties_are_correctly_calculated() {
        let text = """
here we go baby
fucking hell
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 28,
            caretLocation: 21,
            selectedLength: 3,
            selectedText: "ng ",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 28,
                number: 2,
                start: 16,
                end: 28
            )
        )
        
        XCTAssertEqual(element.currentLine.text.value, "fucking hell")
        XCTAssertEqual(element.currentLine.length, 12)
        XCTAssertEqual(element.currentLine.lengthWithoutLinefeed, 12)
        XCTAssertEqual(element.currentLine.endLimit, 27)
        XCTAssertEqual(element.currentLine.relativeEndLimit, 11)
        XCTAssertEqual(element.currentLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentLine.isTheLastLine, true)
        XCTAssertEqual(element.currentLine.isNotTheLastLine, false)
        
    }
    
    func test_that_without_emojis_for_a_line_with_a_linefeed_the_computed_properties_are_correctly_calculated() {
        let text = """
now i'm a line with
a linefeed
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 30,
            caretLocation: 5,
            selectedLength: 7,
            selectedText: "'m a li",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 30,
                number: 1,
                start: 0,
                end: 20
            )
        )
        
        XCTAssertEqual(element.currentLine.text.value, "now i'm a line with\n")
        XCTAssertEqual(element.currentLine.length, 20)
        XCTAssertEqual(element.currentLine.lengthWithoutLinefeed, 19)
        XCTAssertEqual(element.currentLine.endLimit, 18)
        XCTAssertEqual(element.currentLine.relativeEndLimit, 18)
        XCTAssertEqual(element.currentLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentLine.isTheFirstLine, true)
        XCTAssertEqual(element.currentLine.isNotTheFirstLine, false)
        XCTAssertEqual(element.currentLine.isTheLastLine, false)
        XCTAssertEqual(element.currentLine.isNotTheLastLine, true)
    }
    
    func test_that_without_emojis_for_a_wrapped_line_the_computed_properties_are_correctly_calculated_especially_the_isTheLastLine() {
        let text = """
the isTheLastLine property
has to be careful with
wrapped lines. testing on the linefeed is not enough. there's some more involved!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 131,
            caretLocation: 83,
            selectedLength: 1,
            selectedText: "e",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 131,
                number: 3,
                start: 50,
                end: 96
            )
        )
        
        XCTAssertEqual(element.currentLine.text.value, "wrapped lines. testing on the linefeed is not ")
        XCTAssertEqual(element.currentLine.length, 46)
        XCTAssertEqual(element.currentLine.lengthWithoutLinefeed, 46)
        XCTAssertEqual(element.currentLine.endLimit, 95)
        XCTAssertEqual(element.currentLine.relativeEndLimit, 45)
        XCTAssertEqual(element.currentLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentLine.isTheLastLine, false)
        XCTAssertEqual(element.currentLine.isNotTheLastLine, true)
    }
    
}


// with emojis
// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension AccessibilityTextElementLineTests {
    
    // well empty but with emojis. how does that work? :D
    func test_that_with_emojis_if_the_TextElement_is_empty_the_computed_properties_are_correctly_calculated() {}
    
    func test_that_with_emojis_if_the_caret_is_at_the_last_character_of_the_TextElement_and_on_an_empty_line_the_computed_properties_are_correctly_calculated() {
        let text = """
caret is on its
own empty
line 🌻️

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 35,
            caretLocation: 35,
            selectedLength: 0,
            selectedText: "",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 4,
                start: 35,
                end: 35
            )
        )
        
        XCTAssertEqual(element.currentLine.text.value, "")
        XCTAssertEqual(element.currentLine.length, 0)
        XCTAssertEqual(element.currentLine.lengthWithoutLinefeed, 0)
        XCTAssertEqual(element.currentLine.endLimit, 35)
        XCTAssertEqual(element.currentLine.relativeEndLimit, 0)
        XCTAssertEqual(element.currentLine.isAnEmptyLine, true)
        XCTAssertEqual(element.currentLine.isNotAnEmptyLine, false)
        XCTAssertEqual(element.currentLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentLine.isTheLastLine, true)
        XCTAssertEqual(element.currentLine.isNotTheLastLine, false)
    }
    
}


// with emojis
// other cases
extension AccessibilityTextElementLineTests {
    
    func test_that_with_emojis_in_normal_setting_the_computed_properties_are_correctly_calculated() {
        let text = """
here we go baby 😂️
💩️💩️💩️
fucking hell 🇸🇨️
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 48,
            caretLocation: 10,
            selectedLength: 2,
            selectedText: " b",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 48,
                number: 1,
                start: 0,
                end: 20
            )
        )
        
        XCTAssertEqual(element.currentLine.text.value, "here we go baby 😂️\n")
        XCTAssertEqual(element.currentLine.length, 20)
        XCTAssertEqual(element.currentLine.lengthWithoutLinefeed, 19)
        XCTAssertEqual(element.currentLine.endLimit, 16)
        XCTAssertEqual(element.currentLine.relativeEndLimit, 16)
        XCTAssertEqual(element.currentLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentLine.isTheFirstLine, true)
        XCTAssertEqual(element.currentLine.isNotTheFirstLine, false)
        XCTAssertEqual(element.currentLine.isTheLastLine, false)
        XCTAssertEqual(element.currentLine.isNotTheLastLine, true)
    }
    
    
    
    func test_that_with_emojis_for_a_line_without_a_linefeed_the_computed_properties_are_correctly_calculated_when_the_emoji_is_at_the_end() {
        let text = "i'm a line without linefeed 😅️"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 31,
            caretLocation: 19,
            selectedLength: 2,
            selectedText: "li",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 1,
                start: 0,
                end: 31
            )
        )
        
        XCTAssertEqual(element.currentLine.text.value, "i'm a line without linefeed 😅️")
        XCTAssertEqual(element.currentLine.length, 31)
        XCTAssertEqual(element.currentLine.lengthWithoutLinefeed, 31)
        XCTAssertEqual(element.currentLine.endLimit, 28)
        XCTAssertEqual(element.currentLine.relativeEndLimit, 28)
        XCTAssertEqual(element.currentLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentLine.isTheFirstLine, true)
        XCTAssertEqual(element.currentLine.isNotTheFirstLine, false)
        XCTAssertEqual(element.currentLine.isTheLastLine, true)
        XCTAssertEqual(element.currentLine.isNotTheLastLine, false)
    }
    
    func test_that_with_emojis_for_a_line_without_a_linefeed_the_computed_properties_are_correctly_calculated_when_the_emoji_is_right_before_the_linefeed() {
        let text = """
now i'm a line with 🇲🇴️
a linefeed
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 36,
            caretLocation: 12,
            selectedLength: 1,
            selectedText: "n",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 36,
                number: 1,
                start: 0,
                end: 26
            )
        )
        
        XCTAssertEqual(element.currentLine.text.value, "now i'm a line with 🇲🇴️\n")
        XCTAssertEqual(element.currentLine.length, 26)
        XCTAssertEqual(element.currentLine.lengthWithoutLinefeed, 25)
        XCTAssertEqual(element.currentLine.endLimit, 20)
        XCTAssertEqual(element.currentLine.relativeEndLimit, 20)
        XCTAssertEqual(element.currentLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentLine.isTheFirstLine, true)
        XCTAssertEqual(element.currentLine.isNotTheFirstLine, false)
        XCTAssertEqual(element.currentLine.isTheLastLine, false)
        XCTAssertEqual(element.currentLine.isNotTheLastLine, true)
    }
    
    func test_that_with_emojis_for_a_wrapped_line_the_computed_properties_are_correctly_calculated_especially_the_isTheLastLine() {
        let text = """
the isTheLastLine property
has to be careful with
wrapped lines. testing on the linefeed is not 😂️nough. there's some more involved!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 133,
            caretLocation: 78,
            selectedLength: 21,
            selectedText: "e linefeed is not 😂️",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 133,
                number: 3,
                start: 50,
                end: 99
            )
        )
        
        XCTAssertEqual(element.currentLine.text.value, "wrapped lines. testing on the linefeed is not 😂️")
        XCTAssertEqual(element.currentLine.length, 49)
        XCTAssertEqual(element.currentLine.lengthWithoutLinefeed, 49)
        XCTAssertEqual(element.currentLine.endLimit, 96)
        XCTAssertEqual(element.currentLine.relativeEndLimit, 46)
        XCTAssertEqual(element.currentLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentLine.isTheLastLine, false)
        XCTAssertEqual(element.currentLine.isNotTheLastLine, true)
    }
    
}
