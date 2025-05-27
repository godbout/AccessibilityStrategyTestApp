@testable import AccessibilityStrategy
import XCTest
import Common


// same mindset as with dF.
// daB calls caB, then reposition caret.
// here in UT we can test when there's is no aBlock found, and therefore nothing is deleted.
// for the cases where aBlock is found, text is deleted and the block cursor has to be
// recalculated. this is tested in UI.
class ASUT_NM_daB__Tests: ASUT_NM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: .auto)
        
        return asNormalMode.daB(on: element, &vimEngineState)
    }
    
}


// Both
extension ASUT_NM_daB__Tests {

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
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 16)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
