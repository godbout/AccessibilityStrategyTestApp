@testable import AccessibilityStrategy
import XCTest


// definitely UIT
class ASUT_NM_H__Tests: ASUT_NM_BaseTests {

    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.H(times: count, on: element) 
    }
    
}


// line
extension ASUT_NM_H__Tests {
    
    func test_that_it_sets_the_shouldScroll_to_false() {
        let text = """
this move does not stop at screen 🇫🇷️ines. it will just pass by
them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 119,
            caretLocation: 39,
            selectedLength: 1,
            selectedText: "i",
            visibleCharacterRange: 0..<119,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 119,
                number: 2,
                start: 39,
                end: 66
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertFalse(returnedElement.shouldScroll)
    }
     
}
