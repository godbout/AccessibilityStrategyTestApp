@testable import AccessibilityStrategy
import XCTest


// see FL firstNonBlankLimit for blah blah
class SL_firstNonBlankLimit_Tests: XCTestCase {}


// Both
extension SL_firstNonBlankLimit_Tests {

    func test_that_if_the_line_starts_with_spaces_it_returns_the_correct_location() {
        let text = "     some spaces are found at the beginning of this text"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 64,
            caretLocation: 18,
            selectedLength: 1,
            selectedText: "s",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 64,
                number: 1,
                start: 0,
                end: 25
            )
        )

        let characterFoundLocation = element.currentScreenLine.firstNonBlankLimit

        XCTAssertEqual(characterFoundLocation, 5)
    }

    func test_that_if_the_line_starts_with_a_tab_character_it_still_returns_the_correct_location() {
        let text = "\t\ttwo tabs now are found at the beginning of this text"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 54,
            caretLocation: 38,
            selectedLength: 1,
            selectedText: "i",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 54,
                number: 4,
                start: 32,
                end: 45
            )
        )

        let characterFoundLocation = element.currentScreenLine.firstNonBlankLimit

        XCTAssertEqual(characterFoundLocation, 32)
    }

    func test_that_if_the_line_starts_with_a_fucking_mix_of_tabs_and_spaces_it_still_returns_the_correct_location() {
        let text = "  \twho writes shits like this?"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 30,
            caretLocation: 23,
            selectedLength: 1,
            selectedText: "e",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 30,
                number: 1,
                start: 0,
                end: 30
            )
        )

        let characterFoundLocation = element.currentScreenLine.firstNonBlankLimit

        XCTAssertEqual(characterFoundLocation, 3)
    }

    func test_that_if_the_line_starts_with_non_blank_characters_then_the_caret_location_is_0() {
        let text = "non whitespace at the beginning here"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 36,
            caretLocation: 18,
            selectedLength: 1,
            selectedText: "t",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 36,
                number: 3,
                start: 15,
                end: 22
            )
        )

        let characterFoundLocation = element.currentScreenLine.firstNonBlankLimit

        XCTAssertEqual(characterFoundLocation, 15)
    }

    func test_that_if_the_line_is_empty_it_returns_0() {
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

        let characterFoundLocation = element.currentScreenLine.firstNonBlankLimit

        XCTAssertEqual(characterFoundLocation, 0)
    }

    func test_that_if_the_line_only_contains_it_returns_nil() {
        let text = "        "
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 8,
            caretLocation: 4,
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

        let characterFoundLocation = element.currentScreenLine.firstNonBlankLimit

        XCTAssertEqual(characterFoundLocation, 7)
    }

    func test_that_if_the_line_only_contains_spaces_and_ends_with_a_linefeed_it_returns_nil() {
        let text = "     \n"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 6,
            caretLocation: 4,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 6,
                number: 1,
                start: 0,
                end: 6
            )
        )

        let characterFoundLocation = element.currentScreenLine.firstNonBlankLimit

        XCTAssertEqual(characterFoundLocation, 4)
    }

}


// emojis
// see beginningOfWordBackward for the blah blah
// actually for blank stuff it doesn't really matter, but at least
// the test is here so i'll not wonder later why there's none :D
extension SL_firstNonBlankLimit_Tests {

    func test_that_it_handles_emojis() {
        let text = "                🔫️🔫️🔫️ are "
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 30,
            caretLocation: 22,
            selectedLength: 3,
            selectedText: "🔫️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 30,
                number: 2,
                start: 16,
                end: 30
            )
        )

        let characterFoundLocation = element.currentScreenLine.firstNonBlankLimit

        XCTAssertEqual(characterFoundLocation, 16)
    }

}
