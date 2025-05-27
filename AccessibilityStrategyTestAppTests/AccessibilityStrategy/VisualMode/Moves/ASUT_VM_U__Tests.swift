@testable import AccessibilityStrategy
import Common
import XCTest


// most in UIT
class ASUT_VM_U__Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, appFamily: AppFamily) -> AccessibilityTextElement {
        asVisualMode.U(on: element, VimEngineState(appFamily: appFamily))
    } 
    
}


// clipboard management in PGR (coz applyMagicPaste)
extension ASUT_VM_U__Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_not_overwrite_the_Clipboard() {
        let text = """
all that VM d DOES
in characTerwi😂️e is deleting
the SElection!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 64,
            caretLocation: 14,
            selectedLength: 41,
            selectedText: """
        DOES
        in characTerwi😂️e is deleting
        the S
        """,
            fullyVisibleArea: 0..<64,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 64,
                number: 1,
                start: 0,
                end: 19
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        AccessibilityStrategyVisualMode.anchor = 54
        AccessibilityStrategyVisualMode.head = 14
        
        _ = applyMoveBeingTested(on: element, appFamily: .pgR)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
    }

}
