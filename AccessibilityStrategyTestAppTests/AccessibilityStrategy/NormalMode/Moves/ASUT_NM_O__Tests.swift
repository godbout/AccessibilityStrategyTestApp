@testable import AccessibilityStrategy
import XCTest
import Common


// most in UIT after PG-R Makeover
class ASUT_NM_O__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, appFamily: AppFamily) -> AccessibilityTextElement {
        asNormalMode.O(on: element, VimEngineState(appFamily: appFamily))
    } 
    
}


// clipboard management in PGR (coz applyMagicPaste)
extension ASUT_NM_O__Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_not_overwrite_the_Clipboard() {
        let text = """
tha😄️t's a mu😄️ltiline
an😄️😄️d O will
create a n😄️ew line
abo😄️ve!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 72,
            caretLocation: 0,
            selectedLength: 1,
            selectedText: """
        t
        """,
            fullyVisibleArea: 0..<72,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 72,
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
