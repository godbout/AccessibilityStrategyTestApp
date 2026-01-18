@testable import AccessibilityStrategy
import XCTest
import Common


// most tests in UIT coz delete/paste and PGR
class ASUT_NM_J__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        asNormalMode.J(on: element, VimEngineState(appFamily: appFamily))
    }
    
}


// TextFields and TextViews
extension ASUT_NM_J__Tests {
    
    func test_that_if_the_character_is_not_found_then_it_does_nothing() {
        let text = """
hehe no linefeed here mofo
"""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 26,
            caretLocation: 15,
            selectedLength: 1,
            selectedText: "d",
            fullyVisibleArea: 0..<26,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 26,
                number: 1,
                start: 0,
                end: 26
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 15)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// clipboard management in PGR (coz applyMagicPaste)
extension ASUT_NM_J__Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_not_overwrite_the_Clipboard() {
        let text = """
gonna try to fuse line 1
with line 2
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 36,
            caretLocation: 0,
            selectedLength: 1,
            selectedText: """
        g
        """,
            fullyVisibleArea: 0..<36,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 36,
                number: 1,
                start: 0,
                end: 25
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        _ = applyMoveBeingTested(on: element, appFamily: .pgR)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
    }
    
}
