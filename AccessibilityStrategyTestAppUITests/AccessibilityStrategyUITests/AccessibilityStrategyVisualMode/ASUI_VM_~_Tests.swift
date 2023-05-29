import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_VM_tilde_Tests: ASUI_VM_BaseTests {
    
    var state = VimEngineState(visualStyle: .characterwise)

    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        state.appFamily = appFamily
        
        return applyMove { asVisualMode.tilde(on: $0, state) }
    }

}


// Both
extension ASUI_VM_tilde_Tests {

    func test_that_it_switches_case_for_the_selection() {
        let textInAXFocusedElement = """
all that VM d DOES
in characTerwi😂️e is deleting
the SElection!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.w(times: 4, on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, state) }
        applyMove { asVisualMode.j(on: $0, state) }
        applyMove { asVisualMode.b(on: $0, state) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
all that VM d does
IN CHARACtERWI😂️E IS DELETING
THE sElection!
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 14)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "d")
    }

}


// PGR and Electron
extension ASUI_VM_tilde_Tests {

    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
all that VM d DOES
in characTerwi😂️e is deleting
the SElection!
"""
        app.webViews.firstMatch.tap()
        app.webViews.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.w(times: 4, on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, state) }
        applyMove { asVisualMode.j(on: $0, state) }
        applyMove { asVisualMode.b(on: $0, state) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, """
all that VM d does
IN CHARACtERWI😂️E IS DELETING
THE sElection!
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 14)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "d")
    }

}
