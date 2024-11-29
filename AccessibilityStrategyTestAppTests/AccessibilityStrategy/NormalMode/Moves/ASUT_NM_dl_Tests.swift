@testable import AccessibilityStrategy
import XCTest
import Common


class ASUT_NM_dl_Tests: ASUT_NM_BaseTests {

    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.dl(times: count, on: element, &vimEngineState)
    }
    
}


// Bip, copy deletion and LYS, AND count
extension ASUT_NM_dl_Tests {
    
    func test_that_for_an_empty_line_it_does_not_Bip_but_does_not_change_the_LastYankStyle_and_does_not_copy_anything() {
        let text = """
next line is gonna be empty!

but shouldn't be deleted
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 54,
            caretLocation: 29,
            selectedLength: 1,
            selectedText: """


        """,
            fullyVisibleArea: 0..<54,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 54,
                number: 3,
                start: 29,
                end: 30
            )!
        )
        copyToClipboard(text: "nope you don't copy mofo")
        
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "nope you don't copy mofo")
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
    func test_that_when_it_is_not_on_an_empty_line_and_the_newHeadLocation_is_before_the_end_of_the_line_it_does_not_Bip_either_and_sets_the_LastYankStyle_to_Characterwise_and_copies_the_deletion_including_the_character_at_newHeadLocation() {
        let text = "x should delete the right character"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 35,
            caretLocation: 26,
            selectedLength: 1,
            selectedText: """
        c
        """,
            fullyVisibleArea: 0..<35,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 1,
                start: 0,
                end: 35
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(times: 6, on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "charac")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
    func test_that_when_it_is_not_on_an_empty_line_and_the_newHeadLocation_is_after_the_end_of_the_line_it_does_not_Bip_either_and_sets_the_LastYankStyle_to_Characterwise_and_copies_the_deletion_without_the_linefeed() {
        let text = """
x should delete the right character
 but also 😂️
we gonna need several lines here
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 82,
            caretLocation: 41,
            selectedLength: 1,
            selectedText: """
        a
        """,
            fullyVisibleArea: 0..<82,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 82,
                number: 3,
                start: 36,
                end: 50
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(times: 128, on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "also 😂️")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
}
