@testable import AccessibilityStrategy
import XCTest
import Common


// in UIT. dap is not calling cap.
class ASUT_NM_dap_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.dap(on: element, &vimEngineState)
    }
    
}


// Bip, copy deletion and LYS
extension ASUT_NM_dap_Tests {
    
    func test_that_if_there_is_no_aParagraph_found_it_Bips_and_does_not_copy_anything_and_does_not_change_the_LastYankStyle_to_Linewise() {
        let text = """
like this will Bip



"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 21,
            caretLocation: 19,
            selectedLength: 1,
            selectedText: """


        """,
            fullyVisibleArea: 0..<21,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 21,
                number: 2,
                start: 19,
                end: 20
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertTrue(vimEngineState.lastMoveBipped)
    }
    
    func test_that_if_there_is_a_aParagraph_found_it_does_not_Bip_and_it_copies_the_deletion_and_it_sets_the_LastYankStyle_to_Linewise() {
        let text = """
this will not



Bip
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 20,
            caretLocation: 17,
            selectedLength: 1,
            selectedText: """
        B
        """,
            fullyVisibleArea: 0..<20,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 20,
                number: 5,
                start: 17,
                end: 20
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """



Bip
"""
        )
        XCTAssertEqual(vimEngineState.lastYankStyle, .linewise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
    
}
