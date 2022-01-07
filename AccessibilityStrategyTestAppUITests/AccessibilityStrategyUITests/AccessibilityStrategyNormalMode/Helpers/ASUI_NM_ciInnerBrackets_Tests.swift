@testable import AccessibilityStrategy
import XCTest
import VimEngineState


class ASUI_NM_ciInnerBrackets_Tests: ASUI_NM_BaseTests {
       
    private func applyMoveBeingTested(using bracket: Character, pgR: Bool) -> AccessibilityTextElement {
        var state = VimEngineState(pgR: pgR)
        
        return applyMove { asNormalMode.ciInnerBrackets(using: bracket, on: $0, &state) }
    }
    
}


// PGR
extension ASUI_NM_ciInnerBrackets_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
this case is when { is not followed
by a linefeed and
     } is preceded by a linefeed
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.f(times: 2, to: "n", on: $0) }
        let accessibilityElement = applyMoveBeingTested(using: "{", pgR: true)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
this case is when 
     } is preceded by a linefeed
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 18)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}
