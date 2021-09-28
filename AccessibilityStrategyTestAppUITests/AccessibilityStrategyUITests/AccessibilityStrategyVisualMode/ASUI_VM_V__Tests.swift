import XCTest
import AccessibilityStrategy


// this is `V` when entering from NM
class ASUI_VM_V__Tests: ASUI_VM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0)}
    }
    
}


// Both
extension ASUI_VM_V__Tests {
    
    func test_that_it_selects_the_whole_line_even_if_it_does_not_end_with_a_linefeed() {
        let textInAXFocusedElement = "a sentence without a linefeed"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 29)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 0)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 28)
    }
    
}


// TextAreas
extension ASUI_VM_V__Tests {
       
    func test_that_if_we_just_entered_VisualMode_with_V_from_NormalMode_it_sets_the_anchor_and_caret_to_start_of_the_line_and_head_and_selection_to_end_of_line() {
        let textInAXFocusedElement = """
now that's one with
a linefeed at the end
!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
                
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 20)
        XCTAssertEqual(accessibilityElement?.selectedLength, 22)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 20)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 41)
    }
   
}
