@testable import AccessibilityStrategy
import XCTest
import Common


// see NM O for blah blah
class ASUT_NM_o_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, appFamily: AppFamily) -> AccessibilityTextElement {
        asNormalMode.o(on: element, VimEngineState(appFamily: appFamily))
    } 
    
}


// clipboard management in PGR (coz applyMagicPaste)
extension ASUT_NM_o_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_not_overwrite_the_Clipboard() {
        let text = """
that's a multiline and o will create a new line
between the first file line and the second file line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 100,
            caretLocation: 0,
            selectedLength: 1,
            selectedText: """
        t
        """,
            fullyVisibleArea: 0..<100,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 100,
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
