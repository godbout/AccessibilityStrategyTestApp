import XCTest
@testable import AccessibilityStrategy
import Common


// `d` moves always need to be tested in UIT because they have to call the AX
// the reposition the caret after the move.
class ASUI_VMC_d_Tests: ASUI_VM_BaseTests {

    var vimEngineState = VimEngineState(visualStyle: .characterwise)
    
    
    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        vimEngineState.appFamily = appFamily
        
        return applyMove { asVisualMode.d(on: $0, &vimEngineState) }
    }

}


extension ASUI_VMC_d_Tests {
    
    func test_that_it_simply_deletes_the_selection() {
        let textInAXFocusedElement = """
all that VM d does
in characterwi😂️e is deleting
the selection!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.zero(on: $0, vimEngineState) }
        applyMove { asVisualMode.b(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
all that VM d 😂️e is deleting
the selection!
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 14)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
    func test_that_if_there_is_only_one_character_on_a_line_deleting_it_stays_on_the_line_and_does_not_go_to_the_linefeed_of_the_above_line() {
        let textInAXFocusedElement = """
if deleting the last character of
x
should go back to line end limit
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
if deleting the last character of

should go back to line end limit
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 34)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_if_the_caret_is_on_an_empty_line_it_deletes_the_linefeed_and_stick_the_next_line_up() {
        let textInAXFocusedElement = """
there's gonna be an empty line

⛱️ight above
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
there's gonna be an empty line
⛱️ight above
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 31)
        XCTAssertEqual(accessibilityElement.selectedLength, 2)
    }
    
    func test_that_when_the_selection_spans_on_a_single_line_if_after_deletion_the_caret_ends_up_after_the_line_limit_then_it_is_moved_back_to_the_end_limit() {
        let textInAXFocusedElement = """
if deleting the last character of
a line before the linefeed the ⛱️caret
should go back to line end limit
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.e(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.b(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
if deleting the last character of
a line before the linefeed the ⛱️
should go back to line end limit
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 65)
        XCTAssertEqual(accessibilityElement.selectedLength, 2)
    }
    
    func test_that_when_the_selection_spans_on_multiple_lines_if_after_deletion_the_caret_ends_up_after_the_line_limit_then_it_is_moved_back_to_the_end_limit() throws {
        let textInAXFocusedElement = """
same as above
but on multiple
lines this time
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.gj(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
same as abov
lines this time
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 11)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_if_the_caret_is_at_the_last_character_of_the_TextElement_and_on_an_empty_line_it_works_and_the_caret_goes_to_the_relevant_position() {
        let textInAXFocusedElement = """
caret is on its
own empty
    line

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.l(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
caret is on its
own empty
    line

"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 35)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
    }
    
}


// PGR and Electron
extension ASUI_VMC_d_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
all that VM d does
in characterwi😂️e is deleting
the selection!
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.zero(on: $0, vimEngineState) }
        applyMove { asVisualMode.b(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, """
all that VM d 😂️e is deleting
the selection!
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 14)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
        XCTAssertEqual(accessibilityElement.selectedText, "😂️")
    }
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
all that VM d does
in characterwi😂️e is deleting
the selection!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.zero(on: $0, vimEngineState) }
        applyMove { asVisualMode.b(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, """
all that VM d 😂️e is deleting
the selection!
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 14)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
        XCTAssertEqual(accessibilityElement.selectedText, "😂️")
    }
    
}
