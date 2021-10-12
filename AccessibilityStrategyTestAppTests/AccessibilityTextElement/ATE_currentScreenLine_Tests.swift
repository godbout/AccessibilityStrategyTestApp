@testable import AccessibilityStrategy
import XCTest


class ATE_currentScreenLine_Tests: XCTestCase {}


// without emojis
// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension ATE_currentScreenLine_Tests {
    
    func test_that_without_emojis_if_the_TextElement_is_empty_the_computed_properties_are_correctly_calculated() {
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
            )!
        )
        
        XCTAssertEqual(element.currentScreenLine.value, "")
        XCTAssertEqual(element.currentScreenLine.number, 1)
        XCTAssertEqual(element.currentScreenLine.start, 0)
        XCTAssertEqual(element.currentScreenLine.end, 0)
        XCTAssertEqual(element.currentScreenLine.length, 0)
        XCTAssertEqual(element.currentScreenLine.endLimit, 0)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, false)
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 4,
                start: 31,
                end: 31
            )!
        )
        
        XCTAssertEqual(element.currentScreenLine.value, "")
        XCTAssertEqual(element.currentScreenLine.number, 4)
        XCTAssertEqual(element.currentScreenLine.start, 31)
        XCTAssertEqual(element.currentScreenLine.end, 31)
        XCTAssertEqual(element.currentScreenLine.length, 0)
        XCTAssertEqual(element.currentScreenLine.endLimit, 31)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, false)
    }
    
}


// without emojis
// other cases
extension ATE_currentScreenLine_Tests {
    
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 28,
                number: 2,
                start: 16,
                end: 28
            )!
        )
        
        XCTAssertEqual(element.currentScreenLine.value, "fucking hell")
        XCTAssertEqual(element.currentScreenLine.number, 2)
        XCTAssertEqual(element.currentScreenLine.start, 16)
        XCTAssertEqual(element.currentScreenLine.end, 28)
        XCTAssertEqual(element.currentScreenLine.length, 12)
        XCTAssertEqual(element.currentScreenLine.endLimit, 27)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, false)
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 30,
                number: 1,
                start: 0,
                end: 20
            )!
        )
        
        XCTAssertEqual(element.currentScreenLine.value, "now i'm a line with\n")
        XCTAssertEqual(element.currentScreenLine.number, 1)
        XCTAssertEqual(element.currentScreenLine.start, 0)
        XCTAssertEqual(element.currentScreenLine.end, 20)
        XCTAssertEqual(element.currentScreenLine.length, 20)
        XCTAssertEqual(element.currentScreenLine.endLimit, 18)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, true)
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 131,
                number: 3,
                start: 50,
                end: 96
            )!
        )
        
        XCTAssertEqual(element.currentScreenLine.value, "wrapped lines. testing on the linefeed is not ")
        XCTAssertEqual(element.currentScreenLine.number, 3)
        XCTAssertEqual(element.currentScreenLine.start, 50)
        XCTAssertEqual(element.currentScreenLine.end, 96)
        XCTAssertEqual(element.currentScreenLine.length, 46)
        XCTAssertEqual(element.currentScreenLine.endLimit, 95)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, true)
    }
    
    func test_that_without_emojis_if_the_caret_is_on_the_line_before_the_last_empty_line_then_the_computed_properties_are_correct_and_especially_it_is_not_considered_the_last_line() {
        let text = """
caret is on the line
just before the empty and before
this test it would return isTheLastLine
after updating to the new isTheLastLine :D

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 137,
            caretLocation: 110,
            selectedLength: 1,
            selectedText: "o",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 137,
                number: 4,
                start: 94,
                end: 137
            )!
        )
        
        XCTAssertEqual(element.currentScreenLine.value, "after updating to the new isTheLastLine :D\n")
        XCTAssertEqual(element.currentScreenLine.number, 4)
        XCTAssertEqual(element.currentScreenLine.start, 94)
        XCTAssertEqual(element.currentScreenLine.end, 137)
        XCTAssertEqual(element.currentScreenLine.length, 43)
        XCTAssertEqual(element.currentScreenLine.endLimit, 135)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, true)
    }
    
    func test_that_without_emojis_for_an_empty_line_with_a_linefeed_the_computed_properties_are_correctly_calculated() {
        let text = """
the next line will be empty

and there's that one line after
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 60,
            caretLocation: 28,
            selectedLength: 0,
            selectedText: "",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 60,
                number: 2,
                start: 28,
                end: 29
            )!
        )
        
        XCTAssertEqual(element.currentScreenLine.value, "\n")
        XCTAssertEqual(element.currentScreenLine.number, 2)
        XCTAssertEqual(element.currentScreenLine.start, 28)
        XCTAssertEqual(element.currentScreenLine.end, 29)
        XCTAssertEqual(element.currentScreenLine.length, 1)
        XCTAssertEqual(element.currentScreenLine.endLimit, 28)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, true)
    }
    
}


// with emojis
// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension ATE_currentScreenLine_Tests {
    
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 4,
                start: 35,
                end: 35
            )!
        )
        
        XCTAssertEqual(element.currentScreenLine.value, "")
        XCTAssertEqual(element.currentScreenLine.number, 4)
        XCTAssertEqual(element.currentScreenLine.start, 35)
        XCTAssertEqual(element.currentScreenLine.end, 35)
        XCTAssertEqual(element.currentScreenLine.length, 0)
        XCTAssertEqual(element.currentScreenLine.endLimit, 35)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, false)
    }
    
}


// with emojis
// other cases
extension ATE_currentScreenLine_Tests {
    
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 48,
                number: 1,
                start: 0,
                end: 20
            )!
        )
        
        XCTAssertEqual(element.currentScreenLine.value, "here we go baby 😂️\n")
        XCTAssertEqual(element.currentScreenLine.number, 1)
        XCTAssertEqual(element.currentScreenLine.start, 0)
        XCTAssertEqual(element.currentScreenLine.end, 20)
        XCTAssertEqual(element.currentScreenLine.length, 20)
        XCTAssertEqual(element.currentScreenLine.endLimit, 16)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, false)
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 1,
                start: 0,
                end: 31
            )!
        )
        
        XCTAssertEqual(element.currentScreenLine.value, "i'm a line without linefeed 😅️")
        XCTAssertEqual(element.currentScreenLine.number, 1)
        XCTAssertEqual(element.currentScreenLine.start, 0)
        XCTAssertEqual(element.currentScreenLine.end, 31)
        XCTAssertEqual(element.currentScreenLine.length, 31)
        XCTAssertEqual(element.currentScreenLine.endLimit, 28)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, false)
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 36,
                number: 1,
                start: 0,
                end: 26
            )!
        )
        
        XCTAssertEqual(element.currentScreenLine.value, "now i'm a line with 🇲🇴️\n")
        XCTAssertEqual(element.currentScreenLine.number, 1)
        XCTAssertEqual(element.currentScreenLine.start, 0)
        XCTAssertEqual(element.currentScreenLine.end, 26)
        XCTAssertEqual(element.currentScreenLine.length, 26)
        XCTAssertEqual(element.currentScreenLine.endLimit, 20)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, true)
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 133,
                number: 3,
                start: 50,
                end: 99
            )!
        )
        
        XCTAssertEqual(element.currentScreenLine.value, "wrapped lines. testing on the linefeed is not 😂️")
        XCTAssertEqual(element.currentScreenLine.number, 3)
        XCTAssertEqual(element.currentScreenLine.start, 50)
        XCTAssertEqual(element.currentScreenLine.end, 99)
        XCTAssertEqual(element.currentScreenLine.length, 49)
        XCTAssertEqual(element.currentScreenLine.endLimit, 96)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, true)
    }
    
    func test_that_with_emojis_if_the_caret_is_on_the_line_before_the_last_empty_line_then_the_computed_properties_are_correct_and_especially_it_is_not_considered_the_last_line() {
        let text = """
caret is on the line
just before the empty and before
this test it would return isTheLastLine
after updating 😂️😂️😂️ the new isTheLastLine :D

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 144,
            caretLocation: 106,
            selectedLength: 20,
            selectedText: "ng 😂️😂️😂️ the new",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 144,
                number: 4,
                start: 94,
                end: 144
            )!
        )
        
        XCTAssertEqual(element.currentScreenLine.value, "after updating 😂️😂️😂️ the new isTheLastLine :D\n")
        XCTAssertEqual(element.currentScreenLine.number, 4)
        XCTAssertEqual(element.currentScreenLine.start, 94)
        XCTAssertEqual(element.currentScreenLine.end, 144)
        XCTAssertEqual(element.currentScreenLine.length, 50)
        XCTAssertEqual(element.currentScreenLine.endLimit, 142)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, true)
    }
    
}
