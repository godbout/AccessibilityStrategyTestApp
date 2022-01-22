@testable import AccessibilityStrategy
import XCTest
import Common


// most tests in UIT coz delete/paste and PGR
class ASUT_NM_J__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.J(on: element, VimEngineState(appFamily: .auto))
    }
    
}


// Both
extension ASUT_NM_J__Tests {
    
    func test_that_if_the_character_is_not_found_then_it_does_nothing() {
        let text = """
hehe no linefeed here mofo
"""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 26,
            caretLocation: 15,
            selectedLength: 1,
            selectedText: "d",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 26,
                number: 1,
                start: 0,
                end: 26
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 15)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}

