@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_rightBracketRightParenthesis_Tests: ASUT_NM_BaseTests {
    
    private func applyMove(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.rightBracketRightParenthesis(on: element) 
    }
    
}


// emojis
extension ASUT_NM_rightBracketRightParenthesis_Tests {
    
    func test_that_it_returns_the_correct_caretLocation_and_selectedLength() {
        let text = """
y{ah 🤨️(🤨️ coz🤨️🤨️ the text 🤨️🤨️functions don't
care about😂️🤨️🤨️🤨️ the length but 🦋️ the m)ove
itself d🤨️🤨️🤨️oes
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 126,
            caretLocation: 14,
            selectedLength: 0,
            selectedText: "",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 126,
                number: 1,
                start: 0,
                end: 54
            )!
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 101)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
    }
    
}

