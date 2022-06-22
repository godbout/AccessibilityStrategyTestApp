import XCTest
import AccessibilityStrategy
import Common


class ASUI_NM_yg$_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(_ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return applyMove { asNormalMode.ygDollarSign(on: $0, &vimEngineState) }
    }
    
}


extension ASUI_NM_yg$_Tests {

    func test_that_if_the_ScreenLine_does_not_end_with_a_Linefeed_it_copies_from_the_caretLocation_to_the_LineEndLimit_included_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise() {
        let textInAXFocusedElement = "hehe i forgot to change the content of this string LOL"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.b(times: 7, on: $0) }
                
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let accessibilityElement = applyMoveBeingTested(&state)
        
        XCTAssertEqual(accessibilityElement.caretLocation, 23)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "change ")
        XCTAssertFalse(state.lastMoveBipped)
        XCTAssertEqual(state.lastYankStyle, .characterwise)
    }
        
    func test_that_if_the_ScreenLineLine_ends_with_a_Linefeed_it_copies_from_the_caretLocation_to_the_LineEndLimit_included_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise() {
        let textInAXFocusedElement = """
ok so another long one because
screenlines and now we gonna have
linefeeds also finally
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
                
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let accessibilityElement = applyMoveBeingTested(&state)
        
        XCTAssertEqual(accessibilityElement.caretLocation, 63)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "e")
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "have")
        XCTAssertFalse(state.lastMoveBipped)
        XCTAssertEqual(state.lastYankStyle, .characterwise)
    }
    
    func test_that_for_an_EmptyLine_it_fills_the_Pasteboard_with_an_empty_string_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise() {
        let textInAXFocusedElement = """
ok so another long one because

but now there's an empty line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(times: 2, on: $0) }
                
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let accessibilityElement = applyMoveBeingTested(&state)
        
        XCTAssertEqual(accessibilityElement.caretLocation, 31)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "\n")
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "")
        XCTAssertFalse(state.lastMoveBipped)
        XCTAssertEqual(state.lastYankStyle, .characterwise)
    }
    
}
