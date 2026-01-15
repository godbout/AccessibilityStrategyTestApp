@testable import AccessibilityStrategy
import XCTest


class ATE_currentFileLine_Tests: XCTestCase {}


// without emojis
// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension ATE_currentFileLine_Tests {
    
    func test_that_without_emojis_if_the_TextElement_is_empty_the_computed_properties_are_correctly_calculated() {
        let text = ""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 0,
            caretLocation: 0,
            selectedLength: 0,
            selectedText: "",
            fullyVisibleArea: 0..<0,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 0,
                number: 1,
                start: 0,
                end: 0
            )!
        )
        
        XCTAssertEqual(element.currentFileLine.value, "")
        XCTAssertEqual(element.currentFileLine.start, 0)
        XCTAssertEqual(element.currentFileLine.end, 0)
        XCTAssertEqual(element.currentFileLine.length, 0)
        XCTAssertEqual(element.currentFileLine.endLimit, 0)
        XCTAssertEqual(element.currentFileLine.isAnEmptyLine, true)
        XCTAssertEqual(element.currentFileLine.isNotAnEmptyLine, false)
        XCTAssertEqual(element.currentFileLine.isTheFirstLine, true)
        XCTAssertEqual(element.currentFileLine.isNotTheFirstLine, false)
        XCTAssertEqual(element.currentFileLine.isTheLastLine, true)
        XCTAssertEqual(element.currentFileLine.isNotTheLastLine, false)
    }
    
    func test_that_without_emojis_if_the_caret_is_at_the_last_character_of_the_TextElement_and_on_an_EmptyLine_the_computed_properties_are_correctly_calculated() {
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
            fullyVisibleArea: 0..<31,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 4,
                start: 31,
                end: 31
            )!
        )
        
        XCTAssertEqual(element.currentFileLine.value, "")
        XCTAssertEqual(element.currentFileLine.start, 31)
        XCTAssertEqual(element.currentFileLine.end, 31)
        XCTAssertEqual(element.currentFileLine.length, 0)
        XCTAssertEqual(element.currentFileLine.endLimit, 31)
        XCTAssertEqual(element.currentFileLine.isAnEmptyLine, true)
        XCTAssertEqual(element.currentFileLine.isNotAnEmptyLine, false)
        XCTAssertEqual(element.currentFileLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentFileLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentFileLine.isTheLastLine, true)
        XCTAssertEqual(element.currentFileLine.isNotTheLastLine, false)
    }
    
}


// without emojis
// other cases
extension ATE_currentFileLine_Tests {
    
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
            selectedLength: 1,
            selectedText: "n",
            fullyVisibleArea: 0..<28,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 28,
                number: 3,
                start: 16,
                end: 28
            )!
        )
        
        XCTAssertEqual(element.currentFileLine.value, "fucking hell")
        XCTAssertEqual(element.currentFileLine.start, 16)
        XCTAssertEqual(element.currentFileLine.end, 28)
        XCTAssertEqual(element.currentFileLine.length, 12)
        XCTAssertEqual(element.currentFileLine.endLimit, 27)
        XCTAssertEqual(element.currentFileLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentFileLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentFileLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentFileLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentFileLine.isTheLastLine, true)
        XCTAssertEqual(element.currentFileLine.isNotTheLastLine, false)
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
            fullyVisibleArea: 0..<30,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 30,
                number: 1,
                start: 0,
                end: 20
            )!
        )
        
        XCTAssertEqual(element.currentFileLine.value, "now i'm a line with\n")
        XCTAssertEqual(element.currentFileLine.start, 0)
        XCTAssertEqual(element.currentFileLine.end, 20)
        XCTAssertEqual(element.currentFileLine.length, 20)
        XCTAssertEqual(element.currentFileLine.endLimit, 18)
        XCTAssertEqual(element.currentFileLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentFileLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentFileLine.isTheFirstLine, true)
        XCTAssertEqual(element.currentFileLine.isNotTheFirstLine, false)
        XCTAssertEqual(element.currentFileLine.isTheLastLine, false)
        XCTAssertEqual(element.currentFileLine.isNotTheLastLine, true)
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
            fullyVisibleArea: 0..<131,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 131,
                number: 3,
                start: 50,
                end: 96
            )!
        )
        
        XCTAssertEqual(element.currentFileLine.value, "wrapped lines. testing on the linefeed is not enough. there's some more involved!")
        XCTAssertEqual(element.currentFileLine.start, 50)
        XCTAssertEqual(element.currentFileLine.end, 131)
        XCTAssertEqual(element.currentFileLine.length, 81)
        XCTAssertEqual(element.currentFileLine.endLimit, 130)
        XCTAssertEqual(element.currentFileLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentFileLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentFileLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentFileLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentFileLine.isTheLastLine, true)
        XCTAssertEqual(element.currentFileLine.isNotTheLastLine, false)
    }
    
    func test_that_without_emojis_if_the_caret_is_on_the_line_before_the_last_EmptyLine_then_the_computed_properties_are_correct_and_especially_it_is_not_considered_the_last_line() {
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
            fullyVisibleArea: 0..<137,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 137,
                number: 4,
                start: 94,
                end: 137
            )!
        )
        
        XCTAssertEqual(element.currentFileLine.value, "after updating to the new isTheLastLine :D\n")
        XCTAssertEqual(element.currentFileLine.start, 94)
        XCTAssertEqual(element.currentFileLine.end, 137)
        XCTAssertEqual(element.currentFileLine.length, 43)
        XCTAssertEqual(element.currentFileLine.endLimit, 135)
        XCTAssertEqual(element.currentFileLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentFileLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentFileLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentFileLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentFileLine.isTheLastLine, false)
        XCTAssertEqual(element.currentFileLine.isNotTheLastLine, true)
    }
    
    func test_that_without_emojis_for_an_EmptyLine_with_a_linefeed_the_computed_properties_are_correctly_calculated() {
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
            fullyVisibleArea: 0..<60,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 60,
                number: 2,
                start: 28,
                end: 29
            )!
        )
        
        XCTAssertEqual(element.currentFileLine.value, "\n")
        XCTAssertEqual(element.currentFileLine.start, 28)
        XCTAssertEqual(element.currentFileLine.end, 29)
        XCTAssertEqual(element.currentFileLine.length, 1)
        XCTAssertEqual(element.currentFileLine.endLimit, 28)
        XCTAssertEqual(element.currentFileLine.isAnEmptyLine, true)
        XCTAssertEqual(element.currentFileLine.isNotAnEmptyLine, false)
        XCTAssertEqual(element.currentFileLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentFileLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentFileLine.isTheLastLine, false)
        XCTAssertEqual(element.currentFileLine.isNotTheLastLine, true)
    }
    
}


// with emojis
// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension ATE_currentFileLine_Tests {
    
    // well empty but with emojis. how does that work? :D
    func test_that_with_emojis_if_the_TextElement_is_empty_the_computed_properties_are_correctly_calculated() {}
    
    func test_that_with_emojis_if_the_caret_is_at_the_last_character_of_the_TextElement_and_on_an_EmptyLine_the_computed_properties_are_correctly_calculated() {
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
            fullyVisibleArea: 0..<35,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 4,
                start: 35,
                end: 35
            )!
        )
        
        XCTAssertEqual(element.currentFileLine.value, "")
        XCTAssertEqual(element.currentFileLine.start, 35)
        XCTAssertEqual(element.currentFileLine.end, 35)
        XCTAssertEqual(element.currentFileLine.length, 0)
        XCTAssertEqual(element.currentFileLine.endLimit, 35)
        XCTAssertEqual(element.currentFileLine.isAnEmptyLine, true)
        XCTAssertEqual(element.currentFileLine.isNotAnEmptyLine, false)
        XCTAssertEqual(element.currentFileLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentFileLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentFileLine.isTheLastLine, true)
        XCTAssertEqual(element.currentFileLine.isNotTheLastLine, false)
    }
    
}


// with emojis
// other cases
extension ATE_currentFileLine_Tests {
    
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
            fullyVisibleArea: 0..<48,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 48,
                number: 1,
                start: 0,
                end: 20
            )!
        )
        
        XCTAssertEqual(element.currentFileLine.value, "here we go baby 😂️\n")
        XCTAssertEqual(element.currentFileLine.start, 0)
        XCTAssertEqual(element.currentFileLine.end, 20)
        XCTAssertEqual(element.currentFileLine.length, 20)
        XCTAssertEqual(element.currentFileLine.endLimit, 16)
        XCTAssertEqual(element.currentFileLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentFileLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentFileLine.isTheFirstLine, true)
        XCTAssertEqual(element.currentFileLine.isNotTheFirstLine, false)
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
            fullyVisibleArea: 0..<31,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 1,
                start: 0,
                end: 31
            )!
        )
        
        XCTAssertEqual(element.currentFileLine.value, "i'm a line without linefeed 😅️")
        XCTAssertEqual(element.currentFileLine.start, 0)
        XCTAssertEqual(element.currentFileLine.end, 31)
        XCTAssertEqual(element.currentFileLine.length, 31)
        XCTAssertEqual(element.currentFileLine.endLimit, 28)
        XCTAssertEqual(element.currentFileLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentFileLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentFileLine.isTheFirstLine, true)
        XCTAssertEqual(element.currentFileLine.isNotTheFirstLine, false)
        XCTAssertEqual(element.currentFileLine.isTheLastLine, true)
        XCTAssertEqual(element.currentFileLine.isNotTheLastLine, false)
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
            fullyVisibleArea: 0..<36,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 36,
                number: 1,
                start: 0,
                end: 26
            )!
        )
        
        XCTAssertEqual(element.currentFileLine.value, "now i'm a line with 🇲🇴️\n")
        XCTAssertEqual(element.currentFileLine.start, 0)
        XCTAssertEqual(element.currentFileLine.end, 26)
        XCTAssertEqual(element.currentFileLine.length, 26)
        XCTAssertEqual(element.currentFileLine.endLimit, 20)
        XCTAssertEqual(element.currentFileLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentFileLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentFileLine.isTheFirstLine, true)
        XCTAssertEqual(element.currentFileLine.isNotTheFirstLine, false)
        XCTAssertEqual(element.currentFileLine.isTheLastLine, false)
        XCTAssertEqual(element.currentFileLine.isNotTheLastLine, true)
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
            fullyVisibleArea: 0..<133,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 133,
                number: 3,
                start: 50,
                end: 99
            )!
        )
        
        XCTAssertEqual(element.currentFileLine.value, "wrapped lines. testing on the linefeed is not 😂️nough. there's some more involved!")
        XCTAssertEqual(element.currentFileLine.start, 50)
        XCTAssertEqual(element.currentFileLine.end, 133)
        XCTAssertEqual(element.currentFileLine.length, 83)
        XCTAssertEqual(element.currentFileLine.endLimit, 132)
        XCTAssertEqual(element.currentFileLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentFileLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentFileLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentFileLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentFileLine.isTheLastLine, true)
        XCTAssertEqual(element.currentFileLine.isNotTheLastLine, false)
    }
    
    func test_that_with_emojis_if_the_caret_is_on_the_line_before_the_last_EmptyLine_then_the_computed_properties_are_correct_and_especially_it_is_not_considered_the_last_line() {
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
            fullyVisibleArea: 0..<144,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 144,
                number: 4,
                start: 94,
                end: 144
            )!
        )
        
        XCTAssertEqual(element.currentFileLine.value, "after updating 😂️😂️😂️ the new isTheLastLine :D\n")
        XCTAssertEqual(element.currentFileLine.start, 94)
        XCTAssertEqual(element.currentFileLine.end, 144)
        XCTAssertEqual(element.currentFileLine.length, 50)
        XCTAssertEqual(element.currentFileLine.endLimit, 142)
        XCTAssertEqual(element.currentFileLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentFileLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentFileLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentFileLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentFileLine.isTheLastLine, false)
        XCTAssertEqual(element.currentFileLine.isNotTheLastLine, true)
    }
    
}
