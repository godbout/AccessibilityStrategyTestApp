@testable import AccessibilityStrategy
import XCTest


class SL_SimpleComputerProperties_Tests: XCTestCase {}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension SL_SimpleComputerProperties_Tests {
    
    func test_that_if_the_text_is_empty_the_computed_properties_are_corret() {
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
        
        XCTAssertEqual(element.currentScreenLine.start, 0)
        XCTAssertEqual(element.currentScreenLine.end, 0)
        XCTAssertEqual(element.currentScreenLine.value, "")
        XCTAssertEqual(element.currentScreenLine.endLimit, 0)
        XCTAssertEqual(element.currentScreenLine.firstNonBlankLimit, 0)
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 5,
                start: 35,
                end: 35
            )
        )
        
        XCTAssertEqual(element.currentScreenLine.start, 35)
        XCTAssertEqual(element.currentScreenLine.end, 35)
        XCTAssertEqual(element.currentScreenLine.value, "")
        XCTAssertEqual(element.currentScreenLine.endLimit, 35)
        XCTAssertEqual(element.currentScreenLine.firstNonBlankLimit, 35)
    }
    
}


// other cases
extension SL_SimpleComputerProperties_Tests {
    
    func test_that_for_a_screen_line_that_ends_with_a_linefeed_the_computed_properties_are_correct() {
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 48,
                number: 2,
                start: 21,
                end: 34
            )
        )
        
        XCTAssertEqual(element.currentScreenLine.start, 21)
        XCTAssertEqual(element.currentScreenLine.end, 34)
        XCTAssertEqual(element.currentScreenLine.value, "📏️ with 📏️\n")
        XCTAssertEqual(element.currentScreenLine.endLimit, 30)
        XCTAssertEqual(element.currentScreenLine.firstNonBlankLimit, 21)
    }

    func test_that_for_a_screen_line_that_does_not_end_with_a_linefeed_the_computed_properties_are_correct() {
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 48,
                number: 3,
                start: 26,
                end: 44
            )
        )
        
        XCTAssertEqual(element.currentScreenLine.start, 26)
        XCTAssertEqual(element.currentScreenLine.end, 44)
        XCTAssertEqual(element.currentScreenLine.value, "fucking 🔥️🔥️🔥️ ")
        XCTAssertEqual(element.currentScreenLine.endLimit, 43)
        XCTAssertEqual(element.currentScreenLine.firstNonBlankLimit, 26)
    }
    
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 70,
                number: 3,
                start: 32,
                end: 33
            )
        )
        
        XCTAssertEqual(element.currentScreenLine.start, 32)
        XCTAssertEqual(element.currentScreenLine.end, 33)
        XCTAssertEqual(element.currentScreenLine.value, "\n")
        XCTAssertEqual(element.currentScreenLine.endLimit, 32)
        XCTAssertEqual(element.currentScreenLine.firstNonBlankLimit, 32)
    }
    
}
