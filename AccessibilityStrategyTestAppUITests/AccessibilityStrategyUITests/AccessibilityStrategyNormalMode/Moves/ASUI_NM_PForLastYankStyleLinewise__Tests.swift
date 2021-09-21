import XCTest
import KeyCombination
import AccessibilityStrategy


// read p for more blah blah
class UIASNM_PForLastYankStyleLinewise_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asNormalMode.PForLastYankStyleLinewise(on: $0) }
    }
    
}


// TextFields
extension UIASNM_PForLastYankStyleLinewise_Tests {
    
    func test_that_even_if_the_last_yank_was_linewise_it_still_pastes_as_characterwise_at_the_caret_location_and_the_block_cursor_ends_up_at_the_end_of_the_pasted_text() {
        let textInAXFocusedElement = "P linewise for TF is still pasted characterwise!"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("paste me daddy", forType: .string)
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.text.value, "paste me daddyP linewise for TF is still pasted characterwise!")
        XCTAssertEqual(accessibilityElement?.caretLocation, 13)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
    func test_that_when_the_last_yank_was_linewise_and_the_line_was_ending_with_a_linefeed_the_linefeed_is_not_pasted_in_the_TextField() {
        let textInAXFocusedElement = "P should not paste linefeeds in the TF"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.h(on: $0) }

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("yanked with the linefeed hum hum\n", forType: .string)
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.text.value, "P should not paste linefeeds in theyanked with the linefeed hum hum TF")
        XCTAssertEqual(accessibilityElement?.caretLocation, 66)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
}


// TextAreas
extension UIASNM_PForLastYankStyleLinewise_Tests {
    
    func test_that_in_normal_setting_it_pasts_the_content_on_the_current_line_and_shifts_the_current_line_down() {
        let textInAXFocusedElement = """
so if we use P
the current line is gonna
shift and thew new one is gonna be
pasted at the current line place
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        app.textViews.firstMatch.typeKey(.upArrow, modifierFlags: [])
        
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.h(on: $0) }

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("🤍️hould paste 🤍️ that\n", forType: .string)

        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.text.value, """
so if we use P
the current line is gonna
🤍️hould paste 🤍️ that
shift and thew new one is gonna be
pasted at the current line place
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 41)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }

    func test_that_when_pasting_the_new_line_the_block_cursor_goes_to_the_first_non_blank_of_the_new_current_line() {
        let textInAXFocusedElement = """
so now we gonna
have to move the caret
to the first non blank of the copied line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.h(on: $0) }

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("   the copied line has non blanks\n", forType: .string)

        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.text.value, """
so now we gonna
   the copied line has non blanks
have to move the caret
to the first non blank of the copied line
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 19)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
    func test_that_if_the_caret_is_at_the_last_character_of_the_TextArea_and_on_an_empty_line_it_still_pastes_and_will_enforce_a_trailing_linefeed() {
        let textInAXFocusedElement = """
this should paste
on the last line and
enforce a linefeed

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("test 3 of The 3 Cases for TextArea linewise P", forType: .string)
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.text.value, """
this should paste
on the last line and
enforce a linefeed
test 3 of The 3 Cases for TextArea linewise P

"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 58)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
}
