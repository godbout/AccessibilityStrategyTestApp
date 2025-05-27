@testable import AccessibilityStrategy
import Common
import XCTest


class ASUT_VM_leftChevron_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, appFamily: AppFamily) -> AccessibilityTextElement {
        asVisualMode.leftChevron(on: element, VimEngineState(appFamily: appFamily))
    } 
    
}


// clipboard management in PGR (coz applyMagicPaste)
extension ASUT_VM_leftChevron_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_not_overwrite_the_Clipboard() {
        let text = """
seems that even the normal
hehe
       🖕️ase fails LMAO
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 56,
            caretLocation: 27,
            selectedLength: 6,
            selectedText: """
        hehe
         
        """,
            fullyVisibleArea: 0..<56,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 56,
                number: 2,
                start: 27,
                end: 32
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        AccessibilityStrategyVisualMode.anchor = 32
        AccessibilityStrategyVisualMode.head = 27
        
        _ = applyMoveBeingTested(on: element, appFamily: .pgR)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
    }
    
}
