@testable import AccessibilityStrategy
import XCTest


// see FileLine for blah blah
class FT_SimpleComputedProperties_Tests: XCTestCase {}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension FT_SimpleComputedProperties_Tests {

    func test_that_if_the_text_is_empty_the_computed_properties_are_corret() {
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

        XCTAssertEqual(element.currentFileText.start, 0)
        XCTAssertEqual(element.currentFileText.end, 0)
        XCTAssertEqual(element.currentFileText.value, "")
        XCTAssertEqual(element.currentFileText.endLimit, 0)
    }

    func test_that_if_the_caret_is_at_the_end_of_the_text_on_its_own_empty_line_the_computed_properties_are_correct() {
        let text = """
caret is on its
own empty 🌬️
line

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
                number: 5,
                start: 35,
                end: 35
            )
        )

        XCTAssertEqual(element.currentFileText.start, 0)
        XCTAssertEqual(element.currentFileText.end, 35)
        XCTAssertEqual(element.currentFileText.value, """
caret is on its
own empty 🌬️
line

"""
        )
        XCTAssertEqual(element.currentFileText.endLimit, 35)
    }

}


// other cases
extension FT_SimpleComputedProperties_Tests {

    func test_that_for_a_file_line_that_ends_with_a_linefeed_the_computed_properties_are_correct() {
        let text = """
now i'm a line 📏️📏️📏️ with 📏️
a linefeed 🤱️
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 48,
            caretLocation: 27,
            selectedLength: 2,
            selectedText: "th",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 48,
                number: 2,
                start: 21,
                end: 34
            )
        )

        XCTAssertEqual(element.currentFileText.start, 0)
        XCTAssertEqual(element.currentFileText.end, 48)
        XCTAssertEqual(element.currentFileText.value, """
now i'm a line 📏️📏️📏️ with 📏️
a linefeed 🤱️
"""
        )
        XCTAssertEqual(element.currentFileText.endLimit, 45)
    }

    func test_that_for_a_file_line_that_does_not_end_with_a_linefeed_the_computed_properties_are_correct() {
        let text = """
here we go baby 👶️👶️👶️
fucking 🔥️🔥️🔥️ hell
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 48,
            caretLocation: 29,
            selectedLength: 2,
            selectedText: "ki",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 48,
                number: 3,
                start: 26,
                end: 44
            )
        )

        XCTAssertEqual(element.currentFileText.start, 0)
        XCTAssertEqual(element.currentFileText.end, 48)
        XCTAssertEqual(element.currentFileText.value, """
here we go baby 👶️👶️👶️
fucking 🔥️🔥️🔥️ hell
""")
        XCTAssertEqual(element.currentFileText.endLimit, 47)
    }

    // it may look like it's missing a case where an empty line does not end with a linefeed
    // but this is already tested in the last of The 3 Cases. hehe.
    func test_that_for_an_empty_line_that_ends_with_a_linefeed_the_computed_properties_are_correct() {
        let text = """
the next line 📏️ will be empty

and there's that one 🤌🏼️ line after
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 70,
            caretLocation: 32,
            selectedLength: 1,
            selectedText: "\n",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 70,
                number: 3,
                start: 32,
                end: 33
            )
        )

        XCTAssertEqual(element.currentFileText.start, 0)
        XCTAssertEqual(element.currentFileText.end, 70)
        XCTAssertEqual(element.currentFileText.value, """
the next line 📏️ will be empty

and there's that one 🤌🏼️ line after
"""
        )
        XCTAssertEqual(element.currentFileText.endLimit, 69)
    }
    
    // middle line has a lot of spaces!
    func test_that_for_a_blank_line_that_ends_with_a_linefeed_the_computed_properties_are_correct() {
        let text = """
the next like appears empty but it's actually blank!!!
                  
so careful that Xcode doesn't remove the fucking blanks.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 130,
            caretLocation: 58,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 130,
                number: 4,
                start: 55,
                end: 74
            )
        )

        XCTAssertEqual(element.currentFileText.start, 0)
        XCTAssertEqual(element.currentFileText.end, 130)
        XCTAssertEqual(element.currentFileText.value, """
the next like appears empty but it's actually blank!!!
                  
so careful that Xcode doesn't remove the fucking blanks.
"""
        )
        XCTAssertEqual(element.currentFileText.endLimit, 129)
    }

}
