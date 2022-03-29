@testable import AccessibilityStrategy
import XCTest
import Common


class ASUT_NM_ch_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: .auto)
        
        return applyMoveBeingTested(times: count, on: element, &state)
    }
        
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.ch(times: count, on: element, &vimEngineState)
    }
    
}


// count
extension ASUT_NM_ch_Tests {
    
    func test_that_it_implements_the_count_system() {
        let text = """
testing with count
should be awesome to use
  😂️ctually nobody uses counts
LMAO
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 80,
            caretLocation: 15,
            selectedLength: 1,
            selectedText: "u",
            fullyVisibleArea: 0..<80,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 80,
                number: 1,
                start: 0,
                end: 19
            )!
        )
                
        let returnedElement = applyMoveBeingTested(times: 4, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 11)
        XCTAssertEqual(returnedElement.selectedLength, 4)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
    func test_that_if_the_count_is_too_high_it_stops_at_the_start_of_the_line() {
        let text = """
testing with count
should be awesome to use
  😂️ctually nobody uses counts
LMAO
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 80,
            caretLocation: 51,
            selectedLength: 1,
            selectedText: "u",
            fullyVisibleArea: 0..<80,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 80,
                number: 3,
                start: 44,
                end: 76
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 44)
        XCTAssertEqual(returnedElement.selectedLength, 7)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
}


// Bip, copy deletion and LYS, AND count
// count is included now in moves that copy deletion because it will affect what is copied.
extension ASUT_NM_ch_Tests {
    
    // this case includes empty lines
    func test_that_if_the_caret_is_at_the_start_of_a_line_it_does_not_Bip_and_does_not_change_the_LastYankStyle_and_does_not_copy_anything() {
        let text = """
so we're at the start of the second line
and a shouldn't get deleted and
we should stay there
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 93,
            caretLocation: 41,
            selectedLength: 1,
            selectedText: "a",
            fullyVisibleArea: 0..<93,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 93,
                number: 2,
                start: 41,
                end: 73
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
    func test_that_if_the_newCaretLocation_after_the_move_ends_up_at_the_start_of_the_line_then_it_does_not_Bip_but_change_the_LastYankStyle_to_Characterwise_and_copies_the_deletion_up_to_the_start_of_the_line() {
        let text = "ch should delete the correct character😂️😂️😂️😂️"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 50,
            caretLocation: 38,
            selectedLength: 3,
            selectedText: "😂️",
            fullyVisibleArea: 0..<50,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 50,
                number: 1,
                start: 0,
                end: 50
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(times: 5, on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "acter")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
    func test_that_if_the_newCaretLocation_after_the_move_ends_up_after_the_start_of_the_line_then_it_does_not_Bip_but_change_the_LastYankStyle_to_Characterwise_and_copies_the_deletion_up_to_the_newCaretLocation() {
        let text = "ch should delete the correct character😂️😂️😂️😂️"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 50,
            caretLocation: 38,
            selectedLength: 3,
            selectedText: "😂️",
            fullyVisibleArea: 0..<50,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 50,
                number: 1,
                start: 0,
                end: 50
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(times: 128, on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "ch should delete the correct character")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertFalse(state.lastMoveBipped)        
    }
    
}


// Both
extension ASUT_NM_ch_Tests {
    
    func test_that_in_normal_setting_it_deletes_the_character_before_the_caretLocation() {
        let text = " ch to delete a char😂️cter on the left"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 39,
            caretLocation: 23,
            selectedLength: 1,
            selectedText: "c",
            fullyVisibleArea: 0..<39,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 39,
                number: 1,
                start: 0,
                end: 39
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 20)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
}


// TextViews
extension ASUT_NM_ch_Tests {
    
    func test_that_if_the_caret_is_at_the_start_of_the_file_line_it_does_not_delete_nor_move_and_deselects_text() {
        let text = """
so we're at the start of the second line
and a shouldn't get deleted and
we should stay there
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 93,
            caretLocation: 41,
            selectedLength: 1,
            selectedText: "a",
            fullyVisibleArea: 0..<93,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 93,
                number: 2,
                start: 41,
                end: 73
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 41)
        XCTAssertEqual(returnedElement.selectedLength, 0)
        XCTAssertNil(returnedElement.selectedText)
    }
        
}
