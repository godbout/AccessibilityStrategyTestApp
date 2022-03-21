import XCTest
import AccessibilityStrategy


class ASUT_NM_M__Tests: ASUT_NM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.M(on: element) 
    }
    
}


// scroll
extension ASUT_NM_M__Tests {
    
    func test_that_it_should_not_scroll() {
        let text = ""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 0,
            caretLocation: 0,
            selectedLength: 0,
            selectedText: """

        """,
            visibleCharacterRange: 0..<0,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 0,
                number: 1,
                start: 0,
                end: 0
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertFalse(returnedElement.shouldScroll)
    }

}


// TextViews
extension ASUT_NM_M__Tests {

    func test_that_it_goes_half_between_the_highest_screenLine_and_the_lowest_screenLine() {
        let text = """
 😂k so now we're
going to
have very

long lines
so that 
   😂he H
and

M

  😂and
L

can be
tested

  🐍roperly!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 114,
            caretLocation: 70,
            selectedLength: 1,
            selectedText: """
        d
        """,
            visibleCharacterRange: 58..<114,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 114,
                number: 8,
                start: 68,
                end: 72
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 78)
        XCTAssertEqual(returnedElement.selectedLength, 2)
    }
    
}
