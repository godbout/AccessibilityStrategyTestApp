@testable import AccessibilityStrategy
import XCTest
import Common


// see di' for blah blah
class ASNM_diDoubleQuote_Tests: ASUT_NM_BaseTests {

    private func applyMove(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: .auto)
        
        return asNormalMode.diDoubleQuote(on: element, &vimEngineState)
    }
    
}


// Both
extension ASNM_diDoubleQuote_Tests {

    func test_that_if_no_innerQuotedString_is_found_then_it_does_nothing() {
        let text = "those shits work on \" single lines not on multiple lines"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 56,
            caretLocation: 24,
            selectedLength: 1,
            selectedText: """
        n
        """,
            fullyVisibleArea: 0..<56,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 56,
                number: 1,
                start: 0,
                end: 56
            )!
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 24)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}

