import XCTest
import KeyCombination
import AccessibilityStrategy


class UIASNM_pForLastYankStyleLinewise_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asNormalMode.pForLastYankStyleLinewise(on: $0) }
    }
    
}


// TextFields
extension UIASNM_pForLastYankStyleLinewise_Tests {

    func test_that_even_if_the_last_yank_was_linewise_it_still_pastes_as_characterwise_after_the_block_cursor_and_the_block_cursor_ends_up_at_the_end_of_the_pasted_text() {
        let textInAXFocusedElement = "linewise for TF is still pasted characterwise!"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("text to pasta", forType: .string)

        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.text.value, "ltext to pastainewise for TF is still pasted characterwise!")
        XCTAssertEqual(accessibilityElement?.caretLocation, 13)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }

    func test_that_when_the_last_yank_was_linewise_and_the_line_was_ending_with_a_linefeed_the_linfeed_is_not_pasted_in_the_TextField() {
        let textInAXFocusedElement = "we should not paste linefeeds in the TF"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.h(on: $0) }

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("yanked with the linefeed\n", forType: .string)

        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.text.value, "we should not paste linefeeds in the yanked with the linefeedTF")
        XCTAssertEqual(accessibilityElement?.caretLocation, 60)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
}


// TextAreas
extension UIASNM_pForLastYankStyleLinewise_Tests {
    
    func test_that_in_normal_setting_it_pasts_the_content_on_a_new_line_below() {
        let textInAXFocusedElement = """
we gonna linewise paste
on a line that is not
the last so there's already
a linefeed at the end of the line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.h(on: $0) }

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("should paste that somewhere\n", forType: .string)
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.text.value, """
we gonna linewise paste
on a line that is not
the last so there's already
should paste that somewhere
a linefeed at the end of the line
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 74)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
    func test_that_if_the_last_linewise_yanked_line_did_not_have_a_linefeed_pasting_it_will_add_the_linefeed_if_we_are_not_on_the_last_line() {
        let textInAXFocusedElement = """
when we yank the last line it doesn't contain
a linefeed but a linefeed should be pasted
if we are not pasting on the last line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.h(on: $0) }

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("we pasted the last line so no linefeed", forType: .string)
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.text.value, """
when we yank the last line it doesn't contain
a linefeed but a linefeed should be pasted
we pasted the last line so no linefeed
if we are not pasting on the last line
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 89)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
    func test_that_if_on_the_last_line_and_the_last_yanking_style_was_linewise_it_pastes_the_content_on_a_new_line_below_without_an_ending_linefeed() {
        let textInAXFocusedElement = """
now we gonna linewise paste
after the last line
so we need to add the linefeed
ourselves
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.h(on: $0) }

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("new line to paste after last line\n", forType: .string)
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.text.value, """
now we gonna linewise paste
after the last line
so we need to add the linefeed
ourselves
new line to paste after last line
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 89)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
    func test_that_when_pasting_the_new_line_the_block_cursor_goes_to_the_first_non_blank_of_the_new_line() {
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
        NSPasteboard.general.setString("   🤍️he copied line has 🤍️🤍️🤍️ non blanks\n", forType: .string)
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.text.value, """
so now we gonna
have to move the caret
   🤍️he copied line has 🤍️🤍️🤍️ non blanks
to the first non blank of the copied line
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 42)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }
    
    func test_that_if_the_caret_is_at_the_last_character_of_the_TextArea_and_on_an_empty_line_it_still_pastes_but_without_an_ending_linefeed() {
        let textInAXFocusedElement = """
this should paste
after a new line and
not add a linefeed

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("test 3 of The 3 Cases for TextArea linewise\n", forType: .string)
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.text.value, """
this should paste
after a new line and
not add a linefeed

test 3 of The 3 Cases for TextArea linewise
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 59)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
}
