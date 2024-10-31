import XCTest
@testable import AccessibilityStrategy
import Common


// dh calls ch so usually we would need to only test the caret repositioning after the c move
// but we may have started with dh before ch here. hence more tests.
class ASUI_NM_dh_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return applyMove { asNormalMode.dh(times: count, on: $0, &vimEngineState) }
    }
    
    private func applyMoveBeingTested(times count: Int = 1, appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMoveBeingTested(times: count, &state)
    }
    
}


// Bip, copy deletion and LYS, AND count
extension ASUI_NM_dh_Tests {
    
    // this case includes empty lines
    func test_that_if_the_caret_is_at_the_start_of_a_line_it_does_not_Bip_and_does_not_change_the_LastYankStyle_and_does_not_copy_anything() {
        let textInAXFocusedElement = """
so we're at the start of the second line
and a shouldn't get deleted and
we should stay there
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
      
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        
        copyToClipboard(text: "nope you don't copy mofo")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(&state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "nope you don't copy mofo")
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
    func test_that_if_the_newCaretLocation_after_the_move_ends_up_at_the_start_of_the_line_then_it_does_not_Bip_but_change_the_LastYankStyle_to_Characterwise_and_copies_the_deletion_up_to_the_start_of_the_line() {
        let textInAXFocusedElement = "X should delete the right character😂️😂️😂️😂️"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.b(on: $0) }
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(times: 5, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "acter")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
    func test_that_if_the_newCaretLocation_after_the_move_ends_up_after_the_start_of_the_line_then_it_does_not_Bip_but_change_the_LastYankStyle_to_Characterwise_and_copies_the_deletion_up_to_the_newCaretLocation() {
        let textInAXFocusedElement = "X should delete the right character😂️😂️😂️😂️"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.b(on: $0) }
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(times: 128, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "X should delete the right character")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
}


// Both
extension ASUI_NM_dh_Tests {
    
    func test_that_in_normal_setting_it_deletes_the_character_before_the_caret_location() {
        let textInAXFocusedElement = "X should delete the right character😂️😂️😂️😂️"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.b(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, "X should delete the right characte😂️😂️😂️😂️")
        XCTAssertEqual(accessibilityElement.caretLocation, 34)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
}


// TextViews
extension ASUI_NM_dh_Tests {

    func test_that_if_the_caret_is_at_the_start_of_the_file_line_it_does_not_delete_nor_move() {
        let textInAXFocusedElement = """
so we're at the start of the second line
and a shouldn't get deleted and
we should stay there
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
      
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
so we're at the start of the second line
and a shouldn't get deleted and
we should stay there
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 41)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
}


// PGR and Electron
extension ASUI_NM_dh_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = "X should delete the right character😂️😂️😂️😂️"
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.b(on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, "X should delete the right characte😂️😂️😂️😂️")
        XCTAssertEqual(accessibilityElement.caretLocation, 34)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_and_deletes_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = "X should delete the right character😂️😂️😂️😂️"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.b(on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, "X should delete the right characte😂️😂️😂️😂️")
        XCTAssertEqual(accessibilityElement.caretLocation, 34)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
}
