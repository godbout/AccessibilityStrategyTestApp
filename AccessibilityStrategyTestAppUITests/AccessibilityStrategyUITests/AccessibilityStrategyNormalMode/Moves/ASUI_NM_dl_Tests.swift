import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_NM_dl_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1) -> AccessibilityTextElement {
        var state = VimEngineState()
        
        return applyMoveBeingTested(times: count, &state)
    }
        
    private func applyMoveBeingTested(times count: Int = 1, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return applyMove { asNormalMode.dl(times: count, on: $0, &vimEngineState) }
    }
    
}


// Bip, copy deletion and LYS, AND count
extension ASUI_NM_dl_Tests {
    
    func test_that_for_an_empty_line_it_does_not_Bip_but_does_not_change_the_LastYankStyle_and_does_not_copy_anything() {
        let textInAXFocusedElement = """
next line is gonna be empty!

but shouldn't be deleted
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        copyToClipboard(text: "nope you don't copy mofo")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(&state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "nope you don't copy mofo")
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
    func test_that_when_it_is_not_on_an_empty_line_and_the_newHeadLocation_is_before_the_end_of_the_line_it_does_not_Bip_either_and_sets_the_LastYankStyle_to_Characterwise_and_copies_the_deletion_including_the_character_at_newHeadLocation() {
        let textInAXFocusedElement = "x should delete the right character"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.b(on: $0) }
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(times: 6, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "charac")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
    func test_that_when_it_is_not_on_an_empty_line_and_the_newHeadLocation_is_after_the_end_of_the_line_it_does_not_Bip_either_and_sets_the_LastYankStyle_to_Characterwise_and_copies_the_deletion_without_the_linefeed() {
        let textInAXFocusedElement = """
x should delete the right character
 but also 😂️
we gonna need several lines here
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(times: 128, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "also 😂️")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
}


// Both
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
    
}


// TextViews
extension ASUI_NM_dl_Tests {

    func test_that_if_the_caret_is_at_the_last_character_of_a_line_that_does_not_end_with_a_linefeed_it_deletes_the_last_character_and_goes_back_one_character() {
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
    
    func test_that_if_the_caret_is_on_an_empty_line_it_does_not_delete_the_linefeed() {
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
    
    func test_that_in_normal_setting_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "x should delete the right character"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.b(on: $0) }
        var state = VimEngineState(appFamily: .pgR)
        let accessibilityElement = applyMoveBeingTested(&state)

        XCTAssertEqual(accessibilityElement.fileText.value, "x should delete the rightharacter")
        XCTAssertEqual(accessibilityElement.caretLocation, 25)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_if_the_caret_is_at_the_last_character_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
so we're on the last
character of the last line
that is not an empty line🤡️🤡️
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
      
        applyMove { asNormalMode.h(on: $0) }
        var state = VimEngineState(appFamily: .pgR)
        let accessibilityElement = applyMoveBeingTested(&state)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
so we're on the last
character of the last line
that is not an empty line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 72)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
}
