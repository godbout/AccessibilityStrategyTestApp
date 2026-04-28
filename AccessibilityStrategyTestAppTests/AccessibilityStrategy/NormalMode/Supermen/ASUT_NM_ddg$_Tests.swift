@testable import AccessibilityStrategy
import XCTest
import Common


// ddg$ used to call ccg$ but they are actually different in how they handle ELs with the copy and YLS
// we have to make ddg$ impl on its own. so here now we have to test the Bip, Copy and LYS for ddg$ itself.
// when it comes to moves themselves, they have to be tested in UIT.
class ASUT_NM_ddg$_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        asNormalMode.ddgDollarSign(using: element.currentFileLine, on: element, &vimEngineState) 
    }

}


// Bip, copy deletion and LYS
extension ASUT_NM_ddg$_Tests {
    
    func test_that_when_it_is_on_an_EmptyLine_it_does_not_Bip_and_does_not_change_the_LastYankStyle_to_Characterwise_and_does_not_copy_anything() {
        let text = """
hehe

hoho
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 10,
            caretLocation: 5,
            selectedLength: 0,
            selectedText: "",
            fullyVisibleArea: 0..<10,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 10,
                number: 2,
                start: 5,
                end: 6
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
        XCTAssertEqual(vimEngineState.lastYankStyle, .linewise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
    
    func test_that_when_it_is_not_on_an_EmptyLine_it_does_not_Bip_either_and_sets_the_LastYankStyle_to_Characterwise_also_but_copies_the_deletion() {
        let text = """
C will now work with file lines and is supposed to delete from the caret ☀️ to before the linefeed
and of course this is in the case there is a linefeed at the end of the line.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 176,
            caretLocation: 55,
            selectedLength: 1,
            selectedText: "t",
            fullyVisibleArea: 0..<176,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 176,
                number: 2,
                start: 51,
                end: 99
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "te from the caret ☀️ to before the linefeed")
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
    
}
