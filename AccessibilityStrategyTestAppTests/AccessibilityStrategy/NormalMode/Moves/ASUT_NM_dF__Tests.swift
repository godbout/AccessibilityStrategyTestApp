@testable import AccessibilityStrategy
import XCTest


// 1. using the move F internally, so just a few tests needed here.
// 2. here in UT we can test the case where the character is not found, and therefore
// nothing is deleted.
// for the cases where a character is found, text is deleted and the block cursor have to
// be recalculated, those tests are in UI.
class ASNM_dF__Tests: ASNM_BaseTests {
    
    private func applyMove(to character: Character, on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.dF(to: character, on: element) 
    }
    
}


// Both
extension ASNM_dF__Tests {

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
            currentLine: AccessibilityTextElementLine(
                fullValue: text,
                number: 2,
                start: 11,
                end: 27
            )
        )
        
        let returnedElement = applyMove(to: "z", on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 14)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
