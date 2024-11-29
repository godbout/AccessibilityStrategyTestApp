import XCTest
@testable import AccessibilityStrategy
import Common


class ASUT_NM_yh_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.yh(on: element, &vimEngineState)
    }
    
}


extension ASUT_NM_yh_Tests {

    func test_that_in_normal_setting_it_copies_the_previous_character_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_reposition_the_caretLocation_to_the_previous_character() {
        let text = "yh is gonna copy the previous 😂️ char and move there"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 53,
            caretLocation: 33,
            selectedLength: 1,
            selectedText: """
         
        """,
            fullyVisibleArea: 0..<53,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 53,
                number: 1,
                start: 0,
                end: 53
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "😂️")
        XCTAssertEqual(returnedElement.caretLocation, 30)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
        
        XCTAssertFalse(state.lastMoveBipped)
        XCTAssertEqual(state.lastYankStyle, .characterwise)
    }
        
    func test_that_if_the_caretLocation_is_at_the_start_of_the_line_then_it_fills_the_Pasteboard_with_an_empty_string_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_does_not_move() {
        let text = """
that's good for caret at beginning
of line so that includes empty lines!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 72,
            caretLocation: 35,
            selectedLength: 1,
            selectedText: """
        o
        """,
            fullyVisibleArea: 0..<72,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 72,
                number: 2,
                start: 35,
                end: 72
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "")
        XCTAssertEqual(returnedElement.caretLocation, 35)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
        
        XCTAssertFalse(state.lastMoveBipped)
        XCTAssertEqual(state.lastYankStyle, .characterwise)
    }
   
}
