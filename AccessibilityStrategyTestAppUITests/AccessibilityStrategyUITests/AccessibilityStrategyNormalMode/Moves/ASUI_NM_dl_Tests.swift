import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_NM_dl_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.dl(times: count, on: $0, &vimEngineState) }
    }
    
}


// TextFields and TextViews
extension ASUI_NM_dl_Tests {
    
    func test_that_in_normal_setting_it_deletes_the_character_after_the_caret_location() {
        let textInAXFocusedElement = "x should delete the right character"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.b(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, "x should delete the right haracter")
        XCTAssertEqual(accessibilityElement.caretLocation, 26)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_if_the_caret_ends_up_after_the_end_limit_then_it_is_moved_back_to_the_end_limit() {
        let textInAXFocusedElement = """
repositionin🇫🇷️o
the block cursor is important!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.ge(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
repositionin🇫🇷️
the block cursor is important!
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 12)
        XCTAssertEqual(accessibilityElement.selectedLength, 5)
    }
    
}


// TextViews
extension ASUI_NM_dl_Tests {

    func test_that_if_the_caret_is_at_the_last_character_of_a_line_that_does_not_end_with_a_Newline_it_deletes_the_last_character_and_goes_back_one_character() {
        let textInAXFocusedElement = """
so we're on the last
character of the last line
that is not an empty line🤡️🤡️
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
so we're on the last
character of the last line
that is not an empty line🤡️
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 73)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
    func test_that_if_the_caret_is_on_an_EmptyLine_it_does_not_delete_the_Newline() {
        let textInAXFocusedElement = """
next line is gonna be empty!

but shouldn't be deleted
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
next line is gonna be empty!

but shouldn't be deleted
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 29)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    // this test helps make sure we handle emojis on the last line properly coz it's been crashing a few times :D
    func test_that_if_it_deletes_the_last_standing_character_of_a_line_it_does_not_jump_to_the_previous_line() {
        let textInAXFocusedElement = """
shouldn't jump up on this line!
☀️
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
shouldn't jump up on this line!

"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 32)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
    }
    
    func test_that_it_should_not_suck_the_next_line() {
        let textInAXFocusedElement = """
💥️
x
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """

x
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 0)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
}


// PGR and Electron
extension ASUI_NM_dl_Tests {
    
    func test_that_in_normal_setting_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = "x should delete the right character"
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.b(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, "x should delete the right haracter")
        XCTAssertEqual(accessibilityElement.caretLocation, 26)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_if_the_caret_is_at_the_last_character_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
so we're on the last
character of the last line
that is not an empty line🤡️🤡️
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.l(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
so we're on the last
character of the last line
that is not an empty line🤡️
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 73)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
    func test_that_in_normal_setting_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = "x should delete the right character"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.b(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, "x should delete the right haracter")
        XCTAssertEqual(accessibilityElement.caretLocation, 26)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_if_the_caret_is_at_the_last_character_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
so we're on the last
character of the last line
that is not an empty line🤡️🤡️
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.l(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
so we're on the last
character of the last line
that is not an empty line🤡️
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 73)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
}
