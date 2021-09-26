@testable import AccessibilityStrategy
import XCTest


// see [( for blah blah blah
class ASUT_NM_RightBrace_Tests: ASNM_BaseTests {
    
    private func applyMove(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.rightBrace(on: element) 
    }
    
}


// emojis
extension ASUT_NM_RightBrace_Tests {
    
    func test_that_it_returns_the_correct_caretLocation_and_selectedLength() {
        let text = """
y{ah 🤨️(🤨️ coz🤨️🤨️ the text 🤨️🤨️functions don't


care about😂️🤨️🤨️🤨️ the length but 🦋️ the move
itself d🤨️🤨️🤨️oes
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 127,
            caretLocation: 19,
            selectedLength: 3,
            selectedText: "🤨️",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 127,
                number: 1,
                start: 0,
                end: 54
            )
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 54)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
    }
    
}

