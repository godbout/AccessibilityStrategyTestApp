import XCTest
@testable import AccessibilityStrategy


class ASUI_NM_dG__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asNormalMode.dG(on: $0) }
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
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "")        
        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
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
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "  😂️k so now we're having multiple lines")
        XCTAssertEqual(accessibilityElement?.caretLocation, 2)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
        
    }
    
}
 
