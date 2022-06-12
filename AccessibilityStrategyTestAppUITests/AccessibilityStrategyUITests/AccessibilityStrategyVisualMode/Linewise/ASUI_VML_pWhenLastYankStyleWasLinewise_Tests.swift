import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_VML_pWhenLastYankStyleWasLinewise_Tests: ASUI_VM_BaseTests {
    
    var state = VimEngineState(visualStyle: .linewise)
    
           
    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        return applyMove { asVisualMode.p(on: $0, VimEngineState(appFamily: appFamily, lastYankStyle: .linewise, visualStyle: state.visualStyle)) }
    }
    
}


// TextFields
extension ASUI_VML_pWhenLastYankStyleWasLinewise_Tests {
    
    func test_that_it_replaces_the_current_Linewise_selection_and_the_block_cursor_goes_to_the_firstNonBlank_and_if_the_previously_copied_Linewise_text_had_a_linefeed_it_removes_it() {
        let textInAXFocusedElement = "gonna select the whole line and replace it and remove linefeed in copied text"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asVisualMode.VFromNormalMode(on: $0) }
        
        copyToClipboard(text: "  😂️ext to be copied\n")
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, "  😂️ext to be copied")
        XCTAssertEqual(accessibilityElement.caretLocation, 2)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }

}


// TextAreas
extension ASUI_VML_pWhenLastYankStyleWasLinewise_Tests {
    
    func test_that_in_normal_setting_it_replaces_the_current_Linewise_selection_with_the_previously_copied_Linewise_text() {
        let textInAXFocusedElement = """
that case is basically why i'm implementing this move :D
because before i would copy or delete some
lines, i would paste them above or under where
i wanted them, and delete the old ones. but everything
can be done in one go with VM P!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(times: 2, on: $0) }
        applyMove { asVisualMode.VFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, state) }
        copyToClipboard(text: """
😂️his is what we want
to paste hehe
"""
        )
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
that case is basically why i'm implementing this move :D
😂️his is what we want
to paste hehe
i wanted them, and delete the old ones. but everything
can be done in one go with VM P!
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 57)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
    func test_that_it_replaces_the_current_Linewise_selection_and_if_the_previously_copied_Linewise_text_did_not_have_a_linefeed_it_will_add_the_linefeed_if_we_are_not_on_the_last_line() {
        let textInAXFocusedElement = """
if the selection doesn't include the last line
then pasting will add a linefeed to the previously copied text
even if there was none
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asVisualMode.VFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, state) }
        copyToClipboard(text: "this copied line has no linefeed!")
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
this copied line has no linefeed!
even if there was none
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 0)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_it_replaces_the_current_Linewise_selection_and_that_if_that_selection_includes_the_lastLine_it_removes_the_last_linefeed_from_the_text_to_copy() {
        let textInAXFocusedElement = """
if the selection includes the last line
we gonna have to remove the
linefeed from the copied text
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(times: 2, on: $0) }
        applyMove { asVisualMode.VFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, state) }

        copyToClipboard(text: "new line to paste after last line\n")
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
if the selection includes the last line
new line to paste after last line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 40)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_it_replaces_the_current_Linewise_selection_and_that_the_block_cursor_goes_to_the_first_non_blank_of_the_firstLine_of_the_pasted_text() {
        let textInAXFocusedElement = """
caret needs to go
to the first non blank
of new pasted text
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asVisualMode.VFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, state) }
        copyToClipboard(text: """
    there's some
identations here
"""
        )
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
    there's some
identations here
of new pasted text
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 4)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }

}


// PGR and Electron
extension ASUI_VML_pWhenLastYankStyleWasLinewise_Tests {
    
    func test_that_on_TextFields_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "check that it works in PGR too"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asVisualMode.VFromNormalMode(on: $0) }
        copyToClipboard(text: "pasta\n")
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, "pastapasta")
        XCTAssertEqual(accessibilityElement.caretLocation, 0)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "p")
    }
    
    func test_that_on_TextAreas_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
it's gonna paste twice coz
PGR
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asVisualMode.VFromNormalMode(on: $0) }
        copyToClipboard(text: "  should paste that somewhere\n")
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
  should paste that somewhere
  should paste that somewhere
PGR
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 2)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "s")
    }

}
