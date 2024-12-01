import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_NM_cl_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.cl(times: count, on: $0, &vimEngineState) }
    }
    
}


// count
extension ASUI_NM_cl_Tests {
    
    func test_that_it_implements_the_count_system() {
        let textInAXFocusedElement = """
testing with count
should be awesome to use
  😂️ctually nobody uses counts
LMAO
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(times: 4)

        XCTAssertEqual(accessibilityElement.fileText.value, """
ing with count
should be awesome to use
  😂️ctually nobody uses counts
LMAO
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 0)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
    // this test contains blanks
    func test_that_if_the_count_is_too_high_it_stops_at_the_end_limit_of_the_line() {
        let textInAXFocusedElement = """
testing with count
should be awesome to use
  😂️ctually nobody uses counts
LMAO
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.b(times: 8, on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(times: 68)

        XCTAssertEqual(accessibilityElement.fileText.value, """
testing with count
should be awesome 
  😂️ctually nobody uses counts
LMAO
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 37)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}


// Both
extension ASUI_NM_cl_Tests {
    
    func test_that_in_normal_setting_it_deletes_the_character_at_caret_location() {
        let textInAXFocusedElement = " cl to delete a character on the right"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.F(times: 2, to: "a", on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, " cl to delete a chracter on the right")
        XCTAssertEqual(accessibilityElement.caretLocation, 18)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}


// TextViews
extension ASUI_NM_cl_Tests {
    
    func test_that_on_an_empty_line_it_does_not_delete_the_linefeed_and_deselects_the_linefeed() {
        let textInAXFocusedElement = """
  blah blah some line

haha geh
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
  blah blah some line

haha geh
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 22)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}


// PGR and Electron
extension ASUI_NM_cl_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = "x should delete the right character"
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.b(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, "x should delete the right haracter")
        XCTAssertEqual(accessibilityElement.caretLocation, 26)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
    }
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = "x should delete the right character"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.b(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, "x should delete the right haracter")
        XCTAssertEqual(accessibilityElement.caretLocation, 26)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
    }
    
}
