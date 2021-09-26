@testable import AccessibilityStrategy
import XCTest


// this move is mainly using the TextEngine.firstNonBlank function
// so most of the tests are there. we still need to test here that if the
// caret location is at the end of the line, it doesn't crash.
// and of course as usual, testing the block cursor status.
class ASUI_NM_I__Tests: ASNM_BaseTests {
    
    private func applyMove(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.I(on: element) 
    }
    
}


// emojis
extension ASUI_NM_I__Tests {
    
    func test_that_it_handles_emojis() {
        let text = """
need to deal with
🐐️hose💨️💨️💨️ faces 🥺️☹️😂️ h😀️ha
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 56,
            caretLocation: 39,
            selectedLength: 1,
            selectedText: "s",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 56,
                number: 2,
                start: 18,
                end: 56
            )
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 18)    
        XCTAssertEqual(returnedElement?.selectedLength, 0)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}


