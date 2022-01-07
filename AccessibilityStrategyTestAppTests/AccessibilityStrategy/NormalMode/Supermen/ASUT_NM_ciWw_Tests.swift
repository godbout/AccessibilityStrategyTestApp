@testable import AccessibilityStrategy
import XCTest
import VimEngineState


// ciWw will be using TE.innerWord and TE.innerWOrd that are both fully tested.
// contrary to TE.aWORD/word, innerWORD/word never returns nil because Vim always finds an innerWORD/word.
// PGR in UIT.
class ASUT_NM_ciWw_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(pgR: false)
        
        return applyMoveBeingTested(on: element, &state)
    } 
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.ciWw(on: element, using: element.fileText.innerWord, &vimEngineState) 
    } 
    
}


// Bip, copy deletion and LYS
extension ASUT_NM_ciWw_Tests {
    
    func test_that_it_always_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_copies_the_deletion() {
        let text = "that's some cute-boobies      text in here don't you think?"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 59,
            caretLocation: 14,
            selectedLength: 1,
            selectedText: "t",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 59,
                number: 1,
                start: 0,
                end: 49
            )!
        )
       
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastYankStyle: .linewise, lastMoveBipped: true)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "cute")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
}


// both
extension ASUT_NM_ciWw_Tests {
    
    func test_that_when_it_finds_an_innerWoRd_it_selects_the_range_and_will_delete_the_selection() {
        let text = "that's some cute-boobies      text in here don't you think?"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 59,
            caretLocation: 14,
            selectedLength: 1,
            selectedText: "t",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 59,
                number: 1,
                start: 0,
                end: 59
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 12)
        XCTAssertEqual(returnedElement.selectedLength, 4)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
}
