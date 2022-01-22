import XCTest
import AccessibilityStrategy
import Common


// see gj for blah blah
class ASUI_VMC_gk_Tests: ASUI_VM_BaseTests {
    
    var state = VimEngineState(visualStyle: .characterwise)
    
    
    private func applyMoveBeingTested() -> AccessibilityTextElement {
        return applyMove { asVisualMode.gk(on: $0, state)}
    }

}


// TextViews
extension ASUI_VMC_gk_Tests {
    
    func test_that_if_the_head_is_before_the_anchor_then_it_goes_to_the_line_above_the_head_on_the_same_column_number_and_selects_from_that_new_head_location_to_the_anchor() {
        let textInAXFocusedElement = """
wow that one is gonna rip my ass off lol
and it's getting even harder now that
the wrapped lines and shit is understood
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.caretLocation, 78)
        XCTAssertEqual(accessibilityElement.selectedLength, 19)
    }
    
    func test_that_if_the_head_is_after_the_anchor_and_both_are_on_the_same_line_then_it_goes_to_the_line_above_the_head_on_the_same_column_number_and_selects_from_that_new_head_location_to_the_anchor() {
        let textInAXFocusedElement = """
wow that one is gonna rip my ass off lol
and it's getting even harder now that
the wrapped lines and shit is understood
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
       
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.e(on: $0, state) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.caretLocation, 65)
        XCTAssertEqual(accessibilityElement.selectedLength, 15)
    }
    
    func test_that_if_the_head_is_after_the_anchor_and_both_are_not_on_the_same_line_and_the_new_head_location_is_after_the_anchor_then_it_goes_to_the_line_above_the_head_on_the_same_column_number_and_selects_from_the_anchor_to_that_new_head_location() {
        let textInAXFocusedElement = """
wow that one is gonna rip my ass off lol
and it's getting even harder now that
the wrapped lines and shit is understood
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.e(on: $0, state) }
        applyMove { asVisualMode.gj(on: $0, state) }
        applyMove { asVisualMode.e(on: $0, state) }
        let accessibilityElement = applyMoveBeingTested()
       
        XCTAssertEqual(accessibilityElement.caretLocation, 79)
        XCTAssertEqual(accessibilityElement.selectedLength, 4)
    }
    
    func test_that_if_the_head_is_after_the_anchor_and_both_are_not_on_the_same_line_and_the_new_head_location_is_before_the_anchor_then_it_goes_to_the_line_above_the_head_on_the_same_column_number_and_selects_from_that_new_head_location_to_the_anchor() {
        let textInAXFocusedElement = """
wow that one is gonna rip my ass off lol
and it's getting even harder now that
the wrapped lines and shit is understood
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.gDollarSign(on: $0, state) }
        applyMove { asVisualMode.e(on: $0, state) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.caretLocation, 82)
        XCTAssertEqual(accessibilityElement.selectedLength, 15)
    }
    
    // see j for blah blah
    func test_that_it_keeps_track_of_the_column_number() {
        let textInAXFocusedElement = """
extra long one here
ass off lol
gonna rip my
wow that one is
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
              
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.b(on: $0, state) }
        applyMove { asVisualMode.gk(on: $0, state) }
        applyMove { asVisualMode.gk(on: $0, state) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.caretLocation, 13)
        XCTAssertEqual(accessibilityElement.selectedLength, 47)
    }
    
    func test_that_if_the_caret_is_at_the_last_character_of_the_TextElement_and_on_an_empty_line_it_works_and_selects_from_the_last_character_to_some_character_of_the_previous_line() {
        let textInAXFocusedElement = """
caret is on its
own empty
    line

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
               
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asVisualMode.gk(on: $0, state) }
        let accessibilityElement = applyMoveBeingTested()

        // same test as NM k:
        // real location will depend on screenLineColumnNumber, so we test that it moved up that's all
        // we don't care where exactly on the previous line
        XCTAssertNotEqual(accessibilityElement.caretLocation, 31)
        XCTAssertNotEqual(accessibilityElement.selectedLength, 0)
    }
    
    func test_that_if_the_ATE_ColumnNumbers_are_nil_k_goes_to_the_end_limit_of_the_previous_line() {
        let textInAXFocusedElement = """
and also to the end of the next next line!
coz used $ to go end of line📏️
globalColumnNumber is nil
"""

        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.dollarSign(on: $0, state) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.caretLocation, 75)
        XCTAssertEqual(accessibilityElement.selectedLength, 19)
        
        let secondPass = applyMoveBeingTested()
                
        XCTAssertEqual(secondPass.caretLocation, 74)
        XCTAssertEqual(secondPass.selectedLength, 2)
        
        // see VMC j Tests for blah blah
        let applyJ = applyMove { asVisualMode.gj(on: $0, state) }
        
        XCTAssertEqual(applyJ.caretLocation, 75)
        XCTAssertEqual(applyJ.selectedLength, 19)

        let applyKAgain = applyMoveBeingTested()
        
        XCTAssertEqual(applyKAgain.caretLocation, 74)
        XCTAssertEqual(applyKAgain.selectedLength, 2)
    }
    
}
