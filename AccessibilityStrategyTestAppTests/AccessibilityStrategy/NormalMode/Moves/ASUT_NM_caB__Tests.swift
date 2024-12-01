@testable import AccessibilityStrategy
import XCTest
import Common


// calling cABlock, all the tests are there.
// here we just have one test to check that we're calling cABlock with the right bracket.
// there's also one UI Tests for cABlock, to check that we pass the pgR correctly to cABlock.
class ASUT_NM_caB__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState()
        
        return asNormalMode.caB(on: element, &vimEngineState)
    }
    
}


extension ASUT_NM_caB__Tests {

    func test_that_it_calls_cABlock_with_the_correct_bracket_as_parameter() {
        let text = "now th😄️at is { some stuff 😄️😄️😄️on the same } line😄️"
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
