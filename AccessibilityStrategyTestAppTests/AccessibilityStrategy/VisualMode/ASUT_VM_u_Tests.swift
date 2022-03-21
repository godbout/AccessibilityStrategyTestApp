import XCTest
import AccessibilityStrategy
import Common


class ASUT_VM_u_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asVisualMode.u(on: element)
    }
    
}


extension ASUT_VM_u_Tests {
    
    func test_that_the_it_just_goes_back_to_the_caretLocation() {
        let text = """
Vm u is a move that just drops
what 😂️t was doing and the block cursor
goes back to caretLocation whether in Characterwise
or Linewise style.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 142,
            caretLocation: 36,
            selectedLength: 97,
            selectedText: """
😂️t was doing and the block cursor
goes back to caretLocation whether in Characterwise
or Linewis
""",
            visibleCharacterRange: 0..<142,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 142,
                number: 2,
                start: 31,
                end: 72
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 36)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
