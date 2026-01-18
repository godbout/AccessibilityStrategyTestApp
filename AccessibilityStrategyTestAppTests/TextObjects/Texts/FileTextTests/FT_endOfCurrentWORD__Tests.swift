@testable import AccessibilityStrategy
import XCTest


class FT_endOfCurrentWORD__Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Int? {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.endOfCurrentWORD(startingAt: caretLocation)
    }
    
}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension FT_endOfCurrentWORD__Tests {
    
    func test_that_if_the_text_is_empty_then_it_returns_nil() {
        let text = ""

        let endOfCurrentWORDLocation = applyFuncBeingTested(on: text, startingAt: 0)

        XCTAssertNil(endOfCurrentWORDLocation)
    }
    
    func test_that_if_the_caret_is_after_the_last_character_on_an_EmptyLine_then_it_returns_nil() {
        let text = """
a couple of
lines but not
coke haha but
with linefeed

"""

        let endOfCurrentWORDLocation = applyFuncBeingTested(on: text, startingAt: 54)

        XCTAssertNil(endOfCurrentWORDLocation)
    }
    
}


// TextFields and TextViews
extension FT_endOfCurrentWORD__Tests {
    
    func test_that_it_can_go_to_the_end_of_the_current_word() {
        let text = "some more words to live by..."

        let endOfCurrentWORDLocation = applyFuncBeingTested(on: text, startingAt: 11)

        XCTAssertEqual(endOfCurrentWORDLocation, 14)
    }
    
    func test_that_if_it_is_at_the_end_of_the_current_word_it_does_not_move() {
        let text = "some more words to live by..."

        let endOfCurrentWORDLocation = applyFuncBeingTested(on: text, startingAt: 14)

        XCTAssertEqual(endOfCurrentWORDLocation, 14)
    }
    
    func test_that_it_considers_a_group_of_symbols_and_punctuations_including_underscore_as_a_word() {
        let text = "for index in text[anchorIndex..<endIndex].indices {"

        let endOfCurrentWORDLocation = applyFuncBeingTested(on: text, startingAt: 28)

        XCTAssertEqual(endOfCurrentWORDLocation, 48)
    }
    
    func test_that_it_does_not_stop_at_spaces_after_symbols() {
        let text = "func e(on element: AccessibilityTextelement?) -> AccessibilityTextElement? {"

        let endOfCurrentWORDLocation = applyFuncBeingTested(on: text, startingAt: 45)

        XCTAssertEqual(endOfCurrentWORDLocation, 47)
    }
    
    func test_that_it_should_skip_consecutive_whitespaces() {
        let text = "    continue"

        let endOfCurrentWORDLocation = applyFuncBeingTested(on: text, startingAt: 1)

        XCTAssertEqual(endOfCurrentWORDLocation, 11)
    }
    
    func test_that_if_the_caretLocation_is_at_the_end_limit_of_the_text_before_applying_the_move_then_it_returns_this_end_limit() {
        let text = "all those moves are fucking weird"

        let endOfCurrentWORDLocation = applyFuncBeingTested(on: text, startingAt: 32)

        XCTAssertEqual(endOfCurrentWORDLocation, 32)
    }
    
    func test_that_if_the_text_ends_with_whitespaces_which_means_there_is_no_end_of_WORD_forward_then_it_returns_nil() {
        let text = "    continue        "

        let endOfCurrentWORDLocation = applyFuncBeingTested(on: text, startingAt: 12)

        XCTAssertNil(endOfCurrentWORDLocation)
    }
    
    func test_that_it_should_skip_whitespaces_before_symbols() {
        let text = "offsetBy: location  + 1,"

        let endOfCurrentWORDLocation = applyFuncBeingTested(on: text, startingAt: 18)

        XCTAssertEqual(endOfCurrentWORDLocation, 20)
    }
    
    func test_that_it_considers_consecutive_symbols_as_a_word() {
        let text = "if text[nextIndex].isWhitespace || text[nextIndex].isCharacterThatConstitutesAVimWord()"

        let endOfCurrentWORDLocation = applyFuncBeingTested(on: text, startingAt: 31)

        XCTAssertEqual(endOfCurrentWORDLocation, 33)
    }
    
}


// TextViews
extension FT_endOfCurrentWORD__Tests {
    
    func test_that_it_should_not_stop_on_linefeeds() {
        let text = """
guard index != text.index(before: endIndex) else { return text.count - 1 }
let nextIndex = text.index(after: index)
"""

        let endOfCurrentWORDLocation = applyFuncBeingTested(on: text, startingAt: 74)

        XCTAssertEqual(endOfCurrentWORDLocation, 77)
    }
    
    func test_that_it_skips_lines_that_are_just_made_of_whitespaces() {
        let text = """
let nextIndex = text.index(after: index)
               
if text[index].isCharacterThatConstitutesAVimWord() {
"""

        let endOfCurrentWORDLocation = applyFuncBeingTested(on: text, startingAt: 45)

        XCTAssertEqual(endOfCurrentWORDLocation, 58)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FT_endOfCurrentWORD__Tests {
    
    func test_that_it_goes_to_the_end_of_a_WORD_made_of_emojis() {
        let text = "emojis are symbols theEat 🔫️🔫️pistol🔫️ are longer than 1 length"

        let endOfCurrentWORDLocation = applyFuncBeingTested(on: text, startingAt: 25)

        XCTAssertEqual(endOfCurrentWORDLocation, 38)
    }

}
