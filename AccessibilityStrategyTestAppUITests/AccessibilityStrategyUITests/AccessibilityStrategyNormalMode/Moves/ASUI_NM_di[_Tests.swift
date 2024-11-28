@testable import AccessibilityStrategy
import XCTest
import Common



// see diB for blah blah
class ASUI_NM_diLeftBracket_Tests: ASUI_NM_BaseTests {

    // TODO: see da<
    private func applyMoveBeingTested(_ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return applyMove { asNormalMode.diLeftBracket(on: $0, &vimEngineState) }
    }

}


extension ASUI_NM_diLeftBracket_Tests {

    func test_that_we_are_passing_the_correct_bracket_parameter_to_dInnerBlock() {
        let textInAXFocusedElement = """
now that shit will get cleaned [
    and the non blank
  will be respected!
]
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(times: 2, on: $0) }

        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let accessibilityElement = applyMoveBeingTested(&state)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
    and the non blank
  will be respected!\n
"""
        )
        XCTAssertEqual(accessibilityElement.fileText.value, """
now that shit will get cleaned [
]
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 33)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "]")

        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertEqual(state.lastMoveBipped, false)
    }

}
