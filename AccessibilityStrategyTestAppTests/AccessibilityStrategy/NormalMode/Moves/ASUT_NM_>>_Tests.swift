@testable import AccessibilityStrategy
import Common
import XCTest


// see << but also some UT here
class ASUT_NM_rightChevronRightChevron_Tests: ASUT_NM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement, appFamily: AppFamily) -> AccessibilityTextElement {
        asNormalMode.rightChevronRightChevron(on: element, VimEngineState(appFamily: appFamily))
    }

}


// clipboard management in PGR (coz applyMagicPaste)
extension ASUT_NM_rightChevronRightChevron_Tests {

    func test_that_when_it_is_called_in_PGR_Mode_it_does_not_overwrite_the_Clipboard() {
        let text = """
seems that even the normal
🖕️ase fails LMAO
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 44,
            caretLocation: 0,
            selectedLength: 1,
            selectedText: """
        s
        """,
            fullyVisibleArea: 0..<44,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 1,
                start: 0,
                end: 27
            )!
        )
        copyToClipboard(text: "some fake shit")

        _ = applyMoveBeingTested(on: element, appFamily: .pgR)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
    }

}
