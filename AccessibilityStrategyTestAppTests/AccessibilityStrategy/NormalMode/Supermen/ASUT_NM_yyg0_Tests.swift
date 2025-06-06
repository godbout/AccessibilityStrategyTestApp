import XCTest
@testable import AccessibilityStrategy
import Common


class ASUT_NM_yyg0_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.yygZero(using: element.currentScreenLine, on: element, &vimEngineState)
    }
    
}


extension ASUT_NM_yyg0_Tests {

    func test_that_in_normal_setting_it_copies_from_the_fileLineStart_to_the_caretLocation_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise() {
        let text = "but are we gonna use y0 that much tho"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 37,
            caretLocation: 19,
            selectedLength: 1,
            selectedText: """
        e
        """,
            fullyVisibleArea: 0..<37,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 37,
                number: 1,
                start: 0,
                end: 37
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "but are we gonna us")
        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
        
        XCTAssertFalse(vimEngineState.lastMoveBipped)
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
    }
        
    func test_that_for_an_EmptyLine_it_fills_the_Pasteboard_with_an_empty_string_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise() {
        let text = """
that's gonna be

a little more
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 30,
            caretLocation: 16,
            selectedLength: 1,
            selectedText: """


        """,
            fullyVisibleArea: 0..<30,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 30,
                number: 2,
                start: 16,
                end: 17
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "")
        XCTAssertEqual(returnedElement.caretLocation, 16)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
        
        XCTAssertFalse(vimEngineState.lastMoveBipped)
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
    }
   
}
