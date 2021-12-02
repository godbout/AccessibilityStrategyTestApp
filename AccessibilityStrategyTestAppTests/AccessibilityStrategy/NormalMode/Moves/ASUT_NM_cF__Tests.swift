@testable import AccessibilityStrategy
import XCTest


// now the `c` moves need to be tested in UI because of the PGR tweak.
// here we still keep the stuff that obviously don't need to go through the whole UI process,
// like when the move does nothing. LOL (e.g. because it can't find the character asked for, etc.)
class ASUT_NM_cF__Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(to character: Character, on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.cF(to: character, on: element, pgR: false)
    }
    
}


extension ASUT_NM_cF__Tests {
    
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 2,
                start: 11,
                end: 27
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "z", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 14)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
