@testable import AccessibilityStrategy
import XCTest
import Common


// PGR and Electron in UIT.
class ASUT_VML_c_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState()
        
        return applyMoveBeingTested(on: element, &state)
    }
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        vimEngineState.visualStyle = .linewise
        
        return asVisualMode.c(on: element, &vimEngineState)
    }
    
}


// Bip, copy deletion and LYS
// no that accurate.
// see VMC c for more blah blah.
extension ASUT_VML_c_Tests {

    func test_that_it_always_does_not_Bip_and_sets_the_LastYankStyle_to_Linewise_and_copies_the_selected_text_even_for_an_empty_line() {
        let text = """
VM c in Linewise
will delete the selected lines
but the below line will not go up
at least if we're not at the end of the text
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 126,
            caretLocation: 17,
            selectedLength: 65,
            selectedText: """
will delete the selected lines
but the below line will not go up\n
""",
            fullyVisibleArea: 0..<126,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 126,
                number: 2,
                start: 17,
                end: 48
            )!
        )      
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
will delete the selected lines
but the below line will not go up\n
"""
        )
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
}


// Both
extension ASUT_VML_c_Tests {

    func test_that_in_normal_setting_it_deletes_the_selected_lines_but_without_the_last_linefeed_of_the_selection_if_any() {
        let text = """
VM c in Linewise
will delete the selected lines
but the below line will not go up
at least if we're not at the end of the text
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 126,
            caretLocation: 17,
            selectedLength: 65,
            selectedText: """
will delete the selected lines
but the below line will not go up\n
""",
            fullyVisibleArea: 0..<126,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 126,
                number: 2,
                start: 17,
                end: 48
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 17)
        XCTAssertEqual(returnedElement.selectedLength, 64)
        XCTAssertEqual(returnedElement.selectedText, "")
    } 
    
    func test_that_it_keeps_the_indentation_of_the_first_selected_line_when_it_is_a_blank_line() {
        let text = """
VM c in Linewise
         
but the below line will not go up
at least if we're not at the end of the text
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 105,
            caretLocation: 17,
            selectedLength: 44,
            selectedText: """
         
but the below line will not go up
""",
            fullyVisibleArea: 0..<105,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 105,
                number: 2,
                start: 17,
                end: 27
            )!
        )
                
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 26)
        XCTAssertEqual(returnedElement.selectedLength, 34)
        XCTAssertEqual(returnedElement.selectedText, "")
    } 
    
    func test_that_it_keeps_the_indentation_of_the_first_selected_line_when_it_is_not_a_blank_line() {
        let text = """
VM c in Linewise
   will delete the selected lines
but the below line will not go up
at least if we're not at the end of the text
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 129,
            caretLocation: 17,
            selectedLength: 68,
            selectedText: """
   will delete the selected lines
but the below line will not go up\n
""",
            fullyVisibleArea: 0..<129,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 129,
                number: 2,
                start: 17,
                end: 51
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 20)
        XCTAssertEqual(returnedElement.selectedLength, 64)
        XCTAssertEqual(returnedElement.selectedText, "")
    } 

}
