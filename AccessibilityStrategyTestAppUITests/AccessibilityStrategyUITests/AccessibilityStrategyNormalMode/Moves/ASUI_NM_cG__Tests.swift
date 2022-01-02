import XCTest
@testable import AccessibilityStrategy


class ASUI_NM_cG__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.cG(on: $0, pgR: pgR) }
    }
    
}


// PGR
extension ASUI_NM_cG__Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
blah blah some line
some more
  haha geh
need to deal with
those faces 🥺️☹️😂️

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.gj(on: $0) }
        applyMove { asNormalMode.gj(on: $0) }
        applyMove { asNormalMode.f(to: "g", on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
blah blah some line
some more
 
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 31)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
    }
    
}
