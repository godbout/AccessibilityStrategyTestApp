@testable import AccessibilityStrategy
import XCTest
import Common


// see daB for blah blah
class ASUI_NM_dab_Tests: ASUI_NM_BaseTests {

    private func applyMoveBeingTested(_ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return applyMove { asNormalMode.dab(on: $0, &vimEngineState) }
    }

}


extension ASUI_NM_dab_Tests {

    // this test contains blank spaces
    func test_that_we_are_passing_the_correct_bracket_parameter_to_dInnerBlock() {
        let textInAXFocusedElement = """
now that shit will get cleaned (
    and the non blank
  will be respected!
)
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(times: 2, on: $0) }
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let accessibilityElement = applyMoveBeingTested(&vimEngineState)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
(
    and the non blank
  will be respected!
)
"""
        )
        XCTAssertEqual(accessibilityElement.fileText.value, """
now that shit will get cleaned 
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 30)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")

        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertEqual(vimEngineState.lastMoveBipped, false)
    }

}
