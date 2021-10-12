@testable import AccessibilityStrategy
import XCTest


// see FL firstNonBlankLimit for blah blah
class SL_firstNonBlankLimit_Tests: XCTestCase {}


// Both
extension SL_firstNonBlankLimit_Tests {

    func test_that_if_the_line_starts_with_spaces_it_returns_the_correct_location() {
        let text = "     some spaces are found at the beginning of this text"
        
        let screenLine = ScreenLine(fullTextValue: text, fullTextLength: text.utf16.count, number: 1, start: 0, end: 25)
        
        XCTAssertEqual(screenLine.firstNonBlankLimit, 5)
    }

    func test_that_if_the_line_starts_with_a_tab_character_it_still_returns_the_correct_location() {
        let text = "\t\ttwo tabs now are found at the beginning of this text"
        
        let screenLine = ScreenLine(fullTextValue: text, fullTextLength: text.utf16.count, number: 4, start: 32, end: 45)
        
        XCTAssertEqual(screenLine.firstNonBlankLimit, 32)
    }

    func test_that_if_the_line_starts_with_a_fucking_mix_of_tabs_and_spaces_it_still_returns_the_correct_location() {
        let text = "  \twho writes shits like this?"

        let screenLine = ScreenLine(fullTextValue: text, fullTextLength: text.utf16.count, number: 1, start: 0, end: 30)

        XCTAssertEqual(screenLine.firstNonBlankLimit, 3)
    }

    func test_that_if_the_line_starts_with_non_blank_characters_then_the_caret_location_is_0() {
        let text = "non whitespace at the beginning here"

        let screenLine = ScreenLine(fullTextValue: text, fullTextLength: text.utf16.count, number: 3, start: 15, end: 22)

        XCTAssertEqual(screenLine.firstNonBlankLimit, 15)
    }

    func test_that_if_the_line_is_empty_it_returns_0() {
        let text = ""

        let screenLine = ScreenLine(fullTextValue: text, fullTextLength: text.utf16.count, number: 1, start: 0, end: 0)

        XCTAssertEqual(screenLine.firstNonBlankLimit, 0)
    }

    func test_that_if_the_line_only_contains_it_returns_nil() {
        let text = "        "

        let screenLine = ScreenLine(fullTextValue: text, fullTextLength: text.utf16.count, number: 1, start: 0, end: 8)

        XCTAssertEqual(screenLine.firstNonBlankLimit, 7)
    }

    func test_that_if_the_line_only_contains_spaces_and_ends_with_a_linefeed_it_returns_nil() {
        let text = "     \n"

        let screenLine = ScreenLine(fullTextValue: text, fullTextLength: text.utf16.count, number: 1, start: 0, end: 6)

        XCTAssertEqual(screenLine.firstNonBlankLimit, 4)
    }

}


// emojis
// see beginningOfWordBackward for the blah blah
// actually for blank stuff it doesn't really matter, but at least
// the test is here so i'll not wonder later why there's none :D
extension SL_firstNonBlankLimit_Tests {

    func test_that_it_handles_emojis() {
        let text = "                🔫️🔫️🔫️ are "

        let screenLine = ScreenLine(fullTextValue: text, fullTextLength: text.utf16.count, number: 2, start: 16, end: 30)

        XCTAssertEqual(screenLine.firstNonBlankLimit, 16)
    }

}
