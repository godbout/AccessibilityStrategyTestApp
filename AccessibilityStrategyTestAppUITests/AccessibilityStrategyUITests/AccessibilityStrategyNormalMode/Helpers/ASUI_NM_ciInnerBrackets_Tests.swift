@testable import AccessibilityStrategy
import XCTest


class ASUI_NM_ciInnerBrackets_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(using bracket: Character, pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.ciInnerBrackets(using: bracket, on: $0, pgR: pgR) }
    }
    
}


// Both
extension ASUI_NM_ciInnerBrackets_Tests {
    
    func test_that_it_gets_the_content_between_two_brackets_on_a_same_line() {
        let textInAXFocusedElement = "now th😄️at is ( some stuff 😄️😄️😄️on the same ) line😄️"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.F(to: "(", on: $0) }
        applyMove { asNormalMode.f(to: "o", on: $0) }
        let accessibilityElement = applyMoveBeingTested(using: "(")
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "now th😄️at is () line😄️")
        XCTAssertEqual(accessibilityElement?.caretLocation, 16)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}


// TextViews
extension ASUI_NM_ciInnerBrackets_Tests {
  
    func test_that_it_gets_the_content_between_two_brackets_on_different_lines() {
        let textInAXFocusedElement = """
this case is when { is not followed
by a linefeed
and } is not preceded by a linefeed
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.f(to: "t", on: $0) }
        let accessibilityElement = applyMoveBeingTested(using: "{")
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "this case is when {} is not preceded by a linefeed")
        XCTAssertEqual(accessibilityElement?.caretLocation, 19)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }

    func test_that_if_the_closing_bracket_is_preceded_only_by_whitespaces_up_to_the_beginning_of_the_line_then_the_previous_line_linefeed_is_not_deleted() {
        let textInAXFocusedElement = """
this case is when { is not followed
by a linefeed and
     } is preceded by a linefeed
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.f(times: 2, to: "n", on: $0) }
        let accessibilityElement = applyMoveBeingTested(using: "{")
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
this case is when {
     } is preceded by a linefeed
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 19)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
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
        let accessibilityElement = applyMoveBeingTested(using: "(")

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
this work when [
is followed by a linefeed
and ] is not preceded by a linefeed
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.ge(on: $0) }
        let accessibilityElement = applyMoveBeingTested(using: "[")

        XCTAssertEqual(accessibilityElement?.fileText.value, """
this work when [
] is not preceded by a linefeed
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
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        let accessibilityElement = applyMoveBeingTested(using: "(")

        XCTAssertEqual(accessibilityElement?.fileText.value, """
this case is when (

) is preceded by a linefeed
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 20)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
    }

}


// PGR
extension ASUI_NM_ciInnerBrackets_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
this case is when { is not followed
by a linefeed and
     } is preceded by a linefeed
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.f(times: 2, to: "n", on: $0) }
        let accessibilityElement = applyMoveBeingTested(using: "{", pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
this case is when 
     } is preceded by a linefeed
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 18)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}
