import XCTest
import AccessibilityStrategy
import Common


class ASUI_NM_yg0_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(_ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return applyMove { asNormalMode.ygZero(on: $0, &vimEngineState) }
    }
    
}


extension ASUI_NM_yg0_Tests {

    func test_that_in_normal_setting_it_copies_from_the_ScreenLineStart_to_the_caretLocation_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise() {
        let textInAXFocusedElement = "yg0 is like y0 except that it works on screen lines!!!"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.b(on: $0) }
        copyToClipboard(text: "some fake shit")
        
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let accessibilityElement = applyMoveBeingTested(&state)
        
        XCTAssertEqual(accessibilityElement.caretLocation, 46)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "l")
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "lines")
        XCTAssertFalse(state.lastMoveBipped)
        XCTAssertEqual(state.lastYankStyle, .characterwise)
    }
        
    func test_that_for_an_EmptyLine_it_fills_the_Pasteboard_with_an_empty_string_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise() {
        let textInAXFocusedElement = """
so this has to be a bit longer than the other one 

and maybe a little here too coz ScreenLines
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(times: 2, on: $0) }
        copyToClipboard(text: "some fake shit")
        
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let accessibilityElement = applyMoveBeingTested(&state)
        
        XCTAssertEqual(accessibilityElement.caretLocation, 51)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "\n")
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "")
        XCTAssertFalse(state.lastMoveBipped)
        XCTAssertEqual(state.lastYankStyle, .characterwise)
    }
    
}
