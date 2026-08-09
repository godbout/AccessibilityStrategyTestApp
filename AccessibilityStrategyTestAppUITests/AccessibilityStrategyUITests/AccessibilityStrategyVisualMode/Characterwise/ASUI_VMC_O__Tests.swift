import XCTest
import AccessibilityStrategy
import Common


class ASUI_VMC_O_Tests: ASUI_VM_BaseTests {

    var vimEngineState = VimEngineState(visualStyle: .characterwise)
    
    
    private func applyMoveBeingTested() -> AccessibilityTextElement {
        return applyMove { asVisualMode.O(on: $0) }
    }
    
}


// TextFields and TextViews
extension ASUI_VMC_O_Tests {
    
    func test_that_the_globalColumnNumbers_get_updated() {
        let textInAXFocusedElement = """
when using O whether in Characterwise or Linewise
the globalColumnNunbers have to get recalculated!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.b(on: $0, vimEngineState) }
        
        let fileLineColumnNumber = AccessibilityTextElement.fileLineColumnNumber
        let screenLineColumnNumber = AccessibilityTextElement.screenLineColumnNumber
                
        _ = applyMoveBeingTested()
                
        XCTAssertNotEqual(AccessibilityTextElement.fileLineColumnNumber, fileLineColumnNumber)
        XCTAssertNotEqual(AccessibilityTextElement.screenLineColumnNumber, screenLineColumnNumber)
    }

}
