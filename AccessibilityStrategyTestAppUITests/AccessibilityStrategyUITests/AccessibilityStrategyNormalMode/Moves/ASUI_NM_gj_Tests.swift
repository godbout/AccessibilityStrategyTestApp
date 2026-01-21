import XCTest
import AccessibilityStrategy


// see j for blah blah
class ASUI_NM_gj_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1) -> AccessibilityTextElement {
        return applyMove { asNormalMode.gj(times: count, on: $0) }
    }
    
}


// count
extension ASUI_NM_gj_Tests {

    func test_that_it_implements_the_count_system() {
        let textInAXFocusedElement = """
so we're gonna have
a nice couple
of lines and see
what that shit
does
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(times: 3)
        
        XCTAssertEqual(accessibilityElement.caretLocation, 54)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "t")
    }
    
    func test_that_if_the_count_is_too_high_it_ends_up_on_the_last_line() {
        let textInAXFocusedElement = """
so we're gonna have
a nice couple
of lines and see
what that shit
doe😂️
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(times: 69)
        
        XCTAssertEqual(accessibilityElement.caretLocation, 69)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
        XCTAssertEqual(accessibilityElement.selectedText, "😂️")
    }
    
}


// TextViews
extension ASUI_NM_gj_Tests {

    func test_that_in_normal_setting_j_goes_to_the_next_line_at_the_same_column() {
        let textInAXFocusedElement = """
let the fun
begin with the
crazy line and
column shit
"""

        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.e(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.caretLocation, 14)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }

    func test_that_if_the_next_line_is_shorter_j_goes_to_the_end_of_line_limit_of_that_next_line() {
        let textInAXFocusedElement = """
a line
but this one is much longer
and this one shorter
let's see
"""

        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.e(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.caretLocation, 64)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }

    func test_that_the_column_number_is_saved_and_reapplied_in_properly() {
        let textInAXFocusedElement = """
a line that is long
a shorter line
another long line longer than the first
another long line longer than all the other ones!!!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.f(to: "g", on: $0) }
       
        let firstJ = applyMoveBeingTested()
        XCTAssertEqual(firstJ.caretLocation, 33)
        XCTAssertEqual(firstJ.selectedLength, 1)

        let secondJ = applyMoveBeingTested()
        XCTAssertEqual(secondJ.caretLocation, 53)
        XCTAssertEqual(secondJ.selectedLength, 1)

        let thirdJ = applyMoveBeingTested()
        XCTAssertEqual(thirdJ.caretLocation, 73)
        XCTAssertEqual(thirdJ.selectedLength, 1)
    }
    
    func test_that_when_at_the_last_line_j_does_nothing() {
        let textInAXFocusedElement = """
at the last line
j should
shut up
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.caretLocation, 32)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_when_the_current_line_column_is_equal_to_the_next_line_length_and_that_this_line_is_not_the_last_one_the_caret_gets_at_the_correct_end_limit_of_the_next_line() {
        let textInAXFocusedElement = """
tryig somethi
some more
again
hehe
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.caretLocation, 27)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }

    func test_that_if_the_last_line_is_only_a_Newline_character_j_can_still_go_there_and_the_ColumnNumbers_are_not_overriden() {
        let textInAXFocusedElement = """
another fucking
edge case

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
                
        let fileLineColumnNumber = AccessibilityTextElement.fileLineColumnNumber
        let screenLineColumnNumber = AccessibilityTextElement.screenLineColumnNumber
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.caretLocation, 26)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(fileLineColumnNumber, AccessibilityTextElement.fileLineColumnNumber)
        XCTAssertEqual(screenLineColumnNumber, AccessibilityTextElement.screenLineColumnNumber)
    }
    
    func test_that_if_the_ATE_screenLineColumnNumber_is_nil_j_goes_to_the_end_limit_of_the_next_line() {
        let textInAXFocusedElement = """
globalColumnNumber is nil
coz used $ to go end of line📏️
and also to the end of the next next line!
"""

        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.dollarSign(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.caretLocation, 49)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        
        let secondPass = applyMoveBeingTested()
        
        XCTAssertEqual(secondPass.caretLocation, 54)
        XCTAssertEqual(secondPass.selectedLength, 3)
    }
    
}


// emojis
// unfortunately for now we not gonna test for j and k because i don't know how to handle
// with the screenLineColumnNumber
extension ASUI_NM_gj_Tests {}
