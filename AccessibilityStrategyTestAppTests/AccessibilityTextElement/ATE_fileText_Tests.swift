@testable import AccessibilityStrategy
import XCTest


class ATE_fileText_Tests: XCTestCase {}


// without emojis
// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension ATE_fileText_Tests {
    
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
        
        XCTAssertEqual(element.fileText.value, "")
        XCTAssertEqual(element.fileText.start, 0)
        XCTAssertEqual(element.fileText.end, 0)
        XCTAssertEqual(element.fileText.length, 0)
        XCTAssertEqual(element.fileText.endLimit, 0)
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
        
        XCTAssertEqual(element.fileText.value, """
caret is on its
own empty
line

"""
        )
        XCTAssertEqual(element.fileText.start, 0)
        XCTAssertEqual(element.fileText.end, 31)
        XCTAssertEqual(element.fileText.length, 31)
        XCTAssertEqual(element.fileText.endLimit, 31)
    }
    
}


// without emojis
// other cases
extension ATE_fileText_Tests {
    
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
            fullyVisibleArea: 0..<28,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 28,
                number: 2,
                start: 16,
                end: 28
            )!
        )
        
        XCTAssertEqual(element.fileText.value, """
here we go baby
fucking hell
"""
        )
        XCTAssertEqual(element.fileText.start, 0)
        XCTAssertEqual(element.fileText.end, 28)
        XCTAssertEqual(element.fileText.length, 28)
        XCTAssertEqual(element.fileText.endLimit, 27)
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
        
        XCTAssertEqual(element.fileText.value, """
now i'm a line with
a linefeed
""")
        XCTAssertEqual(element.fileText.start, 0)
        XCTAssertEqual(element.fileText.end, 30)
        XCTAssertEqual(element.fileText.length, 30)
        XCTAssertEqual(element.fileText.endLimit, 29)
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
        
        XCTAssertEqual(element.fileText.value, """
the isTheLastLine property
has to be careful with
wrapped lines. testing on the linefeed is not enough. there's some more involved!
"""
        )
        XCTAssertEqual(element.fileText.start, 0)
        XCTAssertEqual(element.fileText.end, 131)
        XCTAssertEqual(element.fileText.length, 131)
        XCTAssertEqual(element.fileText.endLimit, 130)
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
        
        XCTAssertEqual(element.fileText.value, """
caret is on the line
just before the empty and before
this test it would return isTheLastLine
after updating to the new isTheLastLine :D

""")
        XCTAssertEqual(element.fileText.start, 0)
        XCTAssertEqual(element.fileText.end, 137)
        XCTAssertEqual(element.fileText.length, 137)
        XCTAssertEqual(element.fileText.endLimit, 137)
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
        
        XCTAssertEqual(element.fileText.value, """
the next line will be empty

and there's that one line after
"""
        )
        XCTAssertEqual(element.fileText.start, 0)
        XCTAssertEqual(element.fileText.end, 60)
        XCTAssertEqual(element.fileText.length, 60)
        XCTAssertEqual(element.fileText.endLimit, 59)
    }
    
}


// with emojis
// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension ATE_fileText_Tests {
    
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
        
        XCTAssertEqual(element.fileText.value, """
caret is on its
own empty
line 🌻️

""")
        XCTAssertEqual(element.fileText.start, 0)
        XCTAssertEqual(element.fileText.end, 35)
        XCTAssertEqual(element.fileText.length, 35)
        XCTAssertEqual(element.fileText.endLimit, 35)
    }
    
}


// with emojis
// other cases
extension ATE_fileText_Tests {
    
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
        
        XCTAssertEqual(element.fileText.value, """
here we go baby 😂️
💩️💩️💩️
fucking hell 🇸🇨️
"""
        )
        XCTAssertEqual(element.fileText.start, 0)
        XCTAssertEqual(element.fileText.end, 48)
        XCTAssertEqual(element.fileText.length, 48)
        XCTAssertEqual(element.fileText.endLimit, 43)
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
        
        XCTAssertEqual(element.fileText.value, "i'm a line without linefeed 😅️")
        XCTAssertEqual(element.fileText.start, 0)
        XCTAssertEqual(element.fileText.end, 31)
        XCTAssertEqual(element.fileText.length, 31)
        XCTAssertEqual(element.fileText.endLimit, 28)
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
        
        XCTAssertEqual(element.fileText.value, """
now i'm a line with 🇲🇴️
a linefeed
"""
        )
        XCTAssertEqual(element.fileText.start, 0)
        XCTAssertEqual(element.fileText.end, 36)
        XCTAssertEqual(element.fileText.length, 36)
        XCTAssertEqual(element.fileText.endLimit, 35)
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
        
        XCTAssertEqual(element.fileText.value, """
the isTheLastLine property
has to be careful with
wrapped lines. testing on the linefeed is not 😂️nough. there's some more involved!
"""
        )
        XCTAssertEqual(element.fileText.start, 0)
        XCTAssertEqual(element.fileText.end, 133)
        XCTAssertEqual(element.fileText.length, 133)
        XCTAssertEqual(element.fileText.endLimit, 132)
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
        
        XCTAssertEqual(element.fileText.value, """
caret is on the line
just before the empty and before
this test it would return isTheLastLine
after updating 😂️😂️😂️ the new isTheLastLine :D

"""
        )
        XCTAssertEqual(element.fileText.start, 0)
        XCTAssertEqual(element.fileText.end, 144)
        XCTAssertEqual(element.fileText.length, 144)
        XCTAssertEqual(element.fileText.endLimit, 144)
    }
    
}
