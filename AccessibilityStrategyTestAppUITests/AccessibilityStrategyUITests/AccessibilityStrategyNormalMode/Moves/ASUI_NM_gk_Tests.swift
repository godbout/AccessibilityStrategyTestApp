import XCTest
import AccessibilityStrategy


// check j for all the blah blah
class ASUI_NM_gk_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1) -> AccessibilityTextElement {
        return applyMove { asNormalMode.gk(times: count, on: $0) }
    }
    
}


// count
extension ASUI_NM_gk_Tests {

    func test_that_it_implements_the_count_system() {
        let textInAXFocusedElement = """
so we're gonna have
a 😂️ice couple
of lines and see
what that shit
does
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.dollarSign(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(times: 3)
        
        XCTAssertEqual(accessibilityElement.caretLocation, 22)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
        XCTAssertEqual(accessibilityElement.selectedText, "😂️")
    }
    
    func test_that_if_the_count_is_too_high_it_ends_up_on_the_first_line() {
        let textInAXFocusedElement = """
so we're gonna have
a nice couple
of lines and see
what that shit
doe😂️
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.dollarSign(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(times: 69)
        
        XCTAssertEqual(accessibilityElement.caretLocation, 2)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
    }
    
}


// TextViews
extension ASUI_NM_gk_Tests {

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

        XCTAssertEqual(accessibilityElement.caretLocation, 38)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
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

        XCTAssertEqual(accessibilityElement.caretLocation, 52)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
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
        XCTAssertEqual(firstK.caretLocation, 81)
        XCTAssertEqual(firstK.selectedLength, 1)

        let secondK = applyMoveBeingTested()
        XCTAssertEqual(secondK.caretLocation, 66)
        XCTAssertEqual(secondK.selectedLength, 1)

        let thirdK = applyMoveBeingTested()
        XCTAssertEqual(thirdK.caretLocation, 51)
        XCTAssertEqual(thirdK.selectedLength, 1)
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

        XCTAssertEqual(accessibilityElement.caretLocation, 0)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
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

        XCTAssertEqual(accessibilityElement.caretLocation, 42)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }

    func test_that_if_we_are_on_the_last_line_and_it_is_just_a_linefeed_we_can_still_go_up_and_follow_the_screenLineColumnNumber() {
        let textInAXFocusedElement = """
fucking hell
with the last line
empty

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.gj(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gj(on: $0) }
        applyMove { asNormalMode.gj(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.caretLocation, 33)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_if_the_ATE_screenLineColumnNumber_is_nil_k_goes_to_the_end_limit_of_the_previous_line() {
        let textInAXFocusedElement = """
and also to the end of the next next line!
coz used $ to go end of line📏️
globalColumnNumber is nil
"""

        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.dollarSign(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.caretLocation, 96)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        
        let secondPass = applyMoveBeingTested()
                
        XCTAssertEqual(secondPass.caretLocation, 71)
        XCTAssertEqual(secondPass.selectedLength, 3)
    }
    
}


// emojis
// see j for blah blah
extension ASUI_NM_gk_Tests {}
