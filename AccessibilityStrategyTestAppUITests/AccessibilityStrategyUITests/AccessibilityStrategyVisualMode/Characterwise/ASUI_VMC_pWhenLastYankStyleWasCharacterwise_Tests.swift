import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_VMC_pWhenLastYankStyleWasCharacterwise_Tests: ASUI_VM_BaseTests {
    
    var state = VimEngineState(visualStyle: .characterwise)
    
           
    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        return applyMove { asVisualMode.p(on: $0, VimEngineState(appFamily: appFamily, lastYankStyle: .characterwise, visualStyle: state.visualStyle)) }
    }
    
}


// TextFields
extension ASUI_VMC_pWhenLastYankStyleWasCharacterwise_Tests {
    
    func test_that_it_replaces_the_current_Characterwise_selection_and_the_block_cursor_ends_up_at_the_end_of_the_pasted_text_and_if_the_previous_copied_Characterwise_text_ended_with_a_linefeed_it_gets_removed() {
        let textInAXFocusedElement = "we gonna select some text and replace it by pasting"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.b(times: 4, on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.w(times: 2, on: $0, state) }

        copyToClipboard(text: """
yes maybe even with LYS Characterwise
it maybe have been a multiline\n
"""
        )
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
we gonna select some text and yes maybe even with LYS Characterwise
it maybe have been a multiliney pasting
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 97)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }

}


// TextAreas
extension ASUI_VMC_pWhenLastYankStyleWasCharacterwise_Tests {
    
    func test_that_in_normal_setting_it_replaces_the_current_Characterwise_selection_and_if_the_text_does_not_contain_a_linefeed_the_block_cursor_ends_up_at_the_end_of_the_copied_text() {
        let textInAXFocusedElement = """
this is when the copied
text doesn't have a linefeed
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.e(times: 3, on: $0, state) }
        copyToClipboard(text: "does not have a linefeed")
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
this does not have a linefeed copied
text doesn't have a linefeed
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 28)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_in_normal_setting_it_replaces_the_current_Characterwise_selection_and_if_the_text_does_contain_a_linefeed_the_block_cursor_ends_up_at_the_beginning_of_the_copied_text() {
        let textInAXFocusedElement = """
this is when the copied
text does have a linefeed
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.e(times: 3, on: $0, state) }
        copyToClipboard(text: "does have\na linefeed now :D")
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
this does have
a linefeed now :D copied
text does have a linefeed
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 5)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_it_replaces_a_current_an_emptyLine_which_means_the_linefeed_is_replaced_by_the_copied_text_and_the_line_below_will_come_up() {
        let textInAXFocusedElement = """
gonna have an empty line

here's the last one
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        copyToClipboard(text: "text for the new line")
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
gonna have an empty line
text for the new linehere's the last one
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 45)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
}


// PGR and Electron
extension ASUI_VMC_pWhenLastYankStyleWasCharacterwise_Tests {
   
    func test_that_on_TextFields_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "check that it works in PGR too"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.b(times: 5, on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.e(times: 2, on: $0, state) }
        copyToClipboard(text: "pasta\n")
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, "check that pastapasta in PGR too")
        XCTAssertEqual(accessibilityElement.caretLocation, 20)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "a")
    }
    
    func test_that_on_TextAreas_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
it's gonna paste twice coz
PGR
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.dollarSign(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.w(on: $0, state) }
        applyMove { asVisualMode.l(on: $0, state) }
        copyToClipboard(text: "  should paste that\nsomewhere")
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
it's gonna paste twice   should paste that
somewhere  should paste that
somewhereR
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 23)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
    }
    
}
