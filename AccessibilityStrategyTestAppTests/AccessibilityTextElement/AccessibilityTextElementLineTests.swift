@testable import AccessibilityStrategy
import XCTest


// there were no tests before for ATELine but 
// well now we're trying the emojis and it breaks everything so here we go.
// we gonna test with and without emojis coz i'm still not
// familiar with that utf16 shit.
// part 2: i'm now dealing with wrapped lines and isTheLastLine and isNotTheLastLine
// need to be tested more thoroughly too so here we go, new tests. this is because
// the definition of isTheLastLine before was correct only for non wrapped lines. now
// it's updated to take in consideration wrapped lines, and tested.
// part 3: also adding the new isWrapped and isNotWrapped. added that cp for convience.
// summary: ultimately i'm not sure all those tests are needed, but they confirm
// the foundation works, and they're UT so they're cheap :D
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
        
        XCTAssertEqual(element.currentScreenLine.text.value, "")
        XCTAssertEqual(element.currentScreenLine.length, 0)
        XCTAssertEqual(element.currentScreenLine.lengthWithoutLinefeed, 0)
        XCTAssertEqual(element.currentScreenLine.endLimit, 0)
        XCTAssertEqual(element.currentScreenLine.relativeEndLimit, 0)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, false)
        XCTAssertEqual(element.currentScreenLine.isWrapped, false)
        XCTAssertEqual(element.currentScreenLine.isNotWrapped, true)
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
        
        XCTAssertEqual(element.currentScreenLine.text.value, "")
        XCTAssertEqual(element.currentScreenLine.length, 0)
        XCTAssertEqual(element.currentScreenLine.lengthWithoutLinefeed, 0)
        XCTAssertEqual(element.currentScreenLine.endLimit, 31)
        XCTAssertEqual(element.currentScreenLine.relativeEndLimit, 0)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, false)
        XCTAssertEqual(element.currentScreenLine.isWrapped, false)
        XCTAssertEqual(element.currentScreenLine.isNotWrapped, true)
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
        
        XCTAssertEqual(element.currentScreenLine.text.value, "fucking hell")
        XCTAssertEqual(element.currentScreenLine.length, 12)
        XCTAssertEqual(element.currentScreenLine.lengthWithoutLinefeed, 12)
        XCTAssertEqual(element.currentScreenLine.endLimit, 27)
        XCTAssertEqual(element.currentScreenLine.relativeEndLimit, 11)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, false)
        XCTAssertEqual(element.currentScreenLine.isWrapped, false)
        XCTAssertEqual(element.currentScreenLine.isNotWrapped, true)
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
        
        XCTAssertEqual(element.currentScreenLine.text.value, "now i'm a line with\n")
        XCTAssertEqual(element.currentScreenLine.length, 20)
        XCTAssertEqual(element.currentScreenLine.lengthWithoutLinefeed, 19)
        XCTAssertEqual(element.currentScreenLine.endLimit, 18)
        XCTAssertEqual(element.currentScreenLine.relativeEndLimit, 18)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, true)
        XCTAssertEqual(element.currentScreenLine.isWrapped, false)
        XCTAssertEqual(element.currentScreenLine.isNotWrapped, true)
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
        
        XCTAssertEqual(element.currentScreenLine.text.value, "wrapped lines. testing on the linefeed is not ")
        XCTAssertEqual(element.currentScreenLine.length, 46)
        XCTAssertEqual(element.currentScreenLine.lengthWithoutLinefeed, 46)
        XCTAssertEqual(element.currentScreenLine.endLimit, 95)
        XCTAssertEqual(element.currentScreenLine.relativeEndLimit, 45)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, true)
        XCTAssertEqual(element.currentScreenLine.isWrapped, true)
        XCTAssertEqual(element.currentScreenLine.isNotWrapped, false)
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
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 137,
                number: 4,
                start: 94,
                end: 137
            )
        )
        
        XCTAssertEqual(element.currentScreenLine.text.value, "after updating to the new isTheLastLine :D\n")
        XCTAssertEqual(element.currentScreenLine.length, 43)
        XCTAssertEqual(element.currentScreenLine.lengthWithoutLinefeed, 42)
        XCTAssertEqual(element.currentScreenLine.endLimit, 135)
        XCTAssertEqual(element.currentScreenLine.relativeEndLimit, 41)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, true)
        XCTAssertEqual(element.currentScreenLine.isWrapped, false)
        XCTAssertEqual(element.currentScreenLine.isNotWrapped, true)
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
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 60,
                number: 2,
                start: 28,
                end: 29
            )
        )
        
        XCTAssertEqual(element.currentScreenLine.text.value, "\n")
        XCTAssertEqual(element.currentScreenLine.length, 1)
        XCTAssertEqual(element.currentScreenLine.lengthWithoutLinefeed, 0)
        XCTAssertEqual(element.currentScreenLine.endLimit, 28)
        XCTAssertEqual(element.currentScreenLine.relativeEndLimit, 0)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, true)
        XCTAssertEqual(element.currentScreenLine.isWrapped, false)
        XCTAssertEqual(element.currentScreenLine.isNotWrapped, true)
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
        
        XCTAssertEqual(element.currentScreenLine.text.value, "")
        XCTAssertEqual(element.currentScreenLine.length, 0)
        XCTAssertEqual(element.currentScreenLine.lengthWithoutLinefeed, 0)
        XCTAssertEqual(element.currentScreenLine.endLimit, 35)
        XCTAssertEqual(element.currentScreenLine.relativeEndLimit, 0)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, false)
        XCTAssertEqual(element.currentScreenLine.isWrapped, false)
        XCTAssertEqual(element.currentScreenLine.isNotWrapped, true)
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
        
        XCTAssertEqual(element.currentScreenLine.text.value, "here we go baby 😂️\n")
        XCTAssertEqual(element.currentScreenLine.length, 20)
        XCTAssertEqual(element.currentScreenLine.lengthWithoutLinefeed, 19)
        XCTAssertEqual(element.currentScreenLine.endLimit, 16)
        XCTAssertEqual(element.currentScreenLine.relativeEndLimit, 16)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, true)
        XCTAssertEqual(element.currentScreenLine.isWrapped, false)
        XCTAssertEqual(element.currentScreenLine.isNotWrapped, true)
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
        
        XCTAssertEqual(element.currentScreenLine.text.value, "i'm a line without linefeed 😅️")
        XCTAssertEqual(element.currentScreenLine.length, 31)
        XCTAssertEqual(element.currentScreenLine.lengthWithoutLinefeed, 31)
        XCTAssertEqual(element.currentScreenLine.endLimit, 28)
        XCTAssertEqual(element.currentScreenLine.relativeEndLimit, 28)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, false)
        XCTAssertEqual(element.currentScreenLine.isWrapped, false)
        XCTAssertEqual(element.currentScreenLine.isNotWrapped, true)
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
        
        XCTAssertEqual(element.currentScreenLine.text.value, "now i'm a line with 🇲🇴️\n")
        XCTAssertEqual(element.currentScreenLine.length, 26)
        XCTAssertEqual(element.currentScreenLine.lengthWithoutLinefeed, 25)
        XCTAssertEqual(element.currentScreenLine.endLimit, 20)
        XCTAssertEqual(element.currentScreenLine.relativeEndLimit, 20)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, true)
        XCTAssertEqual(element.currentScreenLine.isWrapped, false)
        XCTAssertEqual(element.currentScreenLine.isNotWrapped, true)
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
        
        XCTAssertEqual(element.currentScreenLine.text.value, "wrapped lines. testing on the linefeed is not 😂️")
        XCTAssertEqual(element.currentScreenLine.length, 49)
        XCTAssertEqual(element.currentScreenLine.lengthWithoutLinefeed, 49)
        XCTAssertEqual(element.currentScreenLine.endLimit, 96)
        XCTAssertEqual(element.currentScreenLine.relativeEndLimit, 46)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, true)
        XCTAssertEqual(element.currentScreenLine.isWrapped, true)
        XCTAssertEqual(element.currentScreenLine.isNotWrapped, false)
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
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 144,
                number: 4,
                start: 94,
                end: 144
            )
        )
        
        XCTAssertEqual(element.currentScreenLine.text.value, "after updating 😂️😂️😂️ the new isTheLastLine :D\n")
        XCTAssertEqual(element.currentScreenLine.length, 50)
        XCTAssertEqual(element.currentScreenLine.lengthWithoutLinefeed, 49)
        XCTAssertEqual(element.currentScreenLine.endLimit, 142)
        XCTAssertEqual(element.currentScreenLine.relativeEndLimit, 48)
        XCTAssertEqual(element.currentScreenLine.isAnEmptyLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotAnEmptyLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheFirstLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheFirstLine, true)
        XCTAssertEqual(element.currentScreenLine.isTheLastLine, false)
        XCTAssertEqual(element.currentScreenLine.isNotTheLastLine, true)
        XCTAssertEqual(element.currentScreenLine.isWrapped, false)
        XCTAssertEqual(element.currentScreenLine.isNotWrapped, true)
    }
    
}
