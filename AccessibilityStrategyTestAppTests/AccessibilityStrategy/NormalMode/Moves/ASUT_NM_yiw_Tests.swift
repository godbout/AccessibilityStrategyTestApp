@testable import AccessibilityStrategy
import XCTest
import Common


// so. this move uses a TE func that is already tested.
// also ciw is already extra testing, so here we gonna only test
// stuff specific to that move, which is the copying through NSPasteboard
class ASUT_NM_yiw_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: .auto)
        
        return applyMoveBeingTested(on: element, &state)
    }
        
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.yiw(on: element, &vimEngineState)
    }
    
}


// Bip, copy deletion and LYS
extension ASUT_NM_yiw_Tests {
    
    func test_that_it_always_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_copies_the_deletion_even_for_an_empty_line() {
        let text = "some text without any double quote"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 34,
            caretLocation: 13,
            selectedLength: 1,
            selectedText: "h",
            fullyVisibleArea: 0..<34,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 34,
                number: 1,
                start: 0,
                end: 34
            )!
        )
        
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "without")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
}


// Both
extension ASUT_NM_yiw_Tests {
    
    func test_that_it_copies_the_inner_word() {
        let text = "some text without any double quote"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 34,
            caretLocation: 13,
            selectedLength: 1,
            selectedText: "h",
            fullyVisibleArea: 0..<34,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 34,
                number: 1,
                start: 0,
                end: 34
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "without")
        XCTAssertEqual(returnedElement.caretLocation, 10)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// emojis
extension ASUT_NM_yiw_Tests {
    
    func test_that_it_handles_emojis() {
        let text = """
need to deal with
th📍️se💨️💨️💨️ faces 🥺️☹️😂️ h😀️ha
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 56,
            caretLocation: 28,
            selectedLength: 3,
            selectedText: "💨️",
            fullyVisibleArea: 0..<56,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 56,
                number: 2,
                start: 18,
                end: 56
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "💨️💨️💨️")
        XCTAssertEqual(returnedElement.caretLocation, 25)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
