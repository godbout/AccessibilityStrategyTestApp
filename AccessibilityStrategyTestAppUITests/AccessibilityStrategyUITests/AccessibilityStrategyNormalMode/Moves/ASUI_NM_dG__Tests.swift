import XCTest
@testable import AccessibilityStrategy
import VimEngineState


class ASUI_NM_dG__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(_ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return applyMove { asNormalMode.dG(on: $0, &vimEngineState) }
    }
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement {
        var state = VimEngineState(pgR: pgR)
        
        return applyMoveBeingTested(&state)
    }
    
}


// Bip, copy deletion and LYS
// not totally accurate. see ASUT cG for more blah blah.
extension ASUI_NM_dG__Tests {
    
    func test_that_when_it_is_on_an_empty_text_it_does_not_Bip_and_sets_the_LastYankStyle_to_Linewise_and_copies_an_empty_string() {
        let textInAXFocusedElement = ""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.ge(on: $0) }
        applyMove { asNormalMode.ge(on: $0) }
        
        copyToClipboard(text: "nope you don't copy mofo")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(&state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "")
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
    func test_that_when_it_is_not_on_an_empty_line_it_does_not_Bip_either_and_sets_the_LastYankStyle_to_Linewise_and_copies_the_deletion() {
        let textInAXFocusedElement = """
blah blah some line
some more
  haha geh
need to deal with
those faces 🥺️☹️😂️

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.j(on: $0) }
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(&state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
some more
  haha geh
need to deal with
those faces 🥺️☹️😂️

"""
        )
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertFalse(state.lastMoveBipped)
    }

}


// Both
extension ASUI_NM_dG__Tests {
    
    func test_that_if_we_are_on_the_first_line_then_it_deletes_the_whole_text() {
        let textInAXFocusedElement = "  that's gonna delete everything even if multiple lines"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.b(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, "")        
        XCTAssertEqual(accessibilityElement.caretLocation, 0)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
    }
    
}


// TextViews
extension ASUI_NM_dG__Tests {

    func test_that_if_there_is_a_line_before_the_current_line_then_the_caret_ends_at_the_firstNonBlankLimit_of_that_line_after_it_deleted_from_the_current_line_to_the_end_of_the_text() {
        let textInAXFocusedElement = """
  😂️k so now we're having multiple lines
and we will NOT be on on the first one so after dG
deletes from the current line to the end of the text
the caret will go to the first non blank limit of the line
before what was the current one.
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.j(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, "  😂️k so now we're having multiple lines")
        XCTAssertEqual(accessibilityElement.caretLocation, 2)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
        
    }
    
}
 

// PGR
extension ASUI_NM_dG__Tests {

    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
  😂️k so now we're having multiple lines
and we will NOT be on on the first one so after dG
deletes from the current line to the end of the text
the caret will go to the first non blank limit of the line
before what was the current one.
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.j(on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement.fileText.value, "  😂️k so now we're having multiple line")
        XCTAssertEqual(accessibilityElement.caretLocation, 2)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
        
    }
    
}
