@testable import AccessibilityStrategy
import XCTest
import Common


class ASUT_NM_cj_Tests: ASUT_NM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: .auto)
        
        return asNormalMode.cj(on: element, &state)
    }
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState ) -> AccessibilityTextElement {
        return asNormalMode.cj(on: element, &vimEngineState)
    }
    
}

    
// Bip, copy deletion and LYS
extension ASUT_NM_cj_Tests {

    func test_that_if_the_caret_is_on_the_lastLine_it_Bips_and_does_not_change_the_LastYankingStyle_and_does_not_copy_anything() {
        let text = """
well this move will Bip if
the caret is on the last line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 56,
            caretLocation: 41,
            selectedLength: 1,
            selectedText: "n",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 56,
                number: 2,
                start: 27,
                end: 56
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertTrue(state.lastMoveBipped)
    }
    
    func test_that_in_other_cases_it_does_not_Bip_and_sets_the_LastYankingStyle_to_Linewise_and_copies_the_deletion_plus_the_lastLinefeed_if_any() {
        let text = """
ok now let's check
when the deleting
works. should be nice.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 59,
            caretLocation: 5,
            selectedLength: 1,
            selectedText: "w",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 59,
                number: 1,
                start: 0,
                end: 19
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
ok now let's check
when the deleting\n
"""
        )
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
}


// both
extension ASUT_NM_cj_Tests {
    
    func test_that_if_the_caret_is_on_the_lastLine_it_does_not_move() {
        let text = "the caret is on the  😂️ last line"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 34,
            caretLocation: 21,
            selectedLength: 3,
            selectedText: "😂️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 34,
                number: 1,
                start: 0,
                end: 34
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
                
        XCTAssertEqual(returnedElement.caretLocation, 21)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// TextViews
extension ASUT_NM_cj_Tests {
    
    func test_that_in_normal_setting_it_can_delete_the_currentFileLine_and_the_line_below_but_excludes_the_linefeed_of_the_second_line_if_any() {
        let text = """
ok real shit now
come on cj is useful
sometimes
no?
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 51,
            caretLocation: 23,
            selectedLength: 1,
            selectedText: "n",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 51,
                number: 2,
                start: 17,
                end: 38
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
                
        XCTAssertEqual(returnedElement.caretLocation, 17)
        XCTAssertEqual(returnedElement.selectedLength, 30)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
    func test_that_if_the_second_line_is_the_last_one_it_can_still_delete_the_two_lines_and_does_not_bug_coz_the_last_one_does_not_have_linefeed() {
        let text = """
ok real shit now
come on cj is useful
😂️ometimes
no?
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 53,
            caretLocation: 38,
            selectedLength: 3,
            selectedText: "😂️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 53,
                number: 3,
                start: 38,
                end: 50
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
                
        XCTAssertEqual(returnedElement.caretLocation, 38)
        XCTAssertEqual(returnedElement.selectedLength, 15)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
    func test_that_it_goes_to_the_firstNonBlank_of_the_currentFileLine() {
        let text = """
this moves does not go to the
   beginning of the line actually
but to the first non blank
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 90,
            caretLocation: 35,
            selectedLength: 1,
            selectedText: "g",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 90,
                number: 2,
                start: 30,
                end: 64
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
                
        XCTAssertEqual(returnedElement.caretLocation, 33)
        XCTAssertEqual(returnedElement.selectedLength, 57)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
    // this test contains blanks
    func test_that_if_the_currentFileLine_is_just_blanks_or_linefeed_and_the_nextLine_is_the_lastLine_the_caret_ends_up_at_the_end_of_the_currentFileLine() {
        let text = """
this moves does not go to the
                        
but to the first non blank
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 81,
            caretLocation: 44,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 81,
                number: 2,
                start: 30,
                end: 55
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
                
        XCTAssertEqual(returnedElement.caretLocation, 54)
        XCTAssertEqual(returnedElement.selectedLength, 27)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
    func test_that_if_the_currentFileLine_is_just_blanks_or_linefeed_and_the_nextLine_is_not_the_lastLine_the_caret_ends_up_at_the_end_of_the_currentFileLine() {
        let text = """
this moves does not go to the
                        
but to the first non blank
but to the first non blank
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 81,
            caretLocation: 44,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 81,
                number: 2,
                start: 30,
                end: 55
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
                
        XCTAssertEqual(returnedElement.caretLocation, 54)
        XCTAssertEqual(returnedElement.selectedLength, 27)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
   
}
