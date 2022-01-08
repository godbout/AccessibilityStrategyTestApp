import XCTest
@testable import AccessibilityStrategy
import VimEngineState


// there's no way to test PGR for this move. if you can't remember why think harder.
class ASUI_NM_dgg_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(_ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return applyMove { asNormalMode.dgg(on: $0, &vimEngineState) }
    }
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement {
        var state = VimEngineState(pgR: pgR)
        
        return applyMoveBeingTested(&state)
    }
    
}


// TODO: can't this be moved into ASUT?
// Bip, copy deletion and LYS
// not totally accurate. see ASUT cG for more blah blah.
extension ASUI_NM_dgg_Tests {
    
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
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(&state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
blah blah some line
some more\n
"""
        )
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertFalse(state.lastMoveBipped)
    }

}


// TextViews
extension ASUI_NM_dgg_Tests {

    func test_that_if_there_is_a_line_after_the_current_line_then_the_caret_ends_at_the_firstNonBlankLimit_of_that_line_after_it_deleted_up_to_the_beginning_of_the_text() {
        let textInAXFocusedElement = """
  ok so now we're having multiple lines
and we will NOT be on the last one so after dgg
deletes a ton of shits the caret will go at the
first non blank limit
    😂️f the next line (which means this one)
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, "    😂️f the next line (which means this one)")
        XCTAssertEqual(accessibilityElement.caretLocation, 4)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
        
    }
    
}
 
