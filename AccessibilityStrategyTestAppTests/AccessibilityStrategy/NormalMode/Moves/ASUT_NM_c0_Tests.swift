@testable import AccessibilityStrategy
import XCTest
import Common


// see c$ for blah blah
class ASUT_NM_c0_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: .auto)
        
        return asNormalMode.cZero(on: element, &state) 
    }
    
}


extension ASUT_NM_c0_Tests {

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
            caretLocation: 73,
            selectedLength: 1,
            selectedText: """
        t
        """,
            fullyVisibleArea: 0..<111,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 111,
                number: 4,
                start: 64,
                end: 77
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 41)
        XCTAssertEqual(returnedElement.selectedLength, 32)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
   
}
