import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_VMC_pWhenLastYankStyleWasLinewise_Tests: ASUI_VM_BaseTests {
    
    var state = VimEngineState(lastYankStyle: .linewise, visualStyle: .characterwise)
    
    
    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        state.appFamily = appFamily
        
        return applyMove { asVisualMode.p(on: $0, &state) }
    }
    
}


// TextFields
extension ASUI_VMC_pWhenLastYankStyleWasLinewise_Tests {
    
    func test_that_it_replaces_the_current_Characterwise_selection_and_the_block_cursor_ends_up_at_the_end_of_the_copied_text_and_if_the_previously_copied_Linewise_text_had_a_linefeed_it_removes_it() {
        let textInAXFocusedElement = "linewise for TF is still pasted characterwise!"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.b(times: 4, on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.e(times: 2, on: $0, state) }
        copyToClipboard(text: "text to pasta\n")
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, "linewise for TF text to pasta pasted characterwise!")
        XCTAssertEqual(accessibilityElement.caretLocation, 28)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_for_TF_the_replaced_text_is_copied_and_available_in_the_Pasteboard_and_that_it_changes_the_LYS_to_Characterwise() {
        let textInAXFocusedElement = "gonna select the whole line and replace it and remove linefeed in copied text"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.b(times: 4, on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.e(times: 2, on: $0, state) }
        
        copyToClipboard(text: "  😂️ext to be copied\n")
        
        _ = applyMoveBeingTested()
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "linefeed in")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
    }
    
}


// TextAreas
extension ASUI_VMC_pWhenLastYankStyleWasLinewise_Tests {
    
    func test_that_in_normal_setting_it_replaces_the_current_Characterwise_selection_and_pastes_the_copied_text_on_a_new_line_below() {
        let textInAXFocusedElement = """
the Characterwise selection is gonna
be replaced and the new copied
text is gonna start on its
own line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.e(times: 2, on: $0, state) }
        copyToClipboard(text: """
some new lines
for you
""")
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
the 
some new lines
for you
 is gonna
be replaced and the new copied
text is gonna start on its
own line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 5)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_it_replaces_the_current_Characterwise_selection_and_adds_a_linefeed_to_the_copied_text_if_the_selection_does_not_on_include_the_lastLine() {
        let textInAXFocusedElement = """
the copied text
really ends up
on its own lines
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.w(on: $0, state) }
        copyToClipboard(text: "we pasted the last line so no linefeed")
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
the 
we pasted the last line so no linefeed
ext
really ends up
on its own lines
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 5)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_it_replaces_the_current_Characterwise_selection_and_the_block_cursor_goes_to_the_firstNonBlank_of_the_copied_text() {
        let textInAXFocusedElement = """
always go
to the first non blank!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.e(times: 3, on: $0, state) }
        copyToClipboard(text: "   🤍️he copied line has 🤍️🤍️🤍️ non blanks\n")
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
always go

   🤍️he copied line has 🤍️🤍️🤍️ non blanks
 non blank!
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 14)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
    func test_that_for_TA_the_replaced_text_is_copied_and_available_in_the_Pasteboard_and_that_it_changes_the_LYS_to_Characterwise() {
        let textInAXFocusedElement = """
what is being selected
and replaced
is gonna get copied
in the clipboard
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(times: 2, on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, state) }
        
        copyToClipboard(text: "text to pasta\nhere and there")
               
        _ = applyMoveBeingTested()

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "replaced\nis go")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
    }
    
}


// PGR and Electron
extension ASUI_VMC_pWhenLastYankStyleWasLinewise_Tests {
   
    func test_that_on_TextFields_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "check that it works in PGR too"
        app.webViews.firstMatch.tap()
        app.webViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.w(times: 2, on: $0, state) }
        copyToClipboard(text: "some\npasta\n")
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, """
some
pastasome
pastat works in PGR too
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 19)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "a")
    }
    
    func test_that_on_TextAreas_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
it's gonna paste twice coz
PGR
"""
        app.webViews.firstMatch.tap()
        app.webViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.ge(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.w(times: 2, on: $0, state) }
        copyToClipboard(text: "  should paste\nthat somewhere")
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
it's gonna paste twic
  should paste
that somewhere

  should paste
that somewhere
GR
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 24)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "s")
    }
    
}
