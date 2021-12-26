import XCTest
@testable import AccessibilityStrategy


class ASUI_NM_dh_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.dh(on: $0, pgR: pgR) }
    }
    
}


// copy deleted text
extension ASUI_NM_dh_Tests {
    
    // this case does include empty lines
    func test_that_for_if_the_caret_is_at_the_start_of_a_line_it_not_copy_the_deleted_text_to_the_pasteboard() {
        let textInAXFocusedElement = """
so we're at the start of the second line
and a shouldn't get deleted and
we should stay there
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
      
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("nope you don't copy mofo", forType: .string)
        _ = applyMoveBeingTested()
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "nope you don't copy mofo")
    }
    
    func test_that_else_it_copies_the_deleted_text_in_the_pasteboard() {
        let textInAXFocusedElement = "X should delete the right character😂️😂️😂️😂️"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.b(on: $0) }
        _ = applyMoveBeingTested()
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "😂️")
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

        XCTAssertEqual(accessibilityElement?.fileText.value, "X should delete the right characte😂️😂️😂️😂️")
        XCTAssertEqual(accessibilityElement?.caretLocation, 34)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
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
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
so we're at the start of the second line
and a shouldn't get deleted and
we should stay there
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 41)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
}


// PGR
extension ASUI_NM_dh_Tests {
    
    func test_that_in_normal_setting_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "X should delete the right character😂️😂️😂️😂️"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.b(on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)

        XCTAssertEqual(accessibilityElement?.fileText.value, "X should delete the right charact😂️😂️😂️😂️")
        XCTAssertEqual(accessibilityElement?.caretLocation, 33)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }
    
}
