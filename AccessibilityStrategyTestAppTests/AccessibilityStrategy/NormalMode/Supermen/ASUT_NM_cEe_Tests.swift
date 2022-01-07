@testable import AccessibilityStrategy
import XCTest
import VimEngineState


// `ce` uses `e` that uses `FileText.endOfWordForward` that are heavily tested.
// here we just test what's specific to ce.
class ASUT_NM_cEe_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement, using motion: (Int?, AccessibilityTextElement) -> AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(pgR: false)
        
        return applyMoveBeingTested(times: count, on: element, using: motion, &state)
    }
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement, using motion: (Int?, AccessibilityTextElement) -> AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.cEe(times: count, on: element, using: motion, &vimEngineState)
    }
    
}


// Bip, copy deletion and LYS
extension ASUT_NM_cEe_Tests {
    
    func test_that_it_always_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_copies_the_deletion() {
        let text = "😂️😂️😂️😂️ gonna use ce on this sentence"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 3,
            selectedLength: 3,
            selectedText: "😂️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, using: asNormalMode.e, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "😂️😂️😂️")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
}


// count
extension ASUT_NM_cEe_Tests {
    
    func test_that_it_implements_the_count_system() {
        let text = "😂️😂️😂️😂️hehehehe gonna use ce on this sentence"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 50,
            caretLocation: 3,
            selectedLength: 3,
            selectedText: "😂️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 50,
                number: 1,
                start: 0,
                end: 50
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 4, on: element, using: asNormalMode.E)
        
        XCTAssertEqual(returnedElement.caretLocation, 3)
        XCTAssertEqual(returnedElement.selectedLength, 30)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
}


// both
extension ASUT_NM_cEe_Tests {
    
    func test_that_in_normal_setting_it_selects_the_text_from_the_caret_to_the_character_found() {
        let text = "😂️😂️😂️😂️ gonna use ce on this sentence"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 3,
            selectedLength: 3,
            selectedText: "😂️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element, using: asNormalMode.e)
        
        XCTAssertEqual(returnedElement.caretLocation, 3)
        XCTAssertEqual(returnedElement.selectedLength, 9)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
   
}
