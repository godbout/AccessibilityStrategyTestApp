@testable import AccessibilityStrategy
import XCTest
import Common


// 1. dF is calling cF, and reposition the block cursor. cF uses F. all tested.
// 2. here in UT we can test the case where the character is not found, and therefore
// nothing is deleted.
// for the cases where a character is found, text is deleted and the block cursor have to
// be recalculated, those tests are in UI.
class ASUT_NM_dF__Tests: ASUT_NM_BaseTests {
    
    private func applyMove(to character: Character, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: .auto)
        
        return asNormalMode.dF(to: character, on: element, &state)
    }
    
}


// Both
extension ASUT_NM_dF__Tests {

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
            fullyVisibleArea: 0..<44,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 2,
                start: 11,
                end: 27
            )!
        )
        
        let returnedElement = applyMove(to: "z", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 14)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
