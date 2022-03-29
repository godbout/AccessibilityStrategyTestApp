@testable import AccessibilityStrategy
import XCTest


// see [( for blah blah blah
class ASUT_NM_leftBracketLeftBrace_Tests: ASUT_NM_BaseTests {
    
    private func applyMove(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.leftBracketLeftBrace(on: element) 
    }
    
}


// emojis
extension ASUT_NM_leftBracketLeftBrace_Tests {
    
    func test_that_it_returns_the_correct_caretLocation_and_selectedLength() {
        let text = """
y{ah 🤨️(🤨️ coz🤨️🤨️ the text 🤨️🤨️functions don't
care about😂️🤨️🤨️🤨️ the length but 🦋️ the move
itself d🤨️🤨️🤨️oes
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 125,
            caretLocation: 110,
            selectedLength: 1,
            selectedText: "f",
            fullyVisibleArea: 0..<125,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 125,
                number: 3,
                start: 105,
                end: 125
            )!
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 1)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }
    
}

