import XCTest
@testable import AccessibilityStrategy


// we don't test ci[, ci{ and ci)]} because in KVE it's copy/pasted.
// we have UI Tests here for when the opening bracket is followed by a linefeed.
// this is because we need to call AX.lineFor to get info about the
// next line. that's the only case where we need UI tests. the rest is in UT.
class ASUI_NM_ciLeftParenthesis_Tests: ASUI_NM_BaseTests {

    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asNormalMode.ciLeftParenthesis(on: $0) }
    }

}


// TextViews
extension ASUI_NM_ciLeftParenthesis_Tests {

    func test_that_in_normal_setting_it_can_delete_the_content_between_brackets() {
        let textInAXFocusedElement = """
hehe (
some bs
some more
)
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.fileText.value, """
hehe (

)
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 7)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
    }

    func test_that_in_the_case_where_it_leaves_an_empty_line_between_the_brackets_it_positions_the_cursor_according_to_the_first_non_blank_of_the_first_line_that_is_after_the_opening_bracket() {
        let textInAXFocusedElement = """
now that shit will get cleaned (
    and the non blank
  will be respected!
)
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.fileText.value, """
now that shit will get cleaned (
    
)
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 37)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
    }

    func test_that_if_the_opening_bracket_is_immediately_followed_by_a_linefeed_the_linefeed_is_not_deleted() {
        let textInAXFocusedElement = """
this work when (
is followed by a linefeed
and ) is not preceded by a linefeed
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.fileText.value, """
this work when (
) is not preceded by a linefeed
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 17)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
    }

    func test_that_if_the_opening_bracket_is_immediately_followed_by_a_linefeed_and_the_closing_bracket_is_immediately_preceded_by_a_linefeed_then_the_move_keeps_an_empty_line_between_the_brackets() {
        let textInAXFocusedElement = """
this case is when (
is followed by a linefeed and
) is preceded by a linefeed
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.fileText.value, """
this case is when (

) is preceded by a linefeed
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 20)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
    }

}
