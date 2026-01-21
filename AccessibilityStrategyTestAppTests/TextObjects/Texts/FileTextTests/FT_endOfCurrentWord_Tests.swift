@testable import AccessibilityStrategy
import XCTest


class FT_endOfCurrentWord_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Int? {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.endOfCurrentWord(startingAt: caretLocation)
    }

}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension FT_endOfCurrentWord_Tests {
    
    func test_that_if_the_text_is_empty_then_it_returns_nil() {
        let text = ""
        
        let endOfCurrentWordLocation = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertNil(endOfCurrentWordLocation)
    }
    
    func test_that_if_the_caret_is_after_the_last_character_on_an_EmptyLine_then_it_returns_nil() {
        let text = """
a couple of
lines but not
coke haha but
with linefeed

"""

        let endOfCurrentWordLocation = applyFuncBeingTested(on: text, startingAt: 54)

        XCTAssertNil(endOfCurrentWordLocation)
    }
    
}

// TextFields and TextViews
extension FT_endOfCurrentWord_Tests {
    
    func test_that_it_can_go_to_the_end_of_the_current_word() {
        let text = "some more words to live by..."

        let endOfCurrentWordLocation = applyFuncBeingTested(on: text, startingAt: 11)

        XCTAssertEqual(endOfCurrentWordLocation, 14)
    }
    
    func test_that_if_it_is_at_the_end_of_the_current_word_it_does_not_move() {
        let text = "some more words to live by..."

        let endOfCurrentWordLocation = applyFuncBeingTested(on: text, startingAt: 14)

        XCTAssertEqual(endOfCurrentWordLocation, 14)
    }

    func test_that_it_considers_a_group_of_symbols_and_punctuations_except_underscore_as_a_word() {
        let text = "for index in text[anchorIndex..<endIndex].indices {"

        let endOfCurrentWordLocation = applyFuncBeingTested(on: text, startingAt: 29)

        XCTAssertEqual(endOfCurrentWordLocation, 31)
    }

    func test_that_it_does_stop_at_spaces_after_symbols() {
        let text = "func e(on element: AccessibilityTextElement) -> AccessibilityTextElement {"

        let endOfCurrentWordLocation = applyFuncBeingTested(on: text, startingAt: 43)

        XCTAssertEqual(endOfCurrentWordLocation, 43)
    }

    func test_that_it_should_skip_consecutive_whitespaces() {
        let text = "    continue"

        let endOfCurrentWordLocation = applyFuncBeingTested(on: text, startingAt: 1)

        XCTAssertEqual(endOfCurrentWordLocation, 11)
    }
       
    func test_that_if_the_caretLocation_is_at_the_end_limit_of_the_text_before_applying_the_move_then_it_returns_this_end_limit() {
        let text = "all those moves are fucking weird"

        let endOfCurrentWordLocation = applyFuncBeingTested(on: text, startingAt: 32)

        XCTAssertEqual(endOfCurrentWordLocation, 32)
    }
    
    func test_that_if_the_text_ends_with_whitespaces_which_means_there_is_no_end_of_word_forward_then_it_returns_nil() {
        let text = "    continue        "

        let endOfCurrentWordLocation = applyFuncBeingTested(on: text, startingAt: 12)

        XCTAssertNil(endOfCurrentWordLocation)
    }

    func test_that_it_should_skip_whitespaces_before_symbols() {
        let text = "offsetBy: location  + 1,"

        let endOfCurrentWordLocation = applyFuncBeingTested(on: text, startingAt: 18)

        XCTAssertEqual(endOfCurrentWordLocation, 20)
    }

    func test_that_it_considers_consecutive_symbols_as_a_word() {
        let text = "if text[nextIndex].isWhitespace || text[nextIndex].isCharacterThatConstitutesAVimWord()"

        let endOfCurrentWordLocation = applyFuncBeingTested(on: text, startingAt: 31)

        XCTAssertEqual(endOfCurrentWordLocation, 33)
    }

}


// TextViews
extension FT_endOfCurrentWord_Tests {

    func test_that_it_should_not_stop_on_Newlines() {
        let text = """
guard index != text.index(before: endIndex) else { return text.count - 1 }
let nextIndex = text.index(after: index)
"""

        let endOfCurrentWordLocation = applyFuncBeingTested(on: text, startingAt: 74)

        XCTAssertEqual(endOfCurrentWordLocation, 77)
    }

    func test_that_it_skips_lines_that_are_just_made_of_whitespaces() {
        let text = """
let nextIndex = text.index(after: index)
               
if text[index].isCharacterThatConstitutesAVimWord() {
"""

        let endOfCurrentWordLocation = applyFuncBeingTested(on: text, startingAt: 45)

        XCTAssertEqual(endOfCurrentWordLocation, 58)
    }

}


// emojis
// see beginningOfWordBackward for the blah blah
extension FT_endOfCurrentWord_Tests {
    
    func test_that_it_goes_to_the_end_of_a_word_made_of_emojis() {
        let text = "emojis are symbols that 🔫️🔫️🔫️ are longer than 1 length"

        let endOfCurrentWordLocation = applyFuncBeingTested(on: text, startingAt: 24)

        XCTAssertEqual(endOfCurrentWordLocation, 30)
    }

}

