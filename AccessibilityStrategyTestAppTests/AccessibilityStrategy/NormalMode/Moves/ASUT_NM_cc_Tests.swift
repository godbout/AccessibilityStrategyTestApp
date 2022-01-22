@testable import AccessibilityStrategy
import XCTest
import Common


class ASUT_NM_cc_Tests: ASUT_NM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: .auto)
        
        return asNormalMode.cc(on: element, &state)
    }
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState ) -> AccessibilityTextElement {
        return asNormalMode.cc(on: element, &vimEngineState)
    }
    
}

    
// Bip, copy deletion and LYS
extension ASUT_NM_cc_Tests {
    
    func test_that_it_always_does_not_Bip_and_sets_the_LastYankStyle_to_Linewise_and_copies_the_whole_line_even_for_an_empty_line() {
        let text = """
looks like it's late coz it's getting harder to reason
but actually it's only 21.43 LMAOOOOOOOO
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 95,
            caretLocation: 38,
            selectedLength: 1,
            selectedText: "h",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 95,
                number: 1,
                start: 0,
                end: 55
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "looks like it's late coz it's getting harder to reason\n")
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
}


// both
extension ASUT_NM_cc_Tests {
    
    func test_that_if_a_file_line_ends_with_a_linefeed_it_deletes_up_to_but_not_including_the_linefeed() {
        let text = """
looks like it's late coz it's getting harder to reason
but actually it's only 21.43 LMAOOOOOOOO
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 95,
            caretLocation: 38,
            selectedLength: 1,
            selectedText: "h",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 95,
                number: 1,
                start: 0,
                end: 55
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 54)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
    func test_that_if_a_file_line_does_not_end_with_a_linefeed_it_deletes_up_to_the_end() {
        let text = "yeah exactly, it could be at the end of 🌻️🌻️🌻️ a TextArea or like a TextField like this one"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 94,
            caretLocation: 43,
            selectedLength: 3,
            selectedText: "🌻️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 94,
                number: 1,
                start: 0,
                end: 94
            )!
        )
                
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 94)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
    func test_that_it_should_keep_the_indentation_of_the_current_line() {
        let text = """
but the indent should
   i delete a line
be kept
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 48,
            caretLocation: 28,
            selectedLength: 1,
            selectedText: "e",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 48,
                number: 2,
                start: 22,
                end: 41
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 25)
        XCTAssertEqual(returnedElement.selectedLength, 15)
        XCTAssertEqual(returnedElement.selectedText, "")
    }

    func test_that_if_a_file_line_is_a_blank_line_it_does_not_delete_anything_and_goes_at_the_end_of_the_line_before_the_linefeed() {
        let text = """
something
            
  something else
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 39,
            caretLocation: 21,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 39,
                number: 2,
                start: 10,
                end: 23
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 22)
        XCTAssertEqual(returnedElement.selectedLength, 0)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
}
