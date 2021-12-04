import XCTest
@testable import AccessibilityStrategy


class ASUI_VMC_c_Tests: ASUI_VM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove { asVisualMode.cForVisualStyleCharacterwise(on: $0, pgR: pgR)}
    }

}


// Both
extension ASUI_VMC_c_Tests {

    func test_that_when_the_selection_is_spanning_on_a_single_line_it_deletes_the_selected_text() {
        let textInAXFocusedElement = "ok so VM c (hahaha) on a single line"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.f(times: 2, to: "h", on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.fForVisualStyleCharacterwise(to: "i", on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "ok so VM c (hangle line")
        XCTAssertEqual(accessibilityElement?.caretLocation, 14)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
    func test_that_when_the_selection_is_spanning_on_multiple_lines_it_deletes_the_selected_text() {
        let textInAXFocusedElement = """
like same as above
but on multiple
lines because
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.e(on: $0) }
        applyMove { asNormalMode.e(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.jForVisualStyleCharacterwise(on: $0) }
        applyMove { asVisualMode.jForVisualStyleCharacterwise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
like samause
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 8)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}


// PGR
extension ASUI_VMC_c_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "ok so VM c (hahaha) on a single line"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.f(times: 2, to: "h", on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.fForVisualStyleCharacterwise(to: "i", on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "ok so VM c (hngle line")
        XCTAssertEqual(accessibilityElement?.caretLocation, 13)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}
