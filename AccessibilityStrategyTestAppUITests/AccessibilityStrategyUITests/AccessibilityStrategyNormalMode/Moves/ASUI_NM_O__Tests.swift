import XCTest
@testable import AccessibilityStrategy
import Common


// see ASUT O for blah blah
class ASUI_NM_O__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        return applyMove { asNormalMode.O(on: $0, VimEngineState(appFamily: appFamily)) }
    }
    
}

// TextViews (only first line needs UIT. others are in UT.)
extension ASUI_NM_O__Tests {
    
    func test_that_if_at_the_first_line_it_creates_a_new_line_above_and_reposition_the_caret_on_that_new_line() {
        let textInAXFocusedElement = """
caret on the first
line and it should
still create a line above
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
               
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.dollarSign(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """

caret on the first
line and it should
still create a line above
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 0)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
    }
    
    func test_that_if_keeps_the_indentation_even_if_it_is_on_the_first_line() {
        let textInAXFocusedElement = """
   now indent on the first line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)

        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
   
   now indent on the first line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 3)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
    }
    
}


// PGR and Electron
extension ASUI_NM_O__Tests {
    
    func test_that_if_at_the_first_line_when_it_is_called_in_PGR_Mode_it_does_delete_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
caret on the first
line and it should
still create a line above
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
               
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.dollarSign(on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, """

caret on the first
line and it should
still create a line above
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 0)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
    func test_that_in_other_settings_when_it_is_called_in_PGR_Mode_it_does_delete_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
tha😄️t's a mu😄️ltiline
an😄️😄️d O will
create a n😄️ew line
abo😄️ve!
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
               
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.j(on: $0) }
        applyMove { asNormalMode.f(times: 1, to: "d", on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, """
tha😄️t's a mu😄️ltiline

an😄️😄️d O will
create a n😄️ew line
abo😄️ve!
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 25)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
    func test_that_if_at_the_first_line_when_it_is_called_in_PGR_Mode_it_does_delete_and_deletes_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
caret on the first
line and it should
still create a line above
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
               
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.dollarSign(on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, """

caret on the first
line and it should
still create a line above
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 0)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
    func test_that_in_other_settings_when_it_is_called_in_PGR_Mode_it_does_delete_and_deletes_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
tha😄️t's a mu😄️ltiline
an😄️😄️d O will
create a n😄️ew line
abo😄️ve!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
               
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.j(on: $0) }
        applyMove { asNormalMode.f(times: 1, to: "d", on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, """
tha😄️t's a mu😄️ltiline

an😄️😄️d O will
create a n😄️ew line
abo😄️ve!
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 25)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}
