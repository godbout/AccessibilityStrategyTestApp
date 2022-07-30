@testable import AccessibilityStrategy
import XCTest


// this move uses FT beginningOfSentenceForward. all tests are there.
// here we just have to check we get proper caretLocation and selectedLength
class ASUT_NM_rightParenthesis_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.rightParenthesis(on: element) 
    }
    
}


// emojis
extension ASUT_NM_rightParenthesis_Tests {
    
    func test_that_it_returns_the_correct_caretLocation_and_selectedLength() {
        let text = """
y{ah 🤨️(🤨️ coz🤨️🤨️ the text 🤨️🤨️functions don't
care about😂️🤨️🤨️🤨️ the length but. 🦋️ the move
itself d🤨️🤨️🤨️oes
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 126,
            caretLocation: 19,
            selectedLength: 3,
            selectedText: """
        🤨️
        """,
            fullyVisibleArea: 0..<126,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 126,
                number: 1,
                start: 0,
                end: 54
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 93)
        XCTAssertEqual(returnedElement.selectedLength, 3)
    }
    
}
