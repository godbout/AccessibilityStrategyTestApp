import XCTest
import AccessibilityStrategy


class ASUI_VMC_k_Tests: ASUI_VM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asVisualMode.kForVisualStyleCharacterwise(on: $0)}
    }

}


// TextFields
extension ASUI_VMC_k_Tests {
    
    func test_that_in_TextFields_it_does_nothing() {
        let textInAXFocusedElement = "VM jk in TextFields will do nothing"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 28)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
}


// TextViews
extension ASUI_VMC_k_Tests {
    
    func test_that_if_the_head_is_before_the_anchor_then_it_goes_to_the_line_above_the_head_on_the_same_column_number_and_selects_from_that_new_head_location_to_the_anchor() {
        let textInAXFocusedElement = """
wow that one is
gonna rip my
ass off lol
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 10)
        XCTAssertEqual(accessibilityElement?.selectedLength, 17)
    }
    
    func test_that_if_the_head_is_after_the_anchor_and_both_are_on_the_same_line_then_it_goes_to_the_line_above_the_head_on_the_same_column_number_and_selects_from_that_new_head_location_to_the_anchor() {
        let textInAXFocusedElement = """
wow that one is
gonna rip my
ass off lol
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
       
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.eForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 4)
        XCTAssertEqual(accessibilityElement?.selectedLength, 13)
    }
    
    func test_that_if_the_head_is_after_the_anchor_and_both_are_not_on_the_same_line_and_the_new_head_location_is_after_the_anchor_then_it_goes_to_the_line_above_the_head_on_the_same_column_number_and_selects_from_the_anchor_to_that_new_head_location() {
        let textInAXFocusedElement = """
wow that one is
gonna rip my
ass off lol
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.eForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.jForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.eForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
       
        XCTAssertEqual(accessibilityElement?.caretLocation, 16)
        XCTAssertEqual(accessibilityElement?.selectedLength, 7)
    }
    
    func test_that_if_the_head_is_after_the_anchor_and_both_are_not_on_the_same_line_and_the_new_head_location_is_before_the_anchor_then_it_goes_to_the_line_above_the_head_on_the_same_column_number_and_selects_from_that_new_head_location_to_the_anchor() {
        let textInAXFocusedElement = """
wow that one is
gonna rip my
ass off lol
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.gDollarSignForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.eForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 18)
        XCTAssertEqual(accessibilityElement?.selectedLength, 9)
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
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.bForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.kForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.kForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 13)
        XCTAssertEqual(accessibilityElement?.selectedLength, 47)
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
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asVisualMode.kForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        // same test as NM k:
        // real location will depend on GlobalColumnNumber, so we test that it moved up that's all
        // we don't care where exactly on the previous line
        XCTAssertNotEqual(accessibilityElement?.caretLocation, 31)
        XCTAssertNotEqual(accessibilityElement?.selectedLength, 0)
    }
    
    func test_that_if_the_ATE_globalColumnNumber_is_nil_k_goes_to_the_end_limit_of_the_previous_line() {
        let textInAXFocusedElement = """
and also to the end of the next next line!
coz used $ to go end of line📏️
globalColumnNumber is nil
"""

        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.gDollarSignForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 74)
        XCTAssertEqual(accessibilityElement?.selectedLength, 24)
        
        let secondPass = applyMoveBeingTested()
                
        XCTAssertEqual(secondPass?.caretLocation, 42)
        XCTAssertEqual(secondPass?.selectedLength, 56)
        
        // see VMC j Tests for blah blah
        let applyJ = applyMove { asVisualMode.jForVisualStyleCharacterwise(on: $0) }
        
        XCTAssertEqual(applyJ?.caretLocation, 74)
        XCTAssertEqual(applyJ?.selectedLength, 24)

        let applyKAgain = applyMoveBeingTested()
        
        XCTAssertEqual(applyKAgain?.caretLocation, 42)
        XCTAssertEqual(applyKAgain?.selectedLength, 56)
    }
    
}
