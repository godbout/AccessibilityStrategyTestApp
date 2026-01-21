import XCTest
import AccessibilityStrategy


// count does not exist for this move
// this move mainly uses a ScreenLine func. tested there.
// here it's just some redundancy to be sure, but not all cases.
class ASUI_NM_gCaret_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement {
        return applyMove { asNormalMode.gCaret(on: $0) }
    }
    
}


// TextFields and TextViews
extension ASUI_NM_gCaret_Tests {
    
    func test_that_in_normal_case_it_goes_to_the_first_non_blank_of_the_line() {
        let textInAXFocusedElement = "    hehe ankulay that's a long like that we gonna wrap"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.caretLocation, 4)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "h")
    }   
    
    func test_that_if_the_text_is_just_spaces_and_no_Newline_then_the_caret_goes_at_the_end_of_the_text() {
        let textInAXFocusedElement = """
a multiline
with a last line
without a linefeed but with spaces
                      
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.zero(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.caretLocation, 85)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
    }
    
}
    

// TextViews
extension ASUI_NM_gCaret_Tests {
    
    func test_that_for_spaces_and_a_Newline_it_stops_before_the_Newline_at_the_correct_end_limit() {
        let textInAXFocusedElement = """
this time the
empty line has a linefeed
                      
 yes
"""        
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.k(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.caretLocation, 61)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
    }

}
