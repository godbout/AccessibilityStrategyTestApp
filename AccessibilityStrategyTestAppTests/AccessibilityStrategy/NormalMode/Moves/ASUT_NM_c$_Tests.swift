@testable import AccessibilityStrategy
import XCTest
import Common


// c$ calls ccg$. tests are there.
// here we do one test to make sure that c$ sends the right line parameter to ccg$.
class ASUT_NM_c$_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: .auto)
        
        return asNormalMode.cDollarSign(on: element, &vimEngineState) 
    }
    
}


extension ASUT_NM_c$_Tests {

    func test_that_a_FileLine_and_not_a_ScreenLine_is_sent_as_parameter_to_the_superman_move() {
        let text = """
so we need to type something longer here
to make sure that this is using the
correct type of line heheheheheheh
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 111,
            caretLocation: 52,
            selectedLength: 1,
            selectedText: """
        e
        """,
            fullyVisibleArea: 0..<111,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 111,
                number: 2,
                start: 41,
                end: 77
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 52)
        XCTAssertEqual(returnedElement.selectedLength, 24)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
   
}
