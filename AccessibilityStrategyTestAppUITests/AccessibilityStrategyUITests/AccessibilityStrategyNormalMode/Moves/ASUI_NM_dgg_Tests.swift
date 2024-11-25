import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_NM_dgg_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(_ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return applyMove { asNormalMode.dgg(on: $0, &vimEngineState) }
    }
    
    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMoveBeingTested(&state)
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
 

// PGR and Electron
extension ASUI_NM_dgg_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
  ok so now we're having multiple lines
and we will NOT be on the last one so after dgg
deletes a ton of shits the caret will go at the
first non blank limit
    😂️f the next line (which means this one)
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, "    😂️f the next line (which means this one)")
        XCTAssertEqual(accessibilityElement.caretLocation, 4)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }

    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
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
