@testable import AccessibilityStrategy
import XCTest
import Common


class ASUT_NM_ck_Tests: ASUT_NM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: .auto)
        
        return asNormalMode.ck(on: element, &state)
    }
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState ) -> AccessibilityTextElement {
        return asNormalMode.ck(on: element, &vimEngineState)
    }
    
}

    
// Bip, copy deletion and LYS
extension ASUT_NM_ck_Tests {

    func test_that_if_the_caret_is_on_the_first_line_it_Bips_and_does_not_change_the_LastYankingStyle_and_does_not_copy_anything() {
        let text = """
this move BIIIPS if
the caret is on the first file line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 55,
            caretLocation: 8,
            selectedLength: 1,
            selectedText: "e",
            visibleCharacterRange: 0..<55,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 55,
                number: 1,
                start: 0,
                end: 20
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertTrue(state.lastMoveBipped)
    }
    
    func test_that_in_other_cases_it_does_not_Bip_and_sets_the_LastYankingStyle_to_Linewise_and_copies_the_deletion_plus_the_last_linefeed_if_any() {
        let text = """
ok now let's check
when the deleting
works. should be nice.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 60,
            caretLocation: 29,
            selectedLength: 1,
            selectedText: "e",
            visibleCharacterRange: 0..<60,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 60,
                number: 2,
                start: 19,
                end: 37
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
extension ASUT_NM_ck_Tests {
    
    func test_that_if_the_caret_is_on_the_firstLine_it_does_not_move() {
        let text = "the caret is on the  😂️ first line"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 35,
            caretLocation: 21,
            selectedLength: 3,
            selectedText: "😂️",
            visibleCharacterRange: 0..<35,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 1,
                start: 0,
                end: 35
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
                
        XCTAssertEqual(returnedElement.caretLocation, 21)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// TextViews
extension ASUT_NM_ck_Tests {
    
    func test_that_in_normal_setting_it_can_delete_the_currentFileLine_and_the_one_above_but_excludes_the_linefeed_of_the_currentFileLine_if_any() {
        let text = """
ok real shit now
come on ck is useful
sometimes
no?
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 51,
            caretLocation: 41,
            selectedLength: 1,
            selectedText: "e",
            visibleCharacterRange: 0..<51,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 51,
                number: 3,
                start: 38,
                end: 48
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
                
        XCTAssertEqual(returnedElement.caretLocation, 17)
        XCTAssertEqual(returnedElement.selectedLength, 30)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
    func test_that_it_goes_to_the_firstNonBlank_of_the_line_above() {
        let text = """
this moves does not go to the
   beginning of the line actually
but to the first non blank
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 90,
            caretLocation: 82,
            selectedLength: 1,
            selectedText: "o",
            visibleCharacterRange: 0..<90,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 90,
                number: 3,
                start: 64,
                end: 90
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
                
        XCTAssertEqual(returnedElement.caretLocation, 33)
        XCTAssertEqual(returnedElement.selectedLength, 57)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
    // this test contains blanks
    func test_that_if_the_line_above_is_just_blanks_or_linefeed_and_the_currentFileLine_is_the_lastLine_the_caret_ends_up_at_the_end_of_the_line_above() {
        let text = """
this moves does not go to the
                        
but to the first non blank
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 81,
            caretLocation: 70,
            selectedLength: 1,
            selectedText: "t",
            visibleCharacterRange: 0..<81,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 81,
                number: 3,
                start: 55,
                end: 81
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
                
        XCTAssertEqual(returnedElement.caretLocation, 54)
        XCTAssertEqual(returnedElement.selectedLength, 27)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
   
}
