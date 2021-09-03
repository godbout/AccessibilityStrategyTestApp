import XCTest
import KeyCombination
import AccessibilityStrategy


class ASUI_VMC_l_Tests: ASUI_VM_BaseTests {}


// Both
extension ASUI_VMC_l_Tests {
    
    func test_that_if_the_selection_spans_over_a_single_line_and_the_head_is_after_the_anchor_then_it_goes_towards_the_end_of_the_line_and_extends_the_selection_by_one() {
        let textInAXFocusedElement = "hello world"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        app.textFields.firstMatch.typeKey(.leftArrow, modifierFlags: [.command])
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.eForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.lForVisualStyleCharacterwise(on: $0) }

        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 6)
    }
    
    func test_that_if_the_selection_spans_over_a_single_line_and_the_head_is_before_the_anchor_then_it_goes_towards_the_end_of_the_line_and_extends_the_selection_by_one() {
        let textInAXFocusedElement = """
here is some text for VM l
with head before anchor
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
              
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.bForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.lForVisualStyleCharacterwise(on: $0) }

        XCTAssertEqual(accessibilityElement?.caretLocation, 38)
        XCTAssertEqual(accessibilityElement?.selectedLength, 7)
    }
    
}


// TextViews
extension ASUI_VMC_l_Tests {
    
    func test_that_if_the_selection_spans_over_multiple_lines_and_the_head_is_after_the_anchor_then_it_goes_towards_the_end_of_the_line_and_extends_the_selection() {
        let textInAXFocusedElement = """
span over multiple lines
with head after anchor
for VM l
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        app.textViews.firstMatch.typeKey(.upArrow, modifierFlags: [.command])
              
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.dollarSignForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.eForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.lForVisualStyleCharacterwise(on: $0) }

        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 30)
    }
    
    func test_that_if_the_selection_spans_over_multiple_lines_and_the_head_is_before_the_anchor_then_it_goes_towards_the_end_of_the_line_and_reduces_the_selection() {
        let textInAXFocusedElement = """
span over multiple lines
with head before anchor
for VM l and that should
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        app.textViews.firstMatch.typeKey(.upArrow, modifierFlags: [])
       
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.zeroForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.bForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.lForVisualStyleCharacterwise(on: $0) }
                
        XCTAssertEqual(accessibilityElement?.caretLocation, 20)
        XCTAssertEqual(accessibilityElement?.selectedLength, 28)
    }
    
    func test_that_it_stops_at_the_end_of_lines_and_does_not_continue_moving_forward_on_the_next_lines_when_it_is_already_coming_from_a_line_above() {
        let textInAXFocusedElement = """
span over multiple lines
w askljaslkasdlfjak
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
                
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.zeroForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.bForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.dollarSignForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.lForVisualStyleCharacterwise(on: $0) }
      
        XCTAssertEqual(accessibilityElement?.caretLocation, 24)
        XCTAssertEqual(accessibilityElement?.selectedLength, 20)
    }
    
}


// emojis
extension ASUI_VMC_l_Tests {
    
    func test_that_it_handles_emojis_with_head_before_anchor() {
        let textInAXFocusedElement = """
wow now that 😂️😂️😂️ have to handle🙈️
    🍌️dd with the 🙈️🙈️🙈️🙈️
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
             
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.underscore(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.hForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.lForVisualStyleCharacterwise(on: $0) }

        XCTAssertEqual(accessibilityElement?.caretLocation, 48)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
    func test_that_it_handles_emojis_with_anchor_before_head() {
        let textInAXFocusedElement = """
wow now that 😂️😂️😂️ have to handle🙈️
    🍌️dd with the 🙈️🙈️🙈️🙈️
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
              
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.underscore(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.lForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.lForVisualStyleCharacterwise(on: $0) }

        XCTAssertEqual(accessibilityElement?.caretLocation, 44)
        XCTAssertEqual(accessibilityElement?.selectedLength, 5)
    }
    
    func test_that_it_add_to_the_selection_by_the_right_number_of_characters() {
        let textInAXFocusedElement = "wow now that 😂️😂️ hae"

        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
                
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.lForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.lForVisualStyleCharacterwise(on: $0) }

        XCTAssertEqual(accessibilityElement?.caretLocation, 13)
        XCTAssertEqual(accessibilityElement?.selectedLength, 7)
    }
    
}
