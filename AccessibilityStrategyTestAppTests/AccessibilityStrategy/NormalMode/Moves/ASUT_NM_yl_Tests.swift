import XCTest
@testable import AccessibilityStrategy
import Common


class ASUT_NM_yl_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.yl(on: element, &vimEngineState)
    }
    
}


extension ASUT_NM_yl_Tests {

    func test_that_in_normal_setting_it_copies_the_character_it_is_on_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_does_not_move() {
        let text = "yl is gonna copy the previous 😂️ char and move there"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 53,
            caretLocation: 30,
            selectedLength: 3,
            selectedText: """
        😂️
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
    
    
        
    func test_that_for_an_EmptyLine_it_fills_the_Pasteboard_with_an_empty_string_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_does_not_move() {
        let text = """
ok so no movement on

an empty line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 35,
            caretLocation: 21,
            selectedLength: 1,
            selectedText: """


        """,
            fullyVisibleArea: 0..<35,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 2,
                start: 21,
                end: 22
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "")
        XCTAssertEqual(returnedElement.caretLocation, 21)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
        
        XCTAssertFalse(state.lastMoveBipped)
        XCTAssertEqual(state.lastYankStyle, .characterwise)
    }
   
}
