@testable import AccessibilityStrategy
import XCTest
import Common


// same mindset as with dF.
// di' calls ci', then reposition the caret.
// here in UT we can test when there's is no innerQuotedString found, and therefore nothing is deleted.
// for the cases where a innerQuotedString is found, text is deleted and the block cursor has to be
// recalculated. this is tested in UI.
class ASNM_diSingleQuote_Tests: ASUT_NM_BaseTests {

    private func applyMove(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: .auto)
        
        return asNormalMode.diSingleQuote(on: element, &vimEngineState)
    }
    
}


// Both
extension ASNM_diSingleQuote_Tests {

    func test_that_if_no_innerQuotedString_is_found_then_it_does_nothing() {
        let text = "those shits work on ' single lines not on multiple lines"
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

