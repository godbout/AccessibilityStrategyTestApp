import XCTest
import KeyCombination
import AccessibilityStrategy


class ASUI_VML_j_Tests: ASUI_VM_BaseTests {}


// TextFields
extension ASUI_VML_j_Tests {
    
    func test_that_in_TextFields_basically_it_does_nothing() {
        let textInAXFocusedElement = "hehe you little fucker"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        app.textFields.firstMatch.typeKey(.leftArrow, modifierFlags: [.option])
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.jForVisualStyleLinewise(on: $0) }

        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 22)
    }
    
}


// TextViews
extension ASUI_VML_j_Tests {
    
    // we go down twice coz once worked but twice didn't hehe :))
    func test_that_if_the_head_is_after_the_anchor_then_it_extends_the_selection_by_one_line_below_at_a_time() {
        let textInAXFocusedElement = """
so pressing j in
Visual Mode is gonna be
cool because it will extend
the selection
when the head is after the anchor
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        app.textViews.firstMatch.typeKey(.upArrow, modifierFlags: [.command])
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }

        let accessibilityElement = applyMove { asVisualMode.jForVisualStyleLinewise(on: $0) }

        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 41)
        
        let finalAccessibilityElementHehe = applyMove { asVisualMode.jForVisualStyleLinewise(on: $0) }
       
        XCTAssertEqual(finalAccessibilityElementHehe?.caretLocation, 0)
        XCTAssertEqual(finalAccessibilityElementHehe?.selectedLength, 69)
    }
    
    func test_that_if_the_head_is_before_the_anchor_then_it_reduces_the_selection_by_one_line_below_at_a_time() {
        let textInAXFocusedElement = """
so pressing j in
Visual Mode is gonna be
cool because it will reduce
the selection when the
head if before the anchor
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
               
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.kForVisualStyleLinewise(on: $0) }
        applyMove { asVisualMode.kForVisualStyleLinewise(on: $0) }
        applyMove { asVisualMode.kForVisualStyleLinewise(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.jForVisualStyleLinewise(on: $0) }

        XCTAssertEqual(accessibilityElement?.caretLocation, 41)
        XCTAssertEqual(accessibilityElement?.selectedLength, 76)
        
        let finalAccessibilityElementHehe = applyMove { asVisualMode.jForVisualStyleLinewise(on: $0) }
        
        XCTAssertEqual(finalAccessibilityElementHehe?.caretLocation, 69)
        XCTAssertEqual(finalAccessibilityElementHehe?.selectedLength, 48)
    }
    
    func test_that_it_does_not_skip_empty_lines() {
        let textInAXFocusedElement = """
wow that one is

ass off lol
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        let accessibilityElement = applyMove { asVisualMode.jForVisualStyleLinewise(on: $0) }

        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 17)
    }
    
}


// emojis
// from what i see, no emojis issues with Linewise
extension ASUI_VML_j_Tests {}
