import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_VML_d_Tests: ASUI_VM_BaseTests {

    var vimEngineState = VimEngineState(visualStyle: .linewise)
    
    
    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: appFamily, visualStyle: .linewise)
        
        return applyMove { asVisualMode.d(on: $0, &vimEngineState) }
    }

}


// TextFields and TextViews
extension ASUI_VML_d_Tests {
    
    func test_that_it_deletes_line_and_the_caret_will_go_to_the_first_non_blank_of_the_next_line_that_is_taking_over() {
        let textInAXFocusedElement = """
we gonna use VM
d here and we suppose
one extra line in between!
      ⛱️o go to non blank of the line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.VFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested()
                     
        XCTAssertEqual(accessibilityElement.fileText.value, """
we gonna use VM
      ⛱️o go to non blank of the line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 22)
        XCTAssertEqual(accessibilityElement.selectedLength, 2)
    }
    
    func test_that_the_caret_will_go_the_the_end_limit_of_the_next_line_if_the_next_line_is_just_made_of_spaces() {
        let textInAXFocusedElement = """
we gonna use VM
d here and we suppose
just adding random lines
        
some more
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asVisualMode.VFromNormalMode(on: $0) }
        applyMove { asVisualMode.gj(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
we gonna use VM
        
some more
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 23)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_if_the_next_line_is_only_blanks_the_caret_goes_to_the_limit_of_the_line_before_the_linefeed() {
        let textInAXFocusedElement = """
we gonna use VM
d here and we suppose
another line agan
      to go to non blank of the line
         
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.VFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
we gonna use VM
d here and we suppose
         
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 46)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_removing_the_last_line_puts_the_caret_at_the_first_non_blank_of_the_previous_line() {
        let textInAXFocusedElement = """
   ⛱️e gonna remove the last
line and caret should go up
and it would be beautiful
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.VFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
   ⛱️e gonna remove the last
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 3)
        XCTAssertEqual(accessibilityElement.selectedLength, 2)
    }
    
    func test_that_if_the_head_is_before_the_anchor_it_works() {
        let textInAXFocusedElement = """
   we gonna remove the last
line and caret should go up
and it would be beautiful
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.VFromNormalMode(on: $0) }
        applyMove { asVisualMode.k(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
   we gonna remove the last
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 3)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_if_the_head_and_the_anchor_are_equal_it_works() {
        let textInAXFocusedElement = """
empty line!!!

yes there is
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.VFromNormalMode(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
empty line!!!
yes there is
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 14)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)    
    }
    
    func test_that_if_the_whole_text_is_to_be_deleted_well_it_gets_deleted_LOL() {
        let textInAXFocusedElement = """
blah blah blah
blah blah
blah
t
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asVisualMode.VFromNormalMode(on: $0) }
        applyMove { asVisualMode.gk(on: $0, vimEngineState) }
        applyMove { asVisualMode.gk(on: $0, vimEngineState) }
        applyMove { asVisualMode.gk(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, "")
        XCTAssertEqual(accessibilityElement.caretLocation, 0)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
    }
    
}


// PGR and Electron
// yes, one case cannot be tested here.
extension ASUI_VML_d_Tests {
    
    func test_that_if_there_is_a_next_line_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
we gonna use VM
d here and we suppose
one extra line in between!
      ⛱️o go to non blank of the line
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.VFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
                     
        XCTAssertEqual(accessibilityElement.fileText.value, """
we gonna use VM
      ⛱️o go to non blank of the line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 22)
        XCTAssertEqual(accessibilityElement.selectedLength, 2)
        XCTAssertEqual(accessibilityElement.selectedText, "⛱️")
    }
    
    func test_that_if_there_is_no_next_line_and_there_is_a_previous_line_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
   ⛱️e gonna remove the last
line and caret should go up
and it would be beautiful
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.VFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, """
   ⛱️e gonna remove the last
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 3)
        XCTAssertEqual(accessibilityElement.selectedLength, 2)
        XCTAssertEqual(accessibilityElement.selectedText, "⛱️")
    }

    func test_that_if_there_is_a_next_line_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
we gonna use VM
d here and we suppose
one extra line in between!
      ⛱️o go to non blank of the line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.VFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
                     
        XCTAssertEqual(accessibilityElement.fileText.value, """
we gonna use VM
      ⛱️o go to non blank of the line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 22)
        XCTAssertEqual(accessibilityElement.selectedLength, 2)
        XCTAssertEqual(accessibilityElement.selectedText, "⛱️")
    }
    
    func test_that_if_there_is_no_next_line_and_there_is_a_previous_line_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
   ⛱️e gonna remove the last
line and caret should go up
and it would be beautiful
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asVisualMode.VFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, """
   ⛱️e gonna remove the last
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 3)
        XCTAssertEqual(accessibilityElement.selectedLength, 2)
        XCTAssertEqual(accessibilityElement.selectedText, "⛱️")
    }

}
