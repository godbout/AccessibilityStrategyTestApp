import XCTest
import AccessibilityStrategy
import Common


// this is `V` when entering from NM
class ASUT_VM_V__Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asVisualMode.VFromNormalMode(on: element)
    }
    
}


// Both
extension ASUT_VM_V__Tests {
    
    func test_that_it_selects_the_whole_line_even_if_it_does_not_end_with_a_linefeed() {
        let text = "a sentence without a linefeed"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 29,
            caretLocation: 28,
            selectedLength: 1,
            selectedText: "d",
            fullyVisibleArea: 0..<29,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 29,
                number: 1,
                start: 0,
                end: 29
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 29)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 0)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 28)
    }
    
}


// TextAreas
extension ASUT_VM_V__Tests {
       
    func test_that_if_we_just_entered_VisualMode_with_V_from_NormalMode_it_sets_the_anchor_and_caret_to_start_of_the_line_and_head_and_selection_to_end_of_line() {
        let text = """
now that's one with
a linefeed at the end
!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 43,
            caretLocation: 20,
            selectedLength: 1,
            selectedText: "a",
            fullyVisibleArea: 0..<43,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 43,
                number: 3,
                start: 20,
                end: 31
            )!
        )
                
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 20)
        XCTAssertEqual(returnedElement.selectedLength, 22)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 20)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 41)
    }
   
}
