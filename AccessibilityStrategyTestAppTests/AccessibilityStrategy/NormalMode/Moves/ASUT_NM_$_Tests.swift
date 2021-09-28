import XCTest
@testable import AccessibilityStrategy


// $ uses TE endOfLine. the location is fully tested there.
// here we check the rest, i.e. length and text.
class ASUT_NM_$_Tests: ASNM_BaseTests {
    
    private func applyMove(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.dollarSign(on: element) 
    }
    
}


// Both
extension ASUT_NM_$_Tests {

    func test_that_it_ends_at_the_right_place_and_handles_emojis_too() {
        let text = """
here we go with the $
that goes at the en😀️
of a real line!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 60,
            caretLocation: 29,
            selectedLength: 1,
            selectedText: "e",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 60,
                number: 2,
                start: 22,
                end: 45
            )
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 41)
        XCTAssertEqual(returnedElement?.selectedLength, 3)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
