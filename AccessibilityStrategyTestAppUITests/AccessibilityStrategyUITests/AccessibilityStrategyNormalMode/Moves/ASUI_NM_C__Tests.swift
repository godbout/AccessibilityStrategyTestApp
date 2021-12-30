@testable import AccessibilityStrategy
import XCTest


class ASUI_NM_C__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.C(on: $0, pgR: pgR) }
    }
    
}


// copy deleted text
extension ASUI_NM_C__Tests {
    
    func test_that_it_copies_the_deleted_text_in_the_pasteboard() {
        let textInAXFocusedElement = """
C will now work with file lines and is supposed to delete from the caret ☀️ to before the linefeed
and of course this is in the case there is a linefeed at the end of the line.
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.f(times: 3, to: "t", on: $0) }
        copyToClipboard(text: "some fake shit")
        _ = applyMoveBeingTested()
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "te from the caret ☀️ to before the linefeed")
    }
    
}


// both
extension ASUI_NM_C__Tests {
    
    func test_that_if_a_file_line_does_not_end_with_a_linefeed_it_deletes_from_the_caret_to_the_end_of_the_line() {
        let textInAXFocusedElement = """
this time the line will not end with a linefeed so C should delete from the caret till the end!
"""
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.f(times: 2, to: "h", on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
this time t
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 11)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}


// TextViews
extension ASUI_NM_C__Tests {

    func test_that_if_a_file_line_ends_with_a_linefeed_it_deletes_from_the_caret_to_before_that_linefeed() {
        let textInAXFocusedElement = """
C will now work with file lines and is supposed to delete from the caret ☀️ to before the linefeed
and of course this is in the case there is a linefeed at the end of the line.
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.f(times: 3, to: "t", on: $0) }
        let accessibilityElement = applyMoveBeingTested()
                
        XCTAssertEqual(accessibilityElement?.fileText.value, """
C will now work with file lines and is supposed to dele
and of course this is in the case there is a linefeed at the end of the line.
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 55)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
    func test_that_it_does_not_delete_the_linefeed_even_for_an_empty_line() {
        let textInAXFocusedElement = """
now we have an empty line and C should behave

and not delete that fucking shit
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.ge(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
                
        XCTAssertEqual(accessibilityElement?.fileText.value, """
now we have an empty line and C should behave

and not delete that fucking shit
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 46)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }

}


// PGR
extension ASUI_NM_C__Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
C will now work with file lines and is supposed to delete from the caret ☀️ to before the linefeed
and of course this is in the case there is a linefeed at the end of the line.
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.f(times: 3, to: "t", on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
                
        XCTAssertEqual(accessibilityElement?.fileText.value, """
C will now work with file lines and is supposed to del
and of course this is in the case there is a linefeed at the end of the line.
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 54)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}
