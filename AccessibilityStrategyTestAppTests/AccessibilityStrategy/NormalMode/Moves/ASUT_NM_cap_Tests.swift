@testable import AccessibilityStrategy
import XCTest
import Common


// this uses FT aParagraph that is already heavily tested.
// so here we have tests specific to the move itself, like Bip, etc.
class ASUT_NM_cap_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.cap(on: element, &vimEngineState) 
    }
    
}


// Bip, copy deletion and LYS
extension ASUT_NM_cap_Tests {
    
    func test_that_if_there_is_no_aParagraph_found_it_Bips_and_does_not_copy_anything_and_does_not_change_the_LastYankStyle_to_Linewise() {
        let text = """
like this will Bip



"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 21,
            caretLocation: 20,
            selectedLength: 1,
            selectedText: """


        """,
            fullyVisibleArea: 0..<21,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 21,
                number: 3,
                start: 20,
                end: 21
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var state = VimEngineState(lastMoveBipped: false, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertEqual(state.lastMoveBipped, true)
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
            caretLocation: 15,
            selectedLength: 1,
            selectedText: """
        
        
        """,
            fullyVisibleArea: 0..<20,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 20,
                number: 3,
                start: 15,
                end: 16
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var state = VimEngineState(lastMoveBipped: false, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """



Bip
"""
        )
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertEqual(state.lastMoveBipped, false)
    }
    
}
