@testable import AccessibilityStrategy
import XCTest
import Common


// this moves uses FT innerParagraph that is already heavily tested.
// here we test the stuff specific to this move, like Bip, copy to Pasteboard, etc.
class ASUT_NM_yip_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: .auto)
        
        return applyMoveBeingTested(on: element, &state)
    }
        
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.yip(on: element, &vimEngineState)
    }
    
}


// Bip, copy deletion and LYS
extension ASUT_NM_yip_Tests {
    
    func test_that_it_always_does_not_Bip_and_sets_the_LastYankStyle_to_Linewise_and_copies_the_correct_text() {
        let text = """
ok so here
we gonna have

some stuff and
see

if it works
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 57,
            caretLocation: 29,
            selectedLength: 1,
            selectedText: """
        e
        """,
            fullyVisibleArea: 0..<57,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 57,
                number: 4,
                start: 26,
                end: 41
            )!
        )
        
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
some stuff and
see\n
"""
        )
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
}


// Both
extension ASUT_NM_yip_Tests {
    
    func test_that_it_copies_the_innerParagraph_and_repositions_the_caret_at_the_right_location() {
        let text = """
another
        
paragraph
shit hehe
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 36,
            caretLocation: 20,
            selectedLength: 1,
            selectedText: """
        a
        """,
            fullyVisibleArea: 0..<36,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 36,
                number: 3,
                start: 17,
                end: 27
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
paragraph
shit hehe
"""
        )
        XCTAssertEqual(returnedElement.caretLocation, 17)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// emojis
extension ASUT_NM_yip_Tests {
    
    func test_that_it_handles_emojis() {
        let text = """
ohoh

📍️eed to deal with
th📍️se💨️💨️💨️ faces 🥺️☹️😂️ h😀️ha

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 65,
            caretLocation: 14,
            selectedLength: 1,
            selectedText: """
        o
        """,
            fullyVisibleArea: 0..<65,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 65,
                number: 3,
                start: 6,
                end: 26
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
📍️eed to deal with
th📍️se💨️💨️💨️ faces 🥺️☹️😂️ h😀️ha\n
"""
        )
        XCTAssertEqual(returnedElement.caretLocation, 6)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
