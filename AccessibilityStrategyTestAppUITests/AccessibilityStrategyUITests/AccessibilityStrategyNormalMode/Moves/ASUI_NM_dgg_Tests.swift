import XCTest
@testable import AccessibilityStrategy


// there's no way to test PGR for this move. if you can't remember why think harder.
class ASUI_NM_dgg_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement {
        return applyMove { asNormalMode.dgg(on: $0, pgR: pgR) }
    }
    
}


// Both
extension ASUI_NM_dgg_Tests {
    
    func test_that_if_we_are_on_the_last_line_then_it_deletes_the_whole_text() {
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
 
