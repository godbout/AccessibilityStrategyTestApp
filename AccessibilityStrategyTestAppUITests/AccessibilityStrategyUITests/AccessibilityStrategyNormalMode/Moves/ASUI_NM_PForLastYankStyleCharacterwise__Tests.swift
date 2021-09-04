import XCTest
import KeyCombination
import AccessibilityStrategy


// read p for more blah blah
class UIASNM_PForLastYankStyleCharacterwise_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveAndGetBackAccessibilityElement() -> AccessibilityTextElement? {
        return applyMove { asNormalMode.PForLastYankStyleCharacterwise(on: $0) }
    }
    
}


// TextFields
extension UIASNM_PForLastYankStyleCharacterwise_Tests {
    
    func test_that_in_normal_setting_it_pastes_the_text_at_the_caret_position_and_the_block_cursor_ends_up_at_the_end_of_the_pasted_text() {
        let textInAXFocusedElement = "pasta pizza"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        app.textFields.firstMatch.typeKey(.leftArrow, modifierFlags: [.option])

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("text to pasta pizza!!!", forType: .string)
        
        let accessibilityElement = applyMoveAndGetBackAccessibilityElement()
        
        XCTAssertEqual(accessibilityElement?.value, "pasta text to pasta pizza!!!pizza")
        XCTAssertEqual(accessibilityElement?.caretLocation, 27)
    }
    
    func test_that_even_if_the_last_yank_was_linewise_it_still_pastes_as_characterwise_at_the_caret_location_and_the_block_cursor_ends_up_at_the_end_of_the_pasted_text() {
        let textInAXFocusedElement = "P linewise for TF is still pasted characterwise!"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        app.textFields.firstMatch.typeKey(.leftArrow, modifierFlags: [.command])
        app.textFields.firstMatch.typeKey(.leftArrow, modifierFlags: [])
       
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("paste me daddy", forType: .string)
        
        let accessibilityElement = applyMoveAndGetBackAccessibilityElement()
        
        XCTAssertEqual(accessibilityElement?.value, "paste me daddyP linewise for TF is still pasted characterwise!")
        XCTAssertEqual(accessibilityElement?.caretLocation, 13)
    }
    
    func test_that_when_the_last_yank_was_linewise_and_the_line_was_ending_with_a_linefeed_the_linefeed_is_not_pasted_in_the_TextField() {
        let textInAXFocusedElement = "P should not paste linefeeds in the TF"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        app.textFields.firstMatch.typeKey(.leftArrow, modifierFlags: [.option])
        app.textFields.firstMatch.typeKey(.leftArrow, modifierFlags: [])
       
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("yanked with the linefeed hum hum\n", forType: .string)
        
        let accessibilityElement = applyMoveAndGetBackAccessibilityElement()
        
        XCTAssertEqual(accessibilityElement?.value, "P should not paste linefeeds in theyanked with the linefeed hum hum TF")
        XCTAssertEqual(accessibilityElement?.caretLocation, 66)
    }
    
}


// TextAreas
extension UIASNM_PForLastYankStyleCharacterwise_Tests {
    
    func test_that_in_normal_setting_it_pastes_the_text_at_the_caret_location_and_if_the_text_does_not_contain_a_linefeed_the_block_cursor_ends_up_at_the_end_of_the_pasted_text() {
        let textInAXFocusedElement = """
time to paste
in TextViews
ho ho ho
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        app.textViews.firstMatch.typeKey(.upArrow, modifierFlags: [])
        app.textViews.firstMatch.typeKey(.leftArrow, modifierFlags: [.option])
        app.textViews.firstMatch.typeKey(.leftArrow, modifierFlags: [])

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("pastaing", forType: .string)

        let accessibilityElement = applyMoveAndGetBackAccessibilityElement()

        XCTAssertEqual(accessibilityElement?.value, """
time to paste
inpastaing TextViews
ho ho ho
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 23)
    }

    func test_that_in_normal_setting_it_pastes_the_text_at_the_caret_location_and_if_the_text_contains_a_linefeed_the_block_cursor_ends_up_at_the_beginning_of_the_pasted_text() {
        let textInAXFocusedElement = """
time to paste
in TextViews
ho ho ho
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        app.textViews.firstMatch.typeKey(.upArrow, modifierFlags: [])
        app.textViews.firstMatch.typeKey(.leftArrow, modifierFlags: [.option])
        app.textViews.firstMatch.typeKey(.leftArrow, modifierFlags: [])

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("😂️astaing\nmy man!", forType: .string)

        let accessibilityElement = applyMoveAndGetBackAccessibilityElement()

        XCTAssertEqual(accessibilityElement?.value, """
time to paste
in😂️astaing
my man! TextViews
ho ho ho
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 16)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }

    func test_that_pasting_on_an_empty_line_does_not_paste_on_a_line_above_but_stays_on_the_same_line_and_does_not_stick_with_the_next_line() {
        let textInAXFocusedElement = """
gonna have an empty line

here's the last one
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        app.textViews.firstMatch.typeKey(.upArrow, modifierFlags: [])

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("text for the new line", forType: .string)

        let accessibilityElement = applyMoveAndGetBackAccessibilityElement()

        XCTAssertEqual(accessibilityElement?.value, """
gonna have an empty line
text for the new line
here's the last one
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 45)
    }
    
}


// emojis
extension UIASNM_PForLastYankStyleCharacterwise_Tests {
    
    func test_that_it_handles_emojis() {
        let textInAXFocusedElement = "🍕️🍕️🍕️"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        app.textFields.firstMatch.typeKey(.leftArrow, modifierFlags: [])
       
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("text to pasta 🍕️!!🍔️", forType: .string)
        
        let accessibilityElement = applyMoveAndGetBackAccessibilityElement()
        
        XCTAssertEqual(accessibilityElement?.value, "🍕️🍕️text to pasta 🍕️!!🍔️🍕️")
        XCTAssertEqual(accessibilityElement?.caretLocation, 25)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }
    
    func test_that_it_handles_emojis_characterwise() {
        let textInAXFocusedElement = """
time to paste
in 🚬️
ho ho ho
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        app.textViews.firstMatch.typeKey(.upArrow, modifierFlags: [])
        app.textViews.firstMatch.typeKey(.leftArrow, modifierFlags: [.option])
        app.textViews.firstMatch.typeKey(.leftArrow, modifierFlags: [])
       
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("pastain🤡️", forType: .string)
        
        let accessibilityElement = applyMoveAndGetBackAccessibilityElement()
        
        XCTAssertEqual(accessibilityElement?.value, """
time to paste
inpastain🤡️ 🚬️
ho ho ho
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 23)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
        
    }
    
}
