@testable import AccessibilityStrategy
import XCTest


class FileLineTests: XCTestCase {}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension FileLineTests {

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

        XCTAssertEqual(element.currentFileLine.start, 0)
        XCTAssertEqual(element.currentFileLine.end, 0)
        XCTAssertEqual(element.currentFileLine.value, "")
        XCTAssertEqual(element.currentFileLine.endLimit, 0)
        XCTAssertEqual(element.currentFileLine.firstNonBlank, 0)
        XCTAssertEqual(element.currentFileLine.firstNonBlankLimit, 0)
        XCTAssertEqual(element.currentFileLine.length, 0)
        XCTAssertEqual(element.currentFileLine.lengthWithoutLinefeed, 0)
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

        XCTAssertEqual(element.currentFileLine.start, 35)
        XCTAssertEqual(element.currentFileLine.end, 35)
        XCTAssertEqual(element.currentFileLine.value, "")
        XCTAssertEqual(element.currentFileLine.endLimit, 35)
        XCTAssertEqual(element.currentFileLine.firstNonBlank, 35)
        XCTAssertEqual(element.currentFileLine.firstNonBlankLimit, 35)
        XCTAssertEqual(element.currentFileLine.length, 0)
        XCTAssertEqual(element.currentFileLine.lengthWithoutLinefeed, 0)
    }

}


// other cases
extension FileLineTests {

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

        XCTAssertEqual(element.currentFileLine.start, 0)
        XCTAssertEqual(element.currentFileLine.end, 34)
        XCTAssertEqual(element.currentFileLine.value, "now i'm a line 📏️📏️📏️ with 📏️\n")
        XCTAssertEqual(element.currentFileLine.endLimit, 30)
        XCTAssertEqual(element.currentFileLine.firstNonBlank, 0)
        XCTAssertEqual(element.currentFileLine.firstNonBlankLimit, 0)
        XCTAssertEqual(element.currentFileLine.length, 34)
        XCTAssertEqual(element.currentFileLine.lengthWithoutLinefeed, 33)
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

        XCTAssertEqual(element.currentFileLine.start, 26)
        XCTAssertEqual(element.currentFileLine.end, 48)
        XCTAssertEqual(element.currentFileLine.value, "fucking 🔥️🔥️🔥️ hell")
        XCTAssertEqual(element.currentFileLine.endLimit, 47)
        XCTAssertEqual(element.currentFileLine.firstNonBlank, 26)
        XCTAssertEqual(element.currentFileLine.firstNonBlankLimit, 26)
        XCTAssertEqual(element.currentFileLine.length, 22)
        XCTAssertEqual(element.currentFileLine.lengthWithoutLinefeed, 22)
    }

    // it looks like it's missing a case where an empty line does not end with a linefeed
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

        XCTAssertEqual(element.currentFileLine.start, 32)
        XCTAssertEqual(element.currentFileLine.end, 33)
        XCTAssertEqual(element.currentFileLine.value, "\n")
        XCTAssertEqual(element.currentFileLine.endLimit, 32)
        XCTAssertEqual(element.currentFileLine.firstNonBlank, 32)
        XCTAssertEqual(element.currentFileLine.firstNonBlankLimit, 32)
        XCTAssertEqual(element.currentFileLine.length, 1)
        XCTAssertEqual(element.currentFileLine.lengthWithoutLinefeed, 0)
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

        XCTAssertEqual(element.currentFileLine.start, 55)
        XCTAssertEqual(element.currentFileLine.end, 74)
        XCTAssertEqual(element.currentFileLine.value, "                  \n")
        XCTAssertEqual(element.currentFileLine.endLimit, 72)
        XCTAssertEqual(element.currentFileLine.firstNonBlank, 73)
        XCTAssertEqual(element.currentFileLine.firstNonBlankLimit, 72)
        XCTAssertEqual(element.currentFileLine.length, 19)
        XCTAssertEqual(element.currentFileLine.lengthWithoutLinefeed, 18)
    }

}
