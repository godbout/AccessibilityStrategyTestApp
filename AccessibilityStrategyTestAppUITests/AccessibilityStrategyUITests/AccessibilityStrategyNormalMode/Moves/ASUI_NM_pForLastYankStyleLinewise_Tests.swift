import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_NM_pForLastYankStyleLinewise_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        return applyMove { asNormalMode.p(on: $0, VimEngineState(appFamily: appFamily, lastYankStyle: .linewise)) }
    }
    
}

// TextFields
extension ASUI_NM_pForLastYankStyleLinewise_Tests {

    func test_that_even_if_the_last_yank_was_linewise_it_still_pastes_as_characterwise_after_the_block_cursor_and_the_block_cursor_ends_up_at_the_end_of_the_pasted_text() {
        let textInAXFocusedElement = "linewise for TF is still pasted characterwise!"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        copyToClipboard(text: "text to pasta")
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, "ltext to pastainewise for TF is still pasted characterwise!")
        XCTAssertEqual(accessibilityElement.caretLocation, 13)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }

    func test_that_when_the_last_yank_was_linewise_and_the_line_was_ending_with_a_linefeed_the_linfeed_is_not_pasted_in_the_TextField() {
        let textInAXFocusedElement = "we should not paste linefeeds in the TF"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        copyToClipboard(text: "yanked with the linefeed\n")
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, "we should not paste linefeeds in the yanked with the linefeedTF")
        XCTAssertEqual(accessibilityElement.caretLocation, 60)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
        
}


// TextAreas
extension ASUI_NM_pForLastYankStyleLinewise_Tests {
    
    func test_that_in_normal_setting_it_pastes_the_content_on_a_new_line_below() {
        let textInAXFocusedElement = """
we gonna linewise paste
on a line that is not
the last so there's already
a linefeed at the end of the line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        copyToClipboard(text: "should paste that somewhere\n")
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
we gonna linewise paste
on a line that is not
the last so there's already
should paste that somewhere
a linefeed at the end of the line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 74)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_if_the_last_linewise_yanked_line_did_not_have_a_linefeed_pasting_it_will_add_the_linefeed_if_we_are_not_on_the_last_line() {
        let textInAXFocusedElement = """
when we yank the last line it doesn't contain
a linefeed but a linefeed should be pasted
if we are not pasting on the last line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        copyToClipboard(text: "we pasted the last line so no linefeed")
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
when we yank the last line it doesn't contain
a linefeed but a linefeed should be pasted
we pasted the last line so no linefeed
if we are not pasting on the last line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 89)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
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
        copyToClipboard(text: "new line to paste after last line\n")
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
now we gonna linewise paste
after the last line
so we need to add the linefeed
ourselves
new line to paste after last line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 89)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_when_pasting_the_new_line_the_block_cursor_goes_to_the_first_non_blank_of_the_new_line() {
        let textInAXFocusedElement = """
so now we gonna
have to move the caret
to the first non blank of the copied line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.ge(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        copyToClipboard(text: "   🤍️he copied line has 🤍️🤍️🤍️ non blanks\n")
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
so now we gonna
have to move the caret
   🤍️he copied line has 🤍️🤍️🤍️ non blanks
to the first non blank of the copied line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 42)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
    func test_that_if_the_caret_is_at_the_last_character_of_the_TextArea_and_on_an_empty_line_it_still_pastes_but_without_an_ending_linefeed() {
        let textInAXFocusedElement = """
this should paste
after a new line and
not add a linefeed

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        copyToClipboard(text: "test 3 of The 3 Cases for TextArea linewise\n")
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
this should paste
after a new line and
not add a linefeed

test 3 of The 3 Cases for TextArea linewise
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 59)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
}


// PGR and Electron
extension ASUI_NM_pForLastYankStyleLinewise_Tests {
    
    func test_that_on_TextFields_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = "linewise for TF is still pasted characterwise!"
        app.webViews.textFields.firstMatch.tap()
        app.webViews.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        copyToClipboard(text: "text to pasta")
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, "ltext to pastainewise for TF is still pasted characterwise!")
        XCTAssertEqual(accessibilityElement.caretLocation, 13)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "a")
    }
    
    func test_that_on_TextAreas_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
we gonna linewise paste
on a line that is not
the last so there's already
a linefeed at the end of the line
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        copyToClipboard(text: "should paste that somewhere\n")
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
we gonna linewise paste
on a line that is not
the last so there's already
should paste that somewhere
a linefeed at the end of the line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 74)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "s")
    }
    
    func test_that_on_TextFields_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = "linewise for TF is still pasted characterwise!"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        copyToClipboard(text: "text to pasta")
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, "ltext to pastainewise for TF is still pasted characterwise!")
        XCTAssertEqual(accessibilityElement.caretLocation, 13)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "a")
    }
    
    func test_that_on_TextAreas_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
we gonna linewise paste
on a line that is not
the last so there's already
a linefeed at the end of the line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        copyToClipboard(text: "should paste that somewhere\n")
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
we gonna linewise paste
on a line that is not
the last so there's already
should paste that somewhere
a linefeed at the end of the line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 74)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "s")
    }
    
    func test_that_now_in_PGR_Mode_we_can_paste_several_times_in_a_row() {
        let textInAXFocusedElement = """
we gonna linewise paste
on a line that is not
the last so there's already
a linefeed at the end of the line
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        copyToClipboard(text: "should paste that somewhere\n")
        
        _ = applyMoveBeingTested(appFamily: .pgR)
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
we gonna linewise paste
on a line that is not
the last so there's already
should paste that somewhere
should paste that somewhere
a linefeed at the end of the line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 102)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "s")
    }
    
}


// bugs found
extension ASUI_NM_pForLastYankStyleLinewise_Tests {

    func test_that_if_the_Clipboard_is_empty_and_we_paste_Linewise_at_the_LastLine_it_pastes_a_Linefeed_after_that_LastLine() {
        let textInAXFocusedElement = """
so if the Clipboard is empty
and we paste the Linewise at the last line
it actually works lol
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.G(on: $0) }
        copyToClipboard(text: "")
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
so if the Clipboard is empty
and we paste the Linewise at the last line
it actually works lol

"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 94)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
    }
    
    // this test contains Blanks
    func test_that_when_we_paste_a_BlankLine_or_an_EmptyLine_the_caret_is_repositioned_at_the_endLimit_not_the_end() {
        let textInAXFocusedElement = """
pasting a blank line shouldn't
put the caret in weird places
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        copyToClipboard(text: "        ")
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
pasting a blank line shouldn't
        
put the caret in weird places
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 38)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    // this test contains Blanks
    func test_that_if_the_pasted_line_at_the_LastLine_is_BlankLine_then_the_caret_ends_at_the_end_of_the_line_not_the_beginning() {
        let textInAXFocusedElement = """
so this is when the copied line
is blank and we paste on
the last line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        copyToClipboard(text: "        ")
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
so this is when the copied line
is blank and we paste on
the last line
        
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 78)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
        
    func test_that_if_the_Clipboard_is_one_linefeed_and_we_paste_Linewise_at_the_LastLine_it_pastes_a_Linefeed_after_that_LastLine() {
        let textInAXFocusedElement = """
so if the Clipboard holds a linefeed
and we paste Linewise at the last line
it should work hehe
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.G(on: $0) }
        copyToClipboard(text: "\n")
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
so if the Clipboard holds a linefeed
and we paste Linewise at the last line
it should work hehe

"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 96)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
    }
        
    func test_that_if_the_Clipboard_contains_many_Linefeeds_and_we_paste_Linewise_at_the_LastLine_it_pastes_Linefeeds_after_that_LastLine_and_repositions_the_caret_correctly() {
        let textInAXFocusedElement = """
that's gonna be
many many
linefeeds
at the last line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.G(on: $0) }
        copyToClipboard(text: "\n\n\n\n\n\n")
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
that's gonna be
many many
linefeeds
at the last line






"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 53)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_if_the_Clipboard_contains_many_Linefeeds_and_we_paste_Linewise_NOT_at_the_LastLine_but_anywhere_else_it_repositions_the_caret_correctly() {
        let textInAXFocusedElement = """
doesn't need to be
at the last line
to fail LOL
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        copyToClipboard(text: "\n\n\n\n\n\n")
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
doesn't need to be






at the last line
to fail LOL
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 19)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
}
