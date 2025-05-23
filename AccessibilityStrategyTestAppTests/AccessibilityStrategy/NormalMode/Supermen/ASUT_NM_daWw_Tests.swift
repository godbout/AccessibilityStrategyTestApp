@testable import AccessibilityStrategy
import XCTest
import Common


// see caWw
class ASUT_NM_daWw_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.daWw(on: element, using: element.fileText.aWord, &vimEngineState)
    }
    
}


// Bip, copy deletion and LYS
extension ASUT_NM_daWw_Tests {
    
    func test_that_when_it_finds_the_stuff_it_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise() {
        let text = "that's some cute      text in here don't you think?"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 51,
            caretLocation: 13,
            selectedLength: 1,
            selectedText: "u",
            fullyVisibleArea: 0..<51,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 51,
                number: 1,
                start: 0,
                end: 51
            )!
        )
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertFalse(vimEngineState.lastMoveBipped)
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
    }
        
    func test_that_when_it_does_not_find_the_stuff_it_Bips_and_does_not_change_the_LastYankingStyle() {
        let text = """
some text
and also a lot of spaces at the end of this line        
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 66,
            caretLocation: 60,
            selectedLength: 1,
            selectedText: " ",
            fullyVisibleArea: 0..<66,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 66,
                number: 2,
                start: 10,
                end: 66
            )!
        )
        
        var vimEngineState = VimEngineState(lastMoveBipped: false, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertTrue(vimEngineState.lastMoveBipped)
        XCTAssertEqual(vimEngineState.lastYankStyle, .linewise)
    }
       
}
