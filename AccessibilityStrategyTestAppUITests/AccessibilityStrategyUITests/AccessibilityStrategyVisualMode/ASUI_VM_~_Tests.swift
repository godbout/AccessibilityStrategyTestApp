import XCTest
@testable import AccessibilityStrategy


class ASUI_VM_tilde_Tests: ASUI_VM_BaseTests {

    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove { asVisualMode.tilde(on: $0, pgR: pgR)}
    }

}


// Both
extension ASUI_VM_tilde_Tests {

    func test_that_it_changes_case_for_the_selection() {
        let textInAXFocusedElement = """
all that VM d does
in characterwi😂️e is deleting
the selection!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.w(times: 4, on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.jForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.jForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.bForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.fileText.value, """
all that VM d DOES
IN CHARACTERWI😂️E IS DELETING
THE Selection!
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 14)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
        XCTAssertEqual(accessibilityElement?.selectedText, "D")
    }

}


// PGR
extension ASUI_VM_tilde_Tests {

    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
all that VM d does
in characterwi😂️e is deleting
the selection!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.w(times: 4, on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.jForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.jForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.bForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)

        XCTAssertEqual(accessibilityElement?.fileText.value, """
all that VM d DOES
IN CHARACTERWI😂️E IS DELETING
THE DOES
IN CHARACTERWI😂️E IS DELETING
THE Selection!
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 14)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
        XCTAssertEqual(accessibilityElement?.selectedText, "D")
    }

}
