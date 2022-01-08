import XCTest
import AccessibilityStrategy
import VimEngineState


class ASUT_VML_y_Tests: ASVM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState()
        
        return applyMoveBeingTested(on: element, &state)
    }
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        vimEngineState.visualModeStyle = .linewise
        
        return asVisualMode.y(on: element, &vimEngineState)
    }
    
}


// Bip, yank and LYS
extension ASUT_VML_y_Tests {

    func test_that_it_always_does_not_Bip_and_sets_the_LastYankStyle_to_Linewise_and_copies_the_selected_text_even_for_an_empty_line() {
        let text = """
VM c in Linewise
will delete the selected lines
but the below line will not go up
at least if we're not at the end of the text
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 126,
            caretLocation: 17,
            selectedLength: 65,
            selectedText: """
will delete the selected lines
but the below line will not go up\n
""",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 126,
                number: 2,
                start: 17,
                end: 48
            )!
        )      
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
will delete the selected lines
but the below line will not go up\n
"""
        )
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
}


// Both
extension ASUT_VML_y_Tests {
    
    func test_that_for_TextFields_it_yanks_the_whole_line() {
        let text = "a whole line entirely for VM V and VM y"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 39,
            caretLocation: 0,
            selectedLength: 39,
            selectedText: "a whole line entirely for VM V and VM y",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 39,
                number: 1,
                start: 0,
                end: 39
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "a whole line entirely for VM V and VM y")   
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// TextViews
extension ASUT_VML_y_Tests {
    
    func test_that_for_TextViews_it_yanks_the_selected_lines() {
        let text = """
gonna be dealing
with VM V over
why the fuck am
i writing this?
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 63,
            caretLocation: 17,
            selectedLength: 46,
            selectedText: """
with VM V over
why the fuck am
i writing this?
""",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 63,
                number: 2,
                start: 17,
                end: 32
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
with VM V over
why the fuck am
i writing this?
"""
        )
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_after_yanking_it_gets_back_to_the_caret_position() {
        let text = """
yes even in multilne
it goes back to
the crazy caret location and
not the anchor!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 81,
            caretLocation: 21,
            selectedLength: 45,
            selectedText: """
it goes back to
the crazy caret location and
""",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 81,
                number: 2,
                start: 21,
                end: 37
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 21)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// emojis
extension ASUT_VML_y_Tests {
    
    func test_that_it_handles_emojis() {
        let text = """
yes even in multilne
🔥️t goes back to
the crazy caret location and
not the anchor!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 83,
            caretLocation: 21,
            selectedLength: 47,
            selectedText: """
🔥️t goes back to
the crazy caret location and
""",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 83,
                number: 2,
                start: 21,
                end: 39
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 21)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
