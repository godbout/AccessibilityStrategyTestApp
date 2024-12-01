@testable import AccessibilityStrategy
import XCTest
import Common


// see `caB` for blah blah
class ASUT_NM_caLeftBracket_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState()
        
        return asNormalMode.caLeftBracket(on: element, &vimEngineState)
    }
    
}


extension ASUT_NM_caLeftBracket_Tests {

    func test_that_it_calls_cABlock_with_the_correct_bracket_as_parameter() {
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
        copyToClipboard(text: "some fake shit")
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 15)
        XCTAssertEqual(returnedElement.selectedLength, 35)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
}
