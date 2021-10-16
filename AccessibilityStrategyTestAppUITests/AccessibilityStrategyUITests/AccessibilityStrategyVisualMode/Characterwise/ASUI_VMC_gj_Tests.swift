import XCTest
import AccessibilityStrategy


// test about returning nil for TF is done in UT.
class ASUI_VMC_gj_Tests: ASUI_VM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asVisualMode.gjForVisualStyleCharacterwise(on: $0)}
    }

}


// TextViews
extension ASUI_VMC_gj_Tests {
    
    func test_that_if_the_head_is_after_the_anchor_then_it_goes_to_the_line_below_the_head_on_the_same_column_number_and_selects_from_the_anchor_to_that_new_head_location() {
        let textInAXFocusedElement = """
wow that one is gonna rip my ass off lol
and it's getting even harder now that
the wrapped lines and shit is understood
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
                
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.eForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
               
        XCTAssertEqual(accessibilityElement?.caretLocation, 79)
        XCTAssertEqual(accessibilityElement?.selectedLength, 25)
    }
    
    func test_that_if_the_head_is_before_the_anchor_and_both_are_on_the_same_line_then_it_goes_to_the_line_below_the_head_on_the_same_column_number_and_selects_from_the_anchor_to_that_new_head_location() {
        let textInAXFocusedElement = """
wow that one is gonna rip my ass off lol
and it's getting even harder now that
the wrapped lines and shit is understood
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
                
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.bForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
               
        XCTAssertEqual(accessibilityElement?.caretLocation, 77)
        XCTAssertEqual(accessibilityElement?.selectedLength, 14)
    }
    
    func test_that_if_the_head_is_before_the_anchor_and_both_are_not_on_the_same_line_and_the_new_head_location_is_before_the_anchor_then_it_goes_to_the_line_below_the_head_on_the_same_column_number_and_selects_from_that_new_head_location_to_the_anchor() {
        let textInAXFocusedElement = """
wow that one is gonna rip my ass off lol
and it's getting even harder now that
the wrapped lines and shit is understood
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
                
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.gkForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.bForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 90)
        XCTAssertEqual(accessibilityElement?.selectedLength, 7)
    }
        
    func test_that_if_the_line_below_the_head_line_is_shorter_then_it_goes_to_the_end_of_that_line_and_does_not_spill_over_the_next_next_line() {
        let textInAXFocusedElement = """
wow that one is gonna rip my ass off
definitely
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.gDollarSignForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
      
        XCTAssertEqual(accessibilityElement?.caretLocation, 9)
        XCTAssertEqual(accessibilityElement?.selectedLength, 28)
    }
    
    func test_that_it_keeps_track_of_the_column_number() {
        let textInAXFocusedElement = """
wow that one is
gonna rip my
ass off lol
extra long one here
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
              
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.gjForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.gjForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 4)
        XCTAssertEqual(accessibilityElement?.selectedLength, 42)
    }
    
    func test_that_it_can_go_back_to_the_last_empty_line_if_the_Visual_Mode_started_from_there_which_means_if_the_anchor_is_there() {
        let textInAXFocusedElement = """
caret is on its
own empty
    line

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
              
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.gkForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 35)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
    }
    
    func test_that_it_does_not_go_back_to_the_last_empty_line_if_the_Visual_Mode_did_not_start_from_there_and_instead_selects_till_the_end_of_the_line() {
        let textInAXFocusedElement = """
caret is on its
own empty
    line

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        // /!\ NOT EQUAL
        XCTAssertNotEqual(accessibilityElement?.caretLocation, 35)
        XCTAssertNotEqual(accessibilityElement?.selectedLength, 0)
    }
    
    func test_that_if_the_ATE_ColumnNumbers_are_nil_j_goes_to_the_end_limit_of_the_next_line() {
        let textInAXFocusedElement = """
globalColumnNumber is nil
coz used $ to go end of line📏️
and also to the end of the next next line!
"""

        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
      
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.dollarSignForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 19)
        XCTAssertEqual(accessibilityElement?.selectedLength, 31)
        
        let secondPass = applyMoveBeingTested()
        
        XCTAssertEqual(secondPass?.caretLocation, 19)
        XCTAssertEqual(secondPass?.selectedLength, 39)
        
        // here we're actually testing that k works in this configuration (mix of j and k). probably would have been better
        // to have its own test cases but would double the number of tests (it's like the tests we have for
        // k but now with GCN being nil) and UI Tests are expensive and it's Sunday and that's enough.
        let applyK = applyMove { asVisualMode.gkForVisualStyleCharacterwise(on: $0) }
        
        XCTAssertEqual(applyK?.caretLocation, 19)
        XCTAssertEqual(applyK?.selectedLength, 31)

        let applyJAgain = applyMoveBeingTested()
        
        XCTAssertEqual(applyJAgain?.caretLocation, 19)
        XCTAssertEqual(applyJAgain?.selectedLength, 39)
    }
    
}
