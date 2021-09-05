import XCTest
import KeyCombination
import AccessibilityStrategy
import AXEngine


// check j for all the blah blah
class ASUI_NM_k_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asNormalMode.k(on: $0) }
    }
    
}


// TextViews
extension ASUI_NM_k_Tests {

    func test_that_in_normal_setting_k_goes_to_the_previous_line_at_the_same_column() {
        let textInAXFocusedElement = """
so now we're
testing k and
it should go up
to the same column
"""

        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 38)
    }

    func test_that_if_the_previous_line_is_shorter_k_goes_to_the_end_of_line_limit_of_that_previous_line() {
        let textInAXFocusedElement = """
a line
shorter than
the previous shorter
than the previous shorter than...
"""

        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 39)
    }

    func test_that_the_column_number_is_saved_and_reapplied_properly() {
        let textInAXFocusedElement = """
first one is prettyyyyy long too
a pretty long line i would believe
a shorter line
another quite long line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
                
        let firstK = applyMoveBeingTested()
        XCTAssertEqual(firstK?.caretLocation, 81)

        let secondK = applyMoveBeingTested()
        XCTAssertEqual(secondK?.caretLocation, 51)

        let thirdK = applyMoveBeingTested()
        XCTAssertEqual(thirdK?.caretLocation, 18)
    }

    func test_that_when_at_the_first_line_k_does_nothing() {
        let textInAXFocusedElement = """
a the first line
k should do
nothing ankulay
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
    }

    func test_that_when_current_line_column_is_equal_to_previous_line_length_the_caret_ends_up_at_the_right_previous_line_end_limit() {
        let textInAXFocusedElement = """
weird bug when
current line column
is equal
to previ ous line length
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.dollarSign(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 42)
    }

    func test_that_if_we_are_on_the_last_line_and_it_is_just_a_linefeed_we_can_still_go_up_and_follow_the_globalColumnNumber() {
        let textInAXFocusedElement = """
fucking hell
with the last line
empty

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.j(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.j(on: $0) }
        applyMove { asNormalMode.j(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 33)
    }
    
}


// emojis
// see j for blah blah
extension ASUI_NM_k_Tests {}
