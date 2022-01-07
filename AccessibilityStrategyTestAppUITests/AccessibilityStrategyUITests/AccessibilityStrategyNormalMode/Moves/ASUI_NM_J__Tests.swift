import XCTest
@testable import AccessibilityStrategy
import VimEngineState


class ASUI_NM_J__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement {
        return applyMove { asNormalMode.J(on: $0, VimEngineState(pgR: pgR)) }
    }
    
}


extension ASUI_NM_J__Tests {
    
    func test_that_in_normal_setting_it_replaces_the_linefeed_at_the_end_of_the_current_line_by_a_space() {
        let textInAXFocusedElement = """
gonna try to fuse line 1
with line 2
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
               
        applyMove { asNormalMode.gg(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
gonna try to fuse line 1 with line 2
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 24)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
    }
    
    func test_that_it_deletes_the_indentation_of_the_next_line() {
        let textInAXFocusedElement = """
gonna try to fuse line 1
    with line 2
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
               
        applyMove { asNormalMode.gg(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
gonna try to fuse line 1 with line 2
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 24)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
    }
    
    func test_that_if_the_next_line_is_an_empty_line_it_does_not_replace_the_linefeed_by_space_but_instead_deletes_it() {
        let textInAXFocusedElement = """
next line is empty and it works differently

LMAO
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
               
        applyMove { asNormalMode.gg(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
next line is empty and it works differently
LMAO
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 42)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "y")
    }
    
}


// PGR
extension ASUI_NM_J__Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
gonna try to fuse line 1
with line 2
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
               
        applyMove { asNormalMode.gg(on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)

        XCTAssertEqual(accessibilityElement.fileText.value, """
gonna try to fuse line   with line 2
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 23)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
    }
        
}

