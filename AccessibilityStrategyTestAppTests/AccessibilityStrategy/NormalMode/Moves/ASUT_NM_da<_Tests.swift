@testable import AccessibilityStrategy
import XCTest
import Common


// see daB for blah blah
class ASNM_daLeftChevron_Tests: ASUT_NM_BaseTests {

    private func applyMove(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: .auto)
        
        return asNormalMode.daLeftChevron(on: element, &state)
    }
    
}


// Both
extension ASNM_daLeftChevron_Tests {

    func test_that_if_no_block_is_found_then_it_does_nothing() {
        let text = "no fucking block in here"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 24,
            caretLocation: 16,
            selectedLength: 1,
            selectedText: """
         
        """,
            fullyVisibleArea: 0..<24,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 24,
                number: 1,
                start: 0,
                end: 24
            )!
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 16)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}

