@testable import AccessibilityStrategy
import XCTest


// one test here when o shouldn't do anything in TextViews. all the rest in UI coz PGR.
class ASUT_NM_o_Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.o(on: element, pgR: false) 
    }
    
}


// TextFields
extension ASUT_NM_o_Tests {
    
    func test_that_for_a_TextField_it_does_nothing() {
        let text = "o shouldn't do anything in a TextField!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 39,
            caretLocation: 20,
            selectedLength: 1,
            selectedText: "i",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 39,
                number: 2,
                start: 15,
                end: 29
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
