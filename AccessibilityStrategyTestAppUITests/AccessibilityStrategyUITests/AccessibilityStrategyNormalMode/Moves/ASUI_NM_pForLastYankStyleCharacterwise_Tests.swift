import XCTest
@testable import AccessibilityStrategy


class ASUI_NM_pForLastYankStyleCharacterwise_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.pForLastYankStyleCharacterwise(on: $0, pgR: pgR) }
    }
    
}


// TextFields
extension ASUI_NM_pForLastYankStyleCharacterwise_Tests {
    
    func test_that_in_normal_setting_it_pastes_the_text_after_the_block_cursor_and_the_block_cursor_ends_up_at_the_end_of_the_pasted_text() {
        let textInAXFocusedElement = "we go😂️😂️😂️nna paste some 💩️"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("text to 🥞️🥞️🥞️ paste!!!🥠️", forType: .string)

        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.fileText.value, "we go😂️😂️😂️nna paste some 💩️text to 🥞️🥞️🥞️ paste!!!🥠️")
        XCTAssertEqual(accessibilityElement?.caretLocation, 58)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }
    
}


// TextAreas
extension ASUI_NM_pForLastYankStyleCharacterwise_Tests {
    
    func test_that_in_normal_setting_it_pastes_the_text_after_the_block_cursor_and_if_the_text_does_not_contain_a_linefeed_the_block_cursor_ends_up_at_the_end_of_the_pasted_text() {
        let textInAXFocusedElement = """
time to paste
in TextViews
ho ho ho
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.h(on: $0) }

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("pastaing", forType: .string)
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
time to paste
in pastaingTextViews
ho ho ho
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 24)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
    func test_that_in_normal_setting_it_pastes_the_text_after_the_block_cursor_and_if_the_text_contains_a_linefeed_the_block_cursor_ends_up_at_the_beginning_of_the_pasted_text() {
        let textInAXFocusedElement = """
time to paste
in TextViews
ho ho ho
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.h(on: $0) }

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("😂️astaing\nmy man!", forType: .string)
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
time to paste
in 😂️astaing
my man!TextViews
ho ho ho
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 17)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }
    
    func test_that_pasting_on_an_empty_line_does_not_paste_on_a_line_below_but_stays_on_the_same_line_and_does_not_stick_with_the_next_line() {
        let textInAXFocusedElement = """
gonna have an empty line

here's the last one
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("text for the new line", forType: .string)
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
gonna have an empty line
text for the new line
here's the last one
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 45)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
}


// PGR
extension ASUI_NM_pForLastYankStyleCharacterwise_Tests {
    
    func test_that_on_TextFields_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "we go😂️😂️😂️nna paste some 💩️"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("text to 🥞️🥞️🥞️ paste!!!🥠️", forType: .string)

        let accessibilityElement = applyMoveBeingTested(pgR: true)

        XCTAssertEqual(accessibilityElement?.fileText.value, "we go😂️😂️😂️nna paste some 💩️text to 🥞️🥞️🥞️ paste!!!🥠️text to 🥞️🥞️🥞️ paste!!!🥠️")
        XCTAssertEqual(accessibilityElement?.caretLocation, 87)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
        XCTAssertEqual(accessibilityElement?.selectedText, "🥠️")
    }
    
    func test_that_on_TextAreas_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
time to paste
in TextViews
ho ho ho
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.h(on: $0) }

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("pastaing", forType: .string)
        
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
time to paste
in pastaingpastaingTextViews
ho ho ho
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 32)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
        XCTAssertEqual(accessibilityElement?.selectedText, "g")
    }
    
}
