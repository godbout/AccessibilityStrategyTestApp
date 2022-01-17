import XCTest
@testable import AccessibilityStrategy
import VimEngineState


// careful. dip is special in the sense that blank lines are paragraphy boundaries, which is not the case with {}
class ASUI_NM_dip_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(_ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return applyMove { asNormalMode.dip(on: $0, &vimEngineState) }
    }
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement {
        var state = VimEngineState(pgR: pgR)
        
        return applyMoveBeingTested(&state)
    }
    
}


// Bip, copy deletion and LYS
extension ASUI_NM_dip_Tests {
    
//    func test_that_if_the_caret_is_at_the_start_of_a_line_it_does_not_Bip_and_does_not_change_the_LastYankStyle_and_does_not_copy_anything() {
//        let textInAXFocusedElement = """
//so we're at the start of the second line
//and a shouldn't get deleted and
//we should stay there
//"""
//        app.textViews.firstMatch.tap()
//        app.textViews.firstMatch.typeText(textInAXFocusedElement)
//      
//        applyMove { asNormalMode.k(on: $0) }
//        applyMove { asNormalMode.zero(on: $0) }
//        
//        copyToClipboard(text: "nope you don't copy mofo")
//        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
//        _ = applyMoveBeingTested(&state)
//        
//        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "nope you don't copy mofo")
//        XCTAssertEqual(state.lastYankStyle, .linewise)
//        XCTAssertFalse(state.lastMoveBipped)
//    }
//    
//    func test_that_else_it_also_does_not_Bip_but_change_the_LastYankStyle_to_Characterwise_and_copies_the_deletion() {
//        let textInAXFocusedElement = "X should delete the right character😂️😂️😂️😂️"
//        app.textFields.firstMatch.tap()
//        app.textFields.firstMatch.typeText(textInAXFocusedElement)
//
//        applyMove { asNormalMode.b(on: $0) }
//        
//        copyToClipboard(text: "some fake shit")
//        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
//        _ = applyMoveBeingTested(&state)
//        
//        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "😂️")
//        XCTAssertEqual(state.lastYankStyle, .characterwise)
//        XCTAssertFalse(state.lastMoveBipped)
//    }
    
}


// Both
extension ASUI_NM_dip_Tests {
    
    func test_that_if_there_is_no_empty_or_blank_line_before_and_after_then_it_deletes_the_whole_content() {
        let textInAXFocusedElement = "for dip blank lines are also a paragraph boundary. that is an exception."
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.b(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, "")
        XCTAssertEqual(accessibilityElement.caretLocation, 0)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
    }
    
}


// TextViews
extension ASUI_NM_dip_Tests {
    
    // actually gonna work on `innerParagraph` first!
//    func test_that_if_there_is_an_empty_line_before_but_none_after_then_

    
}


// PGR
extension ASUI_NM_dip_Tests {
    
    func test_that_in_normal_setting_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "X should delete the right character😂️😂️😂️😂️"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.b(on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)

        XCTAssertEqual(accessibilityElement.fileText.value, "X should delete the right charact😂️😂️😂️😂️")
        XCTAssertEqual(accessibilityElement.caretLocation, 33)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
}
