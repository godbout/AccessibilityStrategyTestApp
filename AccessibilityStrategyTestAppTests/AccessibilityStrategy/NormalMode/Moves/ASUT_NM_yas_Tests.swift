@testable import AccessibilityStrategy
import XCTest
import Common


// this moves uses FT aSentence that is already heavily tested.
// see cas for blah blah
class ASUT_NM_yas_Tests: ASUT_NM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: .auto)

        return applyMoveBeingTested(on: element, &vimEngineState)
    }

    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.yas(on: element, &vimEngineState)
    }

}


// Bip, copy deletion and LYS
extension ASUT_NM_yas_Tests {

    func test_that_it_always_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_copies_the_correct_text() {
        let text = """
ok so here

we're gonna deal with sentences. and shit.
are you OK??
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 67,
            caretLocation: 24,
            selectedLength: 1,
            selectedText: """
        d
        """,
            fullyVisibleArea: 0..<67,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 67,
                number: 3,
                start: 12,
                end: 55
            )!
        )

        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
we're gonna deal with sentences.
"""
        )
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }

}


// TextFields and TextViews
extension ASUT_NM_yas_Tests {

    func test_that_it_copies_the_aSentence_and_repositions_the_caret_at_the_right_location() {
        let text = """
ok so here

we're gonna deal with sentences. and shit.
are you OK??
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 67,
            caretLocation: 47,
            selectedLength: 1,
            selectedText: """
        d
        """,
            fullyVisibleArea: 0..<67,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 67,
                number: 3,
                start: 12,
                end: 55
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
and shit.
"""
        )
        XCTAssertEqual(returnedElement.caretLocation, 45)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }

}


// emojis
extension ASUT_NM_yas_Tests {

    func test_that_it_handles_emojis() {
        let text = """
ok so here

🤣e're gonna deal with ❤️‍🔥entences. and shit.
are you OK??
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 72,
            caretLocation: 22,
            selectedLength: 1,
            selectedText: """
        n
        """,
            fullyVisibleArea: 0..<72,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 72,
                number: 3,
                start: 12,
                end: 60
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
🤣e're gonna deal with ❤️‍🔥entences.
"""
        )
        XCTAssertEqual(returnedElement.caretLocation, 12)
        XCTAssertEqual(returnedElement.selectedLength, 2)
        XCTAssertNil(returnedElement.selectedText)
    }

}
