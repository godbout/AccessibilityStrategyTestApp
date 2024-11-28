import XCTest
import AccessibilityStrategy
import Common


class ASUI_VML_o_Tests: ASUI_VM_BaseTests {

    var state = VimEngineState(visualStyle: .characterwise)
    
    
    private func applyMoveBeingTested() -> AccessibilityTextElement {
        return applyMove { asVisualMode.o(on: $0) }
    }
    
}


// Both
extension ASUI_VML_o_Tests {
    
    func test_that_the_globalColumnNumbers_get_updated() {
        let textInAXFocusedElement = """
when using o whether in Characterwise or Linewise
the globalColumnNumbers have to get recalculated!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asVisualMode.VFromNormalMode(on: $0) }
        
        let fileLineColumnNumber = AccessibilityTextElement.fileLineColumnNumber
        let screenLineColumnNumber = AccessibilityTextElement.screenLineColumnNumber
                
        _ = applyMoveBeingTested()
                
        XCTAssertNotEqual(AccessibilityTextElement.fileLineColumnNumber, fileLineColumnNumber)
        XCTAssertNotEqual(AccessibilityTextElement.screenLineColumnNumber, screenLineColumnNumber)
    }

}
