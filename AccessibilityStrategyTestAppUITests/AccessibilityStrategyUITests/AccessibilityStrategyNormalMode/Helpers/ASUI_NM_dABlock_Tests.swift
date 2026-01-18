@testable import AccessibilityStrategy
import XCTest
import Common


// this move just calls cABlock, and then reposition the caret location.
// so the tests are done in UT and UIT cABlock. here we test the repositioning after the move.
class ASUI_NM_dABlock_Tests: ASUI_NM_BaseTests {

    private func applyMoveBeingTested(using openingBlock: OpeningBlockType) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState()
        
        return applyMove { asNormalMode.dABlock(using: openingBlock, on: $0, &vimEngineState) }
    }

}


// TextFields and TextViews
extension ASUI_NM_dABlock_Tests {
    
    func test_that_if_there_is_no_block_found_the_caretLocation_does_not_move() {
        let textInAXFocusedElement = "no block here"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.b(on: $0) }

        let accessibilityElement = applyMoveBeingTested(using: .leftBrace)

        XCTAssertEqual(accessibilityElement.caretLocation, 9)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "h")
    }
    
    func test_that_if_the_block_is_on_a_same_line_it_repositions_the_caretLocation_correctly() {
        let textInAXFocusedElement = "now th😄️at is ( some stuff 😄️😄️😄️on the same ) line😄️"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.b(times: 5, on: $0) }

        let accessibilityElement = applyMoveBeingTested(using: .leftParenthesis)

        XCTAssertEqual(accessibilityElement.caretLocation, 15)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
    }
    
}


// TextViews
extension ASUI_NM_dABlock_Tests {

    func test_that_if_the_opening_and_closing_block_are_on_different_lines_it_repositions_the_caretLocation_correctly() {
        let textInAXFocusedElement = """
this case is when { is not followed
by a linefeed
and } is not preceded by a linefeed
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(times: 2, on: $0) }

        let accessibilityElement = applyMoveBeingTested(using: .leftBrace)

        XCTAssertEqual(accessibilityElement.caretLocation, 18)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
    }
    
    func test_that_if_the_closing_bracket_is_preceded_only_by_whitespaces_up_to_the_beginning_of_the_line_then_it_repositions_the_caretLocation_correctly() {
        let textInAXFocusedElement = """
this case is when { is not followed
by a linefeed and
     } is preceded by a linefeed
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(times: 2, on: $0) }

        let accessibilityElement = applyMoveBeingTested(using: .leftBrace)

        XCTAssertEqual(accessibilityElement.caretLocation, 18)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
    }

    func test_that_if_the_opening_bracket_is_immediately_followed_by_a_linefeed_then_it_repositions_the_caretLocation_correctly() {
        let textInAXFocusedElement = """
this work when [
is followed by a linefeed
and ] is not preceded by a linefeed
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(times: 2, on: $0) }

        let accessibilityElement = applyMoveBeingTested(using: .leftBracket)

        XCTAssertEqual(accessibilityElement.caretLocation, 15)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
    }

    func test_that_if_the_opening_bracket_is_immediately_followed_by_a_linefeed_and_the_closing_bracket_is_immediately_preceded_by_a_linefeed_then_it_repositions_the_caretLocation_correctly() {
        let textInAXFocusedElement = """
this case is when (
is followed by a linefeed and
) is preceded by a linefeed
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(times: 2, on: $0) }

        let accessibilityElement = applyMoveBeingTested(using: .leftParenthesis)

        XCTAssertEqual(accessibilityElement.caretLocation, 18)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
    }
    
    func test_that_if_the_closing_bracket_is_immediately_followed_by_a_linefeed_then_it_repositions_the_caretLocation_correctly() {
        let textInAXFocusedElement = """
this case is when <
is followed by a linefeed and
>

and more
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(times: 2, on: $0) }

        let accessibilityElement = applyMoveBeingTested(using: .leftChevron)

        XCTAssertEqual(accessibilityElement.caretLocation, 17)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
    }
    
    func test_that_if_the_closing_bracket_is_at_the_end_of_a_line_it_repositions_the_caretLocation_correctly() {
        let textInAXFocusedElement = """
hehe
this is < a funny >
one hehe
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(times: 2, on: $0) }

        let accessibilityElement = applyMoveBeingTested(using: .leftChevron)

        XCTAssertEqual(accessibilityElement.caretLocation, 12)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
    }

}
