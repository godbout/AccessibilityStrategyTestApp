@testable import AccessibilityStrategy
import XCTest
import Common


class ASUT_NM_ccg0_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: .auto)
        
        return applyMoveBeingTested(on: element, &vimEngineState)
    }
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        // see cgg$ for blah blah
        return asNormalMode.ccgZero(using: element.currentFileLine, on: element, &vimEngineState) 
    }
    
}


// Bip, copy deletion and LYS
extension ASUT_NM_ccg0_Tests {
    
    func test_that_if_the_caretLocation_is_at_the_start_of_the_currentFileLine_it_does_not_Bip_and_does_not_change_the_LastYankStyle_and_does_not_copy_anything() {
        let text = """
hello dear friend
😂️hat's some text
and also some more
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 55,
            caretLocation: 18,
            selectedLength: 3,
            selectedText: "😂️",
            fullyVisibleArea: 0..<55,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 55,
                number: 2,
                start: 18,
                end: 37
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
        XCTAssertEqual(vimEngineState.lastYankStyle, .linewise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
    
    func test_that_in_other_cases_it_also_does_not_Bip_but_it_changes_the_LastYankStyle_to_Characterwise_and_copies_from_the_caretLocation_to_the_start_of_the_currentFileLine() {
        let text = """
hello dear friend
😂️hat's some text
and also some more
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 55,
            caretLocation: 32,
            selectedLength: 1,
            selectedText: "t",
            fullyVisibleArea: 0..<55,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 55,
                number: 2,
                start: 18,
                end: 37
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "😂️hat's some ")
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
       
}


// Both
extension ASUT_NM_ccg0_Tests {
    
    func test_that_in_normal_setting_it_deletes_up_to_the_start_of_the_currentFileLine() {
        let text = "so that's a long line in a text field and well it's kindaVim i love it"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 70,
            caretLocation: 52,
            selectedLength: 1,
            selectedText: "k",
            fullyVisibleArea: 0..<70,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 70,
                number: 1,
                start: 0,
                end: 70
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 52)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
    // this test includes for empty text or empty lines
    func test_that_if_the_caretLocation_is_at_the_start_of_the_currentFileLine_it_does_not_do_anything() {
        let text = """
hello dear friend
😂️hat's some text
and also some more
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 55,
            caretLocation: 37,
            selectedLength: 1,
            selectedText: "a",
            fullyVisibleArea: 0..<55,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 55,
                number: 3,
                start: 37,
                end: 55
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 37)
        XCTAssertEqual(returnedElement.selectedLength, 0)
        XCTAssertNil(returnedElement.selectedText)

    }

}
