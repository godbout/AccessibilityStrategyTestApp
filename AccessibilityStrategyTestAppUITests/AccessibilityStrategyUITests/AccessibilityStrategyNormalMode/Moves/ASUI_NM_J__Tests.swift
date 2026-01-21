import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_NM_J__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        return applyMove { asNormalMode.J(on: $0, VimEngineState(appFamily: appFamily)) }
    }
    
}


extension ASUI_NM_J__Tests {
    
    func test_that_in_normal_setting_it_replaces_the_Newline_at_the_end_of_the_current_line_by_a_space() {
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
    
    func test_that_if_the_next_line_is_an_EmptyLine_it_does_not_replace_the_Newline_by_space_but_instead_deletes_it() {
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


// PGR and Electron
extension ASUI_NM_J__Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
gonna try to fuse line 1
with line 2
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, """
gonna try to fuse line 1 with line 2
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 24)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
    }
        
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
gonna try to fuse line 1
with line 2
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, """
gonna try to fuse line 1 with line 2
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 24)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
    }
    
}

