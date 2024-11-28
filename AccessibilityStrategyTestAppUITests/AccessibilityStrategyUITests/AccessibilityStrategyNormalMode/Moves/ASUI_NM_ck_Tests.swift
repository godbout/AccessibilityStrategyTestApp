@testable import AccessibilityStrategy
import XCTest
import Common


class ASUI_NM_ck_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.ck(on: $0, &state) }
    }
    
}


// Both
extension ASUI_NM_ck_Tests {
    
    func test_that_if_the_caret_is_on_the_firstLine_it_does_not_move() {
        let textInAXFocusedElement = "the caret is on the  😂️ first line"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.b(times: 3, on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, "the caret is on the  😂️ first line")
        XCTAssertEqual(accessibilityElement.caretLocation, 21)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
        XCTAssertEqual(accessibilityElement.selectedText, "😂️")
    }
    
}


// TextViews
extension ASUI_NM_ck_Tests {
    
    func test_that_in_normal_setting_it_can_delete_the_currentFileLine_and_the_one_above_but_excludes_the_linefeed_of_the_currentFileLine_if_any() {
        let textInAXFocusedElement = """
ok real shit now
come on ck is useful
sometimes
no?
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        // TODO: for the UT moved to the UI, we can simplify what's below
        // we did it to match the UT but the UT were done manually so we couldn't
        // place the block cursor wherever we wanted. makes no sense for the UIs
        // coz that make them look more complicated than needed
        applyMove { asNormalMode.l(on: $0 ) }
        applyMove { asNormalMode.b(times: 2, on: $0) }
        applyMove { asNormalMode.f(to: "e", on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
ok real shit now

no?
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 17)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
    // this test contains blanks
    func test_that_it_goes_to_the_firstNonBlank_of_the_line_above() {
        let textInAXFocusedElement = """
this moves does not go to the
   beginning of the line actually
but to the first non blank
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.l(on: $0 ) }
        applyMove { asNormalMode.b(times: 2, on: $0) }
        applyMove { asNormalMode.l(on: $0 ) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
this moves does not go to the
   
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 33)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
    // this test contains blanks
    func test_that_if_the_line_above_is_just_blanks_or_linefeed_and_the_currentFileLine_is_the_lastLine_the_caret_ends_up_at_the_end_of_the_line_above() {
        let textInAXFocusedElement = """
this moves does not go to the
                        
but to the first non blank
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.l(on: $0 ) }
        applyMove { asNormalMode.b(times: 2, on: $0) }
        applyMove { asNormalMode.l(on: $0 ) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
this moves does not go to the
                        
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 54)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
   
}


// PGR and Electron
extension ASUI_NM_ck_Tests {

    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
but the indent should
   i delete a line
be kept
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.b(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
but the indent should
   
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 25)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
but the indent should
   i delete a line
be kept
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.b(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
but the indent should
   
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 25)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}
