@testable import AccessibilityStrategy
import XCTest
import Common


// dis uses FT.innerSentence that is already heavily tested.
// see cis for more blah blah
class ASUT_NM_dis_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.dis(on: element, &vimEngineState) 
    }
    
}


// Bip, copy deletion and LYS
extension ASUT_NM_dis_Tests {
    
    func test_that_it_always_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_copies_the_deletion() {
        let text = """
ok so here

we're gonna deal with sentences. and shit. lol.
are you OK??
"""
        // TODO: verify the element data
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 72,
            caretLocation: 24,
            selectedLength: 1,
            selectedText: """
         
        """,
            fullyVisibleArea: 0..<72,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 72,
                number: 3,
                start: 12,
                end: 60
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
we're gonna deal with sentences.
"""
        )
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
    
}
