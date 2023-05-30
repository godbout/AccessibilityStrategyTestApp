import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_NM_cG__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(appFamily: AppFamily) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.cG(on: $0, &state) }
    }
    
}


// PGR and Electron
extension ASUI_NM_cG__Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
blah blah some line
some more
  haha geh
need to deal with
those faces 🥺️☹️😂️

"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.gj(on: $0) }
        applyMove { asNormalMode.gj(on: $0) }
        applyMove { asNormalMode.f(to: "g", on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
blah blah some line
some more
  
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 32)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
    }
    
}
