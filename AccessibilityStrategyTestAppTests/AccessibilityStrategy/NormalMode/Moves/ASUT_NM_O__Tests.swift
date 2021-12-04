@testable import AccessibilityStrategy
import XCTest


// one test here when O shouldn't do anything in TextViews. all the rest in UI coz PGR.
class ASUT_NM_O__Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.O(on: element, pgR: false) 
    }
    
}


// TextFields
extension ASUT_NM_O__Tests {
    
    func test_that_for_a_TextField_it_does_nothing() {
        let text = "O shouldn't do anything in a TextField!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 39,
            caretLocation: 23,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 39,
                number: 1,
                start: 0,
                end: 39
            )!
        )
        
		let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
