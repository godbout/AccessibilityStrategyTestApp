import XCTest
@testable import AccessibilityStrategy
import Common


// if some tests feel "wrong" because they end up at the end
// of blank lines is because you forgot that kV uses autoindent
class ASUI_NM_O__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        return applyMove { asNormalMode.O(on: $0, VimEngineState(appFamily: appFamily)) }
    }
    
}


// TextFields
extension ASUI_NM_O__Tests {
    
    func test_that_for_a_TextField_it_does_nothing() {
        let textInAXFocusedElement = "O shouldn't do anything in a TextField!"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(times: 15, on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, "O shouldn't do anything in a TextField!")
        XCTAssertEqual(accessibilityElement.caretLocation, 24)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}


// TextViews
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
        XCTAssertEqual(accessibilityElement.selectedText, "")
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
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
    func test_that_in_normal_setting_it_creates_a_new_line_above_the_current_one() {
        let textInAXFocusedElement = """
tha😄️t's a mu😄️ltiline
an😄️😄️d O will
create a n😄️ew line
abo😄️ve!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.gj(on: $0) }
        applyMove { asNormalMode.E(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()

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
    
    func test_that_if_on_an_empty_line_it_will_still_create_a_line_above() {
        let textInAXFocusedElement = """
there is now

an empty line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
there is now


an empty line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 13)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
    func test_that_if_on_the_last_empty_line_it_creates_a_line_above_and_the_caret_goes_on_that_line() {
        let textInAXFocusedElement = """
now the caret
will be on
the last empty line

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.l(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
now the caret
will be on
the last empty line


"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 45)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
    func test_that_if_on_the_last_non_empty_line_it_creates_a_line_above_and_the_caret_goes_on_that_line() {
        let textInAXFocusedElement = """
now the caret
will be on
the last empty line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.l(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
now the caret
will be on

the last empty line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 25)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
    // this test contains blanks
    func test_that_it_creates_a_line_above_and_goes_to_the_same_indentation_as_the_current_line() {
        let textInAXFocusedElement = """
now there's
    some indent
but it should work
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
now there's
    
    some indent
but it should work
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 16)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}


// PGR and Electron
extension ASUI_NM_O__Tests {
    
    func test_that_if_at_the_first_line_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
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
    
    func test_that_in_other_settings_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
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
    
    func test_that_if_at_the_first_line_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
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
    
    func test_that_in_other_settings_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
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
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_not_overwrite_the_Clipboard() {
        let textInAXFocusedElement = """
tha😄️t's a mu😄️ltiline
an😄️😄️d O will
create a n😄️ew line
abo😄️ve!
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        
        copyToClipboard(text: "some fake shit")
        
        _ = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
    }
    
}
