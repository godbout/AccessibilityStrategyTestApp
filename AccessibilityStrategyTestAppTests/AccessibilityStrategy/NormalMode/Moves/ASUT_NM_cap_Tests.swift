@testable import AccessibilityStrategy
import XCTest
import Common


// this uses FT aParagraph that is already heavily tested.
// so here we have tests specific to the move itself, like Bip, etc.
class ASUT_NM_cap_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: .auto)
        
        return applyMoveBeingTested(on: element, &state)
    } 
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.cap(on: element, &vimEngineState) 
    }
    
}


// Bip, copy deletion and LYS
extension ASUT_NM_cap_Tests {
    
    func test_that_if_there_is_no_aParagraph_found_it_Bips_and_does_not_copy_anything_and_does_not_change_the_LastYankStyle_to_Linewise() {
        let text = """
like this will Bip



"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 21,
            caretLocation: 20,
            selectedLength: 1,
            selectedText: """


        """,
            fullyVisibleArea: 0..<21,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 21,
                number: 3,
                start: 20,
                end: 21
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: false, lastYankStyle: .characterwise)
        let returnedElement = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
        XCTAssertEqual(returnedElement.caretLocation, 20)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
        
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertEqual(state.lastMoveBipped, true)
    }
    
    func test_that_if_there_is_a_aParagraph_found_it_does_not_Bip_and_it_copies_the_deletion_and_it_sets_the_LastYankStyle_to_Linewise() {
        let text = """
this will not



Bip
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 20,
            caretLocation: 15,
            selectedLength: 1,
            selectedText: """
        
        
        """,
            fullyVisibleArea: 0..<20,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 20,
                number: 3,
                start: 15,
                end: 16
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: false, lastYankStyle: .characterwise)
        let returnedElement = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """



Bip
"""
        )
        XCTAssertEqual(returnedElement.caretLocation, 14)
        XCTAssertEqual(returnedElement.selectedLength, 6)
        XCTAssertEqual(returnedElement.selectedText, "")
        
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertEqual(state.lastMoveBipped, false)
    }
    
}


// both
extension ASUT_NM_cap_Tests {
    
    func test_that_when_it_finds_a_aParagraph_it_selects_the_range_and_will_delete_the_selection() {
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
            fullyVisibleArea: 0..<50,
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
        XCTAssertEqual(returnedElement.selectedLength, 28)
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
            fullyVisibleArea: 0..<54,
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
        XCTAssertEqual(returnedElement.selectedLength, 28)
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
            fullyVisibleArea: 0..<36,
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
        XCTAssertEqual(returnedElement.selectedLength, 14)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
}
