@testable import AccessibilityStrategy
import XCTest


// same as b
// using TE function here that is tested heavily
// rest of the test in UI to check for updated globalColumnNumber
class ASNM_B__Tests: ASNM_BaseTests {
    
    private func applyMove(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.B(on: element) 
    }
    
}


// emojis
extension ASNM_B__Tests {
    
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
            caretLocation: 64,
            selectedLength: 1,
            selectedText: "t",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 84,
                number: 2,
                start: 34,
                end: 73
            )
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.selectedLength, 3)
    }
    
}

