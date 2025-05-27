@testable import AccessibilityStrategy
import Common
import XCTest


class ASUT_VM_rightChevron_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, appFamily: AppFamily) -> AccessibilityTextElement {
        asVisualMode.rightChevron(on: element, VimEngineState(appFamily: appFamily))
    } 
    
}


// clipboard management in PGR (coz applyMagicPaste)
extension ASUT_VM_rightChevron_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_not_overwrite_the_Clipboard() {
        let text = """
seems that even the normal
🖕️ase fails LMAO
some more
and more
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 63,
            caretLocation: 27,
            selectedLength: 19,
            selectedText: """
        🖕️ase fails LMAO
        s
        """,
            fullyVisibleArea: 0..<63,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 63,
                number: 2,
                start: 27,
                end: 45
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        AccessibilityStrategyVisualMode.anchor = 27
        AccessibilityStrategyVisualMode.head = 45
        
        _ = applyMoveBeingTested(on: element, appFamily: .pgR)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
    }
    
}
