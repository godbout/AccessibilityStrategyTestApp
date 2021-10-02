@testable import AccessibilityStrategy
import XCTest


// this move just calls the firstNonBlank cp on FileLine. tests are there.
// here we only need to test that emojis work, selectedLength, and that the move
// works on FileLines and not ScreenLines.
class ASUI_NM_I__Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.I(on: element) 
    }
    
}


// line
extension ASUI_NM_I__Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
  this move stops at screen lines, which         🇧🇶️eans it will
  stop even without a linefeed. that's         how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 132,
            caretLocation: 54,
            selectedLength: 1,
            selectedText: "e",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 132,
                number: 2,
                start: 35,
                end: 67
            )
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 2)
        XCTAssertEqual(returnedElement?.selectedLength, 0)
        XCTAssertNil(returnedElement?.selectedText)
    }
     
}
