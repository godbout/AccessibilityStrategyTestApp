import XCTest
@testable import AccessibilityStrategy
import Common


// read p for more blah blah
class ASUI_NM_PForLastYankStyleLinewise_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        return applyMove { asNormalMode.P(on: $0, VimEngineState(appFamily: appFamily, lastYankStyle: .linewise)) }
    }
    
}


// TextFields
extension ASUI_NM_PForLastYankStyleLinewise_Tests {
    
    func test_that_even_if_the_last_yank_was_linewise_it_still_pastes_as_characterwise_at_the_caret_location_and_the_block_cursor_ends_up_at_the_end_of_the_pasted_text() {
        let textInAXFocusedElement = "P linewise for TF is still pasted characterwise!"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        
        copyToClipboard(text: "paste me daddy")
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, "paste me daddyP linewise for TF is still pasted characterwise!")
        XCTAssertEqual(accessibilityElement.caretLocation, 13)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_when_the_last_yank_was_linewise_and_the_line_was_ending_with_a_linefeed_the_linefeed_is_not_pasted_in_the_TextField() {
        let textInAXFocusedElement = "P should not paste linefeeds in the TF"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        
        copyToClipboard(text: "yanked with the linefeed hum hum\n")
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, "P should not paste linefeeds in theyanked with the linefeed hum hum TF")
        XCTAssertEqual(accessibilityElement.caretLocation, 66)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
}


// TextAreas
extension ASUI_NM_PForLastYankStyleLinewise_Tests {
    
    func test_that_in_normal_setting_it_pasts_the_content_on_the_current_line_and_shifts_the_current_line_down() {
        let textInAXFocusedElement = """
so if we use P
the current line is gonna
shift and thew new one is gonna be
pasted at the current line place
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        
        copyToClipboard(text: "🤍️hould paste 🤍️ that\n")
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
so if we use P
the current line is gonna
🤍️hould paste 🤍️ that
shift and thew new one is gonna be
pasted at the current line place
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 41)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }

    func test_that_when_pasting_the_new_line_the_block_cursor_goes_to_the_first_non_blank_of_the_new_current_line() {
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
        
        copyToClipboard(text: "   the copied line has non blanks\n")
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
so now we gonna
   the copied line has non blanks
have to move the caret
to the first non blank of the copied line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 19)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_if_the_caret_is_at_the_last_character_of_the_TextArea_and_on_an_empty_line_it_still_pastes_and_will_enforce_a_trailing_linefeed() {
        let textInAXFocusedElement = """
this should paste
on the last line and
enforce a linefeed

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        copyToClipboard(text: "test 3 of The 3 Cases for TextArea linewise P")
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
this should paste
on the last line and
enforce a linefeed
test 3 of The 3 Cases for TextArea linewise P

"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 58)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
}


// PGR and Electron
extension ASUI_NM_PForLastYankStyleLinewise_Tests {
    
    func test_that_on_TextFields_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = "P linewise for TF is still pasted characterwise!"
        app.webViews.textFields.firstMatch.tap()
        app.webViews.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        
        copyToClipboard(text: "paste me daddy")
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, "paste me daddyP linewise for TF is still pasted characterwise!")
        XCTAssertEqual(accessibilityElement.caretLocation, 13)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "y")
    }
    
    func test_that_on_TextAreas_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
so if we use P
the current line is gonna
shift and thew new one is gonna be
pasted at the current line place
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        
        copyToClipboard(text: "🤍️hould paste 🤍️ that\n")
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, """
so if we use P
the current line is gonna
🤍️hould paste 🤍️ that
shift and thew new one is gonna be
pasted at the current line place
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 41)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
        XCTAssertEqual(accessibilityElement.selectedText, "🤍️")
    }
    
    func test_that_on_TextFields_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = "P linewise for TF is still pasted characterwise!"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        
        copyToClipboard(text: "paste me daddy")
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, "paste me daddyP linewise for TF is still pasted characterwise!")
        XCTAssertEqual(accessibilityElement.caretLocation, 13)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "y")
    }
    
    func test_that_on_TextAreas_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
so if we use P
the current line is gonna
shift and thew new one is gonna be
pasted at the current line place
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        
        copyToClipboard(text: "🤍️hould paste 🤍️ that\n")
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, """
so if we use P
the current line is gonna
🤍️hould paste 🤍️ that
shift and thew new one is gonna be
pasted at the current line place
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 41)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
        XCTAssertEqual(accessibilityElement.selectedText, "🤍️")
    }
    
}
