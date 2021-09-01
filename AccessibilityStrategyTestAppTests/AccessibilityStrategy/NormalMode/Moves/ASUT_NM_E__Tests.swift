@testable import AccessibilityStrategy
import XCTest


// see b for blah blah
class ASNM_E__Tests: ASNM_BaseTests {
    
    private func applyMove(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.E(on: element) 
    }
    
}


// emojis
extension ASNM_E__Tests {
    
    func test_that_it_returns_the_correct_selectedLength() {
        let text = """
yeah coz the text functions don't
care about the length but 🦋️ the move
itself does
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 84,
            caretLocation: 58,
            selectedLength: 1,
            selectedText: "t",
            currentLine: AccessibilityTextElementLine(
                fullValue: text,
                number: 2,
                start: 34,
                end: 73
            )
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.selectedLength, 3)
    }
    
}

