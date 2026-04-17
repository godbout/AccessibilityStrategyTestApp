@testable import AccessibilityStrategy
import XCTest
import Common


// see c$ for blah blah
class ASUT_NM_cCaret_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: .auto)
        
        return asNormalMode.cCaret(on: element, &vimEngineState) 
    }
    
}


extension ASUT_NM_cCaret_Tests {

    func test_that_a_FileLine_and_not_a_ScreenLine_is_sent_as_parameter_to_the_superman_move() {
        let text = """
so we need to type something longer here
   to make sure that this is using the
correct type of line heheheheheheh
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 115,
            caretLocation: 73,
            selectedLength: 1,
            selectedText: """
        n
        """,
            fullyVisibleArea: 0..<115,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 4,
                start: 62,
                end: 80
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 44)
        XCTAssertEqual(returnedElement.selectedLength, 29)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
   
}
