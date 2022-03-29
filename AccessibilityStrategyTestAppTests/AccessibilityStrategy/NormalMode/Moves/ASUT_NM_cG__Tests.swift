@testable import AccessibilityStrategy
import XCTest
import Common


class ASUT_NM_cG__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: .auto)
        
        return applyMoveBeingTested(on: element, &state)
    }
        
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.cG(on: element, &vimEngineState)
    }
    
}


// Bip, copy deletion and LYS
// the copy deletion is more complicated than that for cG and cgg. if the LYS is Characterwise,
// cG/cgg on an empty test would erase the previous register, but if the LYS is Linewise, it doesn't.
// currently this is not handled by kV. if the text is empty, it copies, whatever the VMS.
extension ASUT_NM_cG__Tests {
    
    func test_that_when_it_is_on_an_empty_text_it_does_not_Bip_and_sets_the_LastYankStyle_to_Linewise_and_copies_an_empty_string() {
        let text = ""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 0,
            caretLocation: 0,
            selectedLength: 0,
            selectedText: "",
            fullyVisibleArea: 0..<0,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 0,
                number: 1,
                start: 0,
                end: 0
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "")
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
    func test_that_when_it_is_not_on_an_empty_line_it_does_not_Bip_either_and_sets_the_LastYankStyle_to_Linewise_and_copies_the_deletion() {
        let text = """
blah blah some line
some more
  haha geh
need to deal with
those faces 🥺️☹️😂️

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 80,
            caretLocation: 37,
            selectedLength: 1,
            selectedText: "g",
            fullyVisibleArea: 0..<80,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 80,
                number: 3,
                start: 30,
                end: 41
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
  haha geh
need to deal with
those faces 🥺️☹️😂️

"""
        )
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertFalse(state.lastMoveBipped)
    }

}


// count
// tried count but more complicated than expected, because the element
// returned by G can be below the current caretLocation (good) but also
// above (not good). like you're on line 3 but you do a c1G. we can't then use
// the caretLocation and selectedLength to delete. we have to recalculate the whole
// thing. basically it's like VisualMode instead. so for later.


// Both
extension ASUT_NM_cG__Tests {
    
    func test_that_it_deletes_the_line_up_to_the_firstNonBlankLimit() {
        let text = "    this is a single line ‼️‼️‼️"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 32,
            caretLocation: 15,
            selectedLength: 1,
            selectedText: "i",
            fullyVisibleArea: 0..<32,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 32,
                number: 1,
                start: 0,
                end: 32
            )!
        )
                
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 4)
        XCTAssertEqual(returnedElement.selectedLength, 28)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
}


// TextViews
extension ASUT_NM_cG__Tests {
    
    func test_that_it_deletes_from_the_firstNonBlankLimit_of_the_current_line_to_the_end_of_the_TextView() {
        let text = """
blah blah some line
some more
  haha geh
need to deal with
those faces 🥺️☹️😂️

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 80,
            caretLocation: 37,
            selectedLength: 1,
            selectedText: "g",
            fullyVisibleArea: 0..<80,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 80,
                number: 3,
                start: 30,
                end: 41
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 32)
        XCTAssertEqual(returnedElement.selectedLength, 48)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
}
