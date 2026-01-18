@testable import AccessibilityStrategy
import XCTest
import Common


// r has changed. when we started working with the emojis, i tried replacing
// an emoji by another character. even if an emojis may be 3 characters, it worked,
// except for numbers. for numbers, rather than the number taking 1 character, it would
// take 3 and behave strangely. so we need call the ATEAdaptor and push an update mid move
// in order to erase the emojis before replacing it by another character.
// the tests belows are the ones that don't use the push. for the other tests they
// are in the UI.
// also now PGR so, UI UI UI.

class ASUT_NM_r_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(with replacement: Character, on element: AccessibilityTextElement, appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        return asNormalMode.r(with: replacement, on: element, VimEngineState(appFamily: appFamily))
    }
    
}


// TextFields and TextViews
extension ASUT_NM_r_Tests {
    
    func test_that_if_the_replacement_is_escape_then_it_does_nothing() {
        let text = "trying to replace by an escape does shit!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 41,
            caretLocation: 15,
            selectedLength: 1,
            selectedText: "c",
            fullyVisibleArea: 0..<41,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 41,
                number: 1,
                start: 0,
                end: 41
            )!
        )
        
        let returnedElement = applyMoveBeingTested(with: "\u{1b}", on: element)
        
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// TextViews
extension ASUT_NM_r_Tests {
    
    func test_that_if_the_caret_is_on_a_linefeed_it_does_not_replace_it() {
        let text = """
can't change a

linefeed
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 24,
            caretLocation: 15,
            selectedLength: 1,
            selectedText: "\n",
            fullyVisibleArea: 0..<24,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 24,
                number: 2,
                start: 15,
                end: 16
            )!
        )
        
        let returnedElement = applyMoveBeingTested(with: "g", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 15)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
            
}


// clipboard management in PGR (coz applyMagicPaste)
extension ASUT_NM_r_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_not_overwrite_the_Clipboard() {
        let text = "gonna replace one of those letters..."
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 37,
            caretLocation: 0,
            selectedLength: 1,
            selectedText: """
        g
        """,
            fullyVisibleArea: 0..<37,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 37,
                number: 1,
                start: 0,
                end: 37
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        _ = applyMoveBeingTested(with: "a", on: element, appFamily: .pgR)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
    }
    
}
