@testable import AccessibilityStrategy
import XCTest


class ASUI_NM_cc_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.cc(on: $0, pgR: pgR) }
    }
    
}


// both
extension ASUI_NM_cc_Tests {
    
    func test_that_if_a_file_line_ends_with_a_linefeed_it_deletes_up_to_but_not_including_the_linefeed() {
        let textInAXFocusedElement = """
looks like it's late coz it's getting harder to reason
but actually it's only 21.43 LMAOOOOOOOO
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.f(times: 1, to: "h", on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """

but actually it's only 21.43 LMAOOOOOOOO
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
    func test_that_if_a_file_line_does_not_end_with_a_linefeed_it_deletes_up_to_the_end() {
        let textInAXFocusedElement = "yeah exactly, it could be at the end of 🌻️🌻️🌻️ a TextArea or like a TextField like this one"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.F(to: "f", on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "")
        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
    func test_that_it_should_keep_the_indentation_of_the_current_line() {
        let textInAXFocusedElement = """
but the indent should
   i delete a line
be kept
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gk(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
but the indent should
   
be kept
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 25)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
    func test_that_if_a_file_line_is_a_blank_line_it_does_not_delete_anything_and_goes_at_the_end_of_the_line_before_the_linefeed() {
        let textInAXFocusedElement = """
something
            
  something else
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gk(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
something
            
  something else
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 22)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}


// PGR
extension ASUI_NM_cc_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
but the indent should
   i delete a line
be kept
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gk(on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
but the indent should
  
be kept
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 24)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}
