@testable import AccessibilityStrategy
import XCTest
import VimEngineState


// cip uses FT.innerParagraph that is already tested. here as usual we check stuff that are specific
// to cip, which is caret ending up at the right place, text deleted etc.
// PGR in UIT.
class ASUT_NM_cip_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: .auto)
        
        return applyMoveBeingTested(on: element, &state)
    } 
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.cip(on: element, &vimEngineState) 
    }
    
}


// Bip, copy deletion and LYS
extension ASUT_NM_cip_Tests {
    
    func test_that_it_always_does_not_Bip_and_sets_the_LastYankStyle_to_Linewise_and_copies_the_deletion() {
        let text = """
this is some

kind of hmm
inner paragraph

oh yeah
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 50,
            caretLocation: 20,
            selectedLength: 1,
            selectedText: "f",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 50,
                number: 3,
                start: 14,
                end: 26
            )!
        )
       
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
kind of hmm
inner paragraph\n
"""
        )
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
}


// both
extension ASUT_NM_cip_Tests {
    
    func test_that_when_it_finds_an_innerParagraph_it_selects_the_range_and_will_delete_the_selection() {
        let text = """
this is some

kind of hmm
inner paragraph

oh yeah
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 50,
            caretLocation: 20,
            selectedLength: 1,
            selectedText: "f",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 50,
                number: 3,
                start: 14,
                end: 26
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 14)
        XCTAssertEqual(returnedElement.selectedLength, 27)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
    func test_that_it_respects_the_indentation_by_setting_the_caretLocation_to_the_firstNonBlank_of_the_first_line_of_the_paragraph_for_NormalSetting() {
        let text = """
this is some

    kind of hmm
inner paragraph

oh yeah
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 54,
            caretLocation: 38,
            selectedLength: 1,
            selectedText: "r",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 54,
                number: 4,
                start: 30,
                end: 46
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 18)
        XCTAssertEqual(returnedElement.selectedLength, 27)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
    // this test contains Blanks
    func test_that_it_respects_the_indentation_by_setting_the_caretLocation_to_the_firstNonBlank_of_the_first_line_of_the_paragraph_for_EmptyOrBlankLine() {
        let text = """
this is some
         
    

oh yeah
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 36,
            caretLocation: 26,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 36,
                number: 3,
                start: 23,
                end: 28
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 22)
        XCTAssertEqual(returnedElement.selectedLength, 6)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
}
