@testable import AccessibilityStrategy
import Common
import XCTest


class ASUT_NM_tilde_Tests: ASUT_NM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement, appFamily: AppFamily) -> AccessibilityTextElement {
        asNormalMode.tilde(on: element, VimEngineState(appFamily: appFamily))
    } 
    
}


// clipboard management in PGR (coz applyMagicPaste)
extension ASUT_NM_tilde_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_not_overwrite_the_Clipboard() {
        let text = "gonna replace one of thOse😂️letters..."
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 39,
            caretLocation: 0,
            selectedLength: 1,
            selectedText: """
        g
        """,
            fullyVisibleArea: 0..<39,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 39,
                number: 1,
                start: 0,
                end: 39
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        _ = applyMoveBeingTested(on: element, appFamily: .pgR)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
    }
    
}
