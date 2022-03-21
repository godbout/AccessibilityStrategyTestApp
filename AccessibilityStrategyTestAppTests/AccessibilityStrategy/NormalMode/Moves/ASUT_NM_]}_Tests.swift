@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_rightBracketRightBrace_Tests: ASUT_NM_BaseTests {
    
    private func applyMove(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.rightBracketRightBrace(on: element) 
    }
    
}


// emojis
extension ASUT_NM_rightBracketRightBrace_Tests {
    
    func test_that_it_returns_the_correct_caretLocation_and_selectedLength() {
        let text = """
y{ah 🤨️(🤨️ coz🤨️🤨️ the text 🤨️🤨️functions don't
care about😂️🤨️🤨️🤨️ the length but 🦋️ the m)ove
itself d🤨️}🤨️🤨️oes
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 127,
            caretLocation: 19,
            selectedLength: 3,
            selectedText: "🤨️",
            visibleCharacterRange: 0..<127,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 127,
                number: 1,
                start: 0,
                end: 54
            )!
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 117)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }
    
}

