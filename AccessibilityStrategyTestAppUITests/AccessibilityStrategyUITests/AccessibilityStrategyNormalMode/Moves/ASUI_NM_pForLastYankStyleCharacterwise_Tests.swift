import XCTest
@testable import AccessibilityStrategy
import VimEngineState


class ASUI_NM_pForLastYankStyleCharacterwise_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(appFamily: VimEngineAppFamily = .auto) -> AccessibilityTextElement {
        return applyMove { asNormalMode.p(on: $0, VimEngineState(appFamily: appFamily, lastYankStyle: .characterwise)) }
    }
    
}


// TextFields
extension ASUI_NM_pForLastYankStyleCharacterwise_Tests {
    
    func test_that_in_normal_setting_it_pastes_the_text_after_the_block_cursor_and_the_block_cursor_ends_up_at_the_end_of_the_pasted_text() {
        let textInAXFocusedElement = "we go😂️😂️😂️nna paste some 💩️"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        copyToClipboard(text: "text to 🥞️🥞️🥞️ paste!!!🥠️")
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, "we go😂️😂️😂️nna paste some 💩️text to 🥞️🥞️🥞️ paste!!!🥠️")
        XCTAssertEqual(accessibilityElement.caretLocation, 58)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
    func test_that_if_the_text_to_paste_is_empty_it_does_not_move() {
        let textInAXFocusedElement = "possible because of PGR"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.b(on: $0) }
        copyToClipboard(text: "")
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, "possible because of PGR")
        XCTAssertEqual(accessibilityElement.caretLocation, 20)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
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
        copyToClipboard(text: "pastaing")
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
time to paste
in pastaingTextViews
ho ho ho
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 24)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
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
        copyToClipboard(text: "😂️astaing\nmy man!")
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
time to paste
in 😂️astaing
my man!TextViews
ho ho ho
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 17)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
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
        copyToClipboard(text: "text for the new line")
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
gonna have an empty line
text for the new line
here's the last one
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 45)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_if_the_text_to_paste_is_empty_it_does_not_move_backwards_and_definitely_does_not_end_up_after_the_end_limit_of_the_previous_line() {
        let textInAXFocusedElement = """
still possible coz of PGR

and fucking AX restrictions in browsers
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        copyToClipboard(text: "")
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
still possible coz of PGR

and fucking AX restrictions in browsers
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 26)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
}


// PGR
extension ASUI_NM_pForLastYankStyleCharacterwise_Tests {
    
    func test_that_on_TextFields_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "we go😂️😂️😂️nna paste some 💩️"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        copyToClipboard(text: "text to 🥞️🥞️🥞️ paste!!!🥠️")
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, "we go😂️😂️😂️nna paste some 💩️text to 🥞️🥞️🥞️ paste!!!🥠️text to 🥞️🥞️🥞️ paste!!!🥠️")
        XCTAssertEqual(accessibilityElement.caretLocation, 87)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
        XCTAssertEqual(accessibilityElement.selectedText, "🥠️")
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
        copyToClipboard(text: "pastaing")
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
time to paste
in pastaingpastaingTextViews
ho ho ho
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 32)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "g")
    }
    
}
