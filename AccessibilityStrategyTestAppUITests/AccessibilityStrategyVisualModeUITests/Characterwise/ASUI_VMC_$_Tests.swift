import XCTest
import KeyCombination
import AccessibilityStrategy


class ASUI_VMC_$_Tests: ASUI_VM_BaseTests {}


// Both
extension ASUI_VMC_$_Tests {
            
    func test_that_if_the_selection_spans_over_a_single_line_and_the_head_is_after_the_anchor_then_it_goes_to_the_end_of_the_line_and_extends_the_selection() {
        let textInAXFocusedElement = "hello world"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        app.textFields.firstMatch.typeKey(.leftArrow, modifierFlags: [.option])
        app.textFields.firstMatch.typeKey(.leftArrow, modifierFlags: [])
        
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.dollarSignForVisualStyleCharacterwise(on: $0) }

        XCTAssertEqual(accessibilityElement?.caretLocation, 5)
        XCTAssertEqual(accessibilityElement?.selectedLength, 6)
    }
    
    func test_that_if_the_selection_spans_over_a_single_line_and_the_head_is_before_the_anchor_then_it_goes_to_the_end_of_the_line_and_reduces_the_selection_until_the_anchor_and_then_extends_it_after() {
        let textInAXFocusedElement = """
$ for visual mode starts
at the anchor, not at the caret location
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        app.textViews.firstMatch.typeKey(.leftArrow, modifierFlags: [])
        
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.bForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.dollarSignForVisualStyleCharacterwise(on: $0) }

        XCTAssertEqual(accessibilityElement?.caretLocation, 57)
        XCTAssertEqual(accessibilityElement?.selectedLength, 8)
    }
    
}


// TextViews
extension ASUI_VMC_$_Tests {
    
    func test_that_if_line_ends_with_linefeed_it_goes_to_the_end_of_the_line_still() {
        let textInAXFocusedElement = """
indeed
that is
multiline
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        app.textViews.firstMatch.typeKey(.upArrow, modifierFlags: [])
        app.textViews.firstMatch.typeKey(.leftArrow, modifierFlags: [])
        app.textViews.firstMatch.typeKey(.leftArrow, modifierFlags: [.option])
        
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.dollarSignForVisualStyleCharacterwise(on: $0) }

        XCTAssertEqual(accessibilityElement?.caretLocation, 12)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }
    
    func test_that_if_the_selection_spans_over_multiple_lines_and_the_head_is_after_the_anchor_then_it_goes_to_the_end_of_the_line_where_the_head_is_located_and_extends_the_selection() {
        let textInAXFocusedElement = """
we gonna select
over multiple lines coz
$ doesn't work LOOOLL
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.eForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.eForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.dollarSignForVisualStyleCharacterwise(on: $0) }

        XCTAssertEqual(accessibilityElement?.caretLocation, 36)
        XCTAssertEqual(accessibilityElement?.selectedLength, 25)
    }

    func test_that_if_the_selection_spans_over_multiple_lines_and_the_head_is_before_the_anchor_then_it_goes_to_the_end_of_the_line_where_the_head_is_located_and_reduces_the_selection() {
        let textInAXFocusedElement = """
we gonna select
over multiple lines coz
$ doesn't work LOOOLL
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.bForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.kForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.dollarSignForVisualStyleCharacterwise(on: $0) }

        XCTAssertEqual(accessibilityElement?.caretLocation, 39)
        XCTAssertEqual(accessibilityElement?.selectedLength, 22)
    }
    
}


// emojis
extension ASUI_VMC_$_Tests {
    
    func test_that_it_handles_emojis() {
        let textInAXFocusedElement = """
wow now that 😂️😂️😂️ have to handle🙈️
    🍌️dd with the 🙈️🙈️🙈️🙈️
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.underscore(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.kForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.dollarSignForVisualStyleCharacterwise(on: $0) }

        XCTAssertEqual(accessibilityElement?.caretLocation, 40)
        XCTAssertEqual(accessibilityElement?.selectedLength, 8)
    }
    
}

