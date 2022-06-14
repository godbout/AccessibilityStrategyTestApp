@testable import AccessibilityStrategy
import XCTest
import Common


// calling cInnerBlock, all the tests are there.
// here we just have one test to check that we're calling cInnerBlock with the right bracket.
// there's also one UI Tests for cInnerBlock, to check that we pass the pgR correctly to cInnerBlock.
class ASUT_NM_ciB__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState()
        
        return asNormalMode.ciB(on: element, &state)
    }
    
}


extension ASUT_NM_ciB__Tests {

    func test_that_it_calls_cInnerBlock_with_the_correct_bracket_as_parameter() {
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
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 16)
        XCTAssertEqual(returnedElement.selectedLength, 33)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
}
