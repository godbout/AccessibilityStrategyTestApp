@testable import AccessibilityStrategy
import XCTest
import Common


// see `ciB` for blahblah
class ASUT_NM_ciRightBracket_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState()
        
        return asNormalMode.ciRightBracket(on: element, &state)
    }
    
}


extension ASUT_NM_ciRightBracket_Tests {

    func test_that_it_calls_cInnerBlock_with_the_correct_bracket_as_parameter() {
        let text = "now th😄️at is [ some stuff 😄️😄️😄️on the same ] line😄️"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 58,
            caretLocation: 18,
            selectedLength: 1,
            selectedText: "o",
            fullyVisibleArea: 0..<58,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 58,
                number: 1,
                start: 0,
                end: 58
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 16)
        XCTAssertEqual(returnedElement.selectedLength, 33)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
}
