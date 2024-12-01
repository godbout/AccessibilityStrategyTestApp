import XCTest
import AccessibilityStrategy
import Common


class ASUT_VM_gx_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asVisualMode.gx(on: element, &vimEngineState)
    }
    
}


extension ASUT_VM_gx_Tests {

    func test_that_for_a_valid_selected_URL_that_can_be_opened_it_sets_the_lastMoveBipped_to_false() {
        let text = "that shit contains a valid https://kindavim.app URL"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 51,
            caretLocation: 27,
            selectedLength: 20,
            selectedText: """
        https://kindavim.app
        """,
            fullyVisibleArea: 0..<51,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 51,
                number: 1,
                start: 0,
                end: 51
            )!
        )

        var vimEngineState = VimEngineState(lastMoveBipped: true)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
    
    func test_that_for_a_valid_selected_URL_that_cannot_be_opened_it_sets_the_lastMoveBipped_to_true() {
        let text = "that shit contains a valid url file://Users/guill but it cannot be opened! (missing a /)"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 88,
            caretLocation: 31,
            selectedLength: 18,
            selectedText: """
        file://Users/guill
        """,
            fullyVisibleArea: 0..<88,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 88,
                number: 1,
                start: 0,
                end: 75
            )!
        )

        var vimEngineState = VimEngineState(lastMoveBipped: false)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertTrue(vimEngineState.lastMoveBipped)
    }
    
    func test_that_for_a_non_valid_selected_URL_it_sets_the_lastMoveBipped_to_true() {
        let text = "that shit doesn't not contain a valid URL hehhehhehehhehe"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 57,
            caretLocation: 27,
            selectedLength: 18,
            selectedText: """
        in a valid URL heh
        """,
            fullyVisibleArea: 0..<57,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 57,
                number: 1,
                start: 0,
                end: 57
            )!
        )

        var vimEngineState = VimEngineState(lastMoveBipped: false)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertTrue(vimEngineState.lastMoveBipped)
    }

}
