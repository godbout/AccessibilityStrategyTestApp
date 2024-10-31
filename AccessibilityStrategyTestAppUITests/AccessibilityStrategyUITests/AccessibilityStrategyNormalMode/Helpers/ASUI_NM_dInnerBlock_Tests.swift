@testable import AccessibilityStrategy
import XCTest
import Common



// this move uses FT innerBlock which is already tested on its own.
// FT innerBlock returns the range of the text found, but doesn't care if the text
// spans on a line or several (affects LYS, caretLocation, linefeed kept or not etc.) this is up to diB to handle this, which is
// what we need to test.
class ASUI_NM_dInnerBlock_Tests: ASUI_NM_BaseTests {

    private func applyMoveBeingTested(using openingBlock: OpeningBlockType, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return applyMove { asNormalMode.dInnerBlock(using: openingBlock, on: $0, &vimEngineState) }
    }

}


// Bip, copy deletion and LYS
// here it is way more complicated than other moves as diB may sometimes return Characterwise, sometimes Linewise.
// so for all the tests we're gonna test everything: caretLocation, selectedLength, selectedText, Bip, LYS, copy deletion.


// Both
extension ASUI_NM_dInnerBlock_Tests {

    func test_that_it_there_is_no_innerBlock_found_it_bips_and_does_not_copy_anything_and_does_not_change_the_LastYankStyle() {
        let textInAXFocusedElement = "no block here"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.b(on: $0) }

        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let accessibilityElement = applyMoveBeingTested(using: .leftBrace, &state)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
        XCTAssertEqual(accessibilityElement.fileText.value, "no block here")
        XCTAssertEqual(accessibilityElement.caretLocation, 9)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "h")

        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertEqual(state.lastMoveBipped, true)
    }

    func test_that_it_gets_the_content_between_two_brackets_on_a_same_line_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise() {
        let textInAXFocusedElement = "now th😄️at is ( some stuff 😄️😄️😄️on the same ) line😄️"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.b(times: 5, on: $0) }

        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let accessibilityElement = applyMoveBeingTested(using: .leftParenthesis, &state)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), " some stuff 😄️😄️😄️on the same ")
        XCTAssertEqual(accessibilityElement.fileText.value, "now th😄️at is () line😄️")
        XCTAssertEqual(accessibilityElement.caretLocation, 16)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, ")")

        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertEqual(state.lastMoveBipped, false)
    }

}


// TextViews
extension ASUI_NM_dInnerBlock_Tests {

    // this test contains blank spaces
    func test_that_it_gets_the_content_between_two_brackets_on_different_lines_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise() {
        let textInAXFocusedElement = """
this case is when { is not followed
by a linefeed
and } is not preceded by a linefeed
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(times: 2, on: $0) }

        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let accessibilityElement = applyMoveBeingTested(using: .leftBrace, &state)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
 is not followed
by a linefeed
and 
"""
        )
        XCTAssertEqual(accessibilityElement.fileText.value, "this case is when {} is not preceded by a linefeed")
        XCTAssertEqual(accessibilityElement.caretLocation, 19)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "}")

        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertEqual(state.lastMoveBipped, false)
    }

    func test_that_if_the_closing_bracket_is_preceded_only_by_whitespaces_up_to_the_beginning_of_the_line_then_the_previous_line_linefeed_is_not_deleted_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_the_caretLocation_ends_up_at_the_opening_bracket() {
        let textInAXFocusedElement = """
this case is when [ is not followed
by a linefeed and
     ] is preceded by a linefeed
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(times: 2, on: $0) }

        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let accessibilityElement = applyMoveBeingTested(using: .leftBracket, &state)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
 is not followed
by a linefeed and
"""
        )
        XCTAssertEqual(accessibilityElement.fileText.value, """
this case is when [
     ] is preceded by a linefeed
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 18)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "[")

        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertEqual(state.lastMoveBipped, false)
    }

    func test_that_in_the_case_where_ciB_leaves_an_empty_line_well_diB_does_not_and_it_does_not_Bip_and_sets_the_LastYankStyle_to_Linewise_and_the_caretLocation_ends_up_at_the_closing_bracket() {
        let textInAXFocusedElement = """
now that shit will get cleaned <
    and the non blank
  will be respected!
  >
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(times: 2, on: $0) }

        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let accessibilityElement = applyMoveBeingTested(using: .leftChevron, &state)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
    and the non blank
  will be respected!\n
"""
        )
        XCTAssertEqual(accessibilityElement.fileText.value, """
now that shit will get cleaned <
  >
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 35)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, ">")

        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertEqual(state.lastMoveBipped, false)
    }

    // this test contains blank spaces
    func test_that_if_the_opening_bracket_is_immediately_followed_by_a_linefeed_the_linefeed_is_not_deleted_and_it_does_not_Bip_and_it_sets_the_LastYankStyle_to_Characterwise_and_the_caretLocation_ends_up_at_the_closing_bracket() {
        let textInAXFocusedElement = """
this work when {
is followed by a linefeed
and } is not preceded by a linefeed
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(times: 2, on: $0) }

        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let accessibilityElement = applyMoveBeingTested(using: .leftBrace, &state)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
is followed by a linefeed
and 
"""
        )
        XCTAssertEqual(accessibilityElement.fileText.value, """
this work when {
} is not preceded by a linefeed
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 17)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "}")

        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertEqual(state.lastMoveBipped, false)
    }

    func test_that_if_the_opening_bracket_is_immediately_followed_by_a_linefeed_and_the_closing_bracket_is_immediately_preceded_by_a_linefeed_then_the_move_keeps_an_empty_line_between_the_brackets_and_it_does_not_Bip_and_it_sets_the_LastYankStyle_to_Linewise() {
        let textInAXFocusedElement = """
this case is when (
is followed by a linefeed and
) is preceded by a linefeed
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(times: 2, on: $0) }

        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let accessibilityElement = applyMoveBeingTested(using: .leftParenthesis, &state)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "is followed by a linefeed and\n")
        XCTAssertEqual(accessibilityElement.fileText.value, """
this case is when (
) is preceded by a linefeed
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 20)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, ")")

        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertEqual(state.lastMoveBipped, false)
    }

}


extension ASUI_NM_dInnerBlock_Tests {

    // this test contains blank spaces
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
this case is when { is not followed
by a linefeed
and } is not preceded by a linefeed
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(times: 2, on: $0) }

        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(appFamily: .pgR)
        let accessibilityElement = applyMoveBeingTested(using: .leftBrace, &state)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
 is not followed
by a linefeed
and 
"""
        )
        XCTAssertEqual(accessibilityElement.fileText.value, "this case is when {} is not preceded by a linefeed")
        XCTAssertEqual(accessibilityElement.caretLocation, 19)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "}")
    }

    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
this case is when { is not followed
by a linefeed
and } is not preceded by a linefeed
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(times: 2, on: $0) }

        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(appFamily: .pgR)
        let accessibilityElement = applyMoveBeingTested(using: .leftBrace, &state)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
 is not followed
by a linefeed
and 
"""
        )
        XCTAssertEqual(accessibilityElement.fileText.value, "this case is when {} is not preceded by a linefeed")
        XCTAssertEqual(accessibilityElement.caretLocation, 19)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "}")
    }

}
