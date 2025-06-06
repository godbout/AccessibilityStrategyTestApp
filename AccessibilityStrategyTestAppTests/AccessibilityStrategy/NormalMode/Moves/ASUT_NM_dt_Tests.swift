@testable import AccessibilityStrategy
import XCTest
import Common


// see dF for blah blah
class ASUT_NM_dt_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(to character: Character, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: .auto)
        
        return asNormalMode.dt(to: character, on: element, &vimEngineState)
    }
    
}


// Both
extension ASUT_NM_dt_Tests {
    
    func test_that_if_the_character_is_not_found_then_it_does_nothing() {
        let text = """
gonna look
for a character
that is not there
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 44,
            caretLocation: 14,
            selectedLength: 1,
            selectedText: " ",
            fullyVisibleArea: 0..<14,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 2,
                start: 11,
                end: 27
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "z", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 14)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
