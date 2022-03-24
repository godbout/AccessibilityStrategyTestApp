import XCTest
import AccessibilityStrategy
import Common


class ASUT_NM_control_b_Tests: ASUT_NM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.controlB(on: element)
    }
    
}


// Both
extension ASUT_NM_control_b_Tests {

    func test_that_it_goes_to_the_firstNonBlank_of_the_last_line_of_the_previous_page() {
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
we need
to add a bit more
here else it's not
gonna test very well
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 180,
            caretLocation: 164,
            selectedLength: 1,
            selectedText: """
        a
        """,
            visibleCharacterRange: 58..<180,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 180,
                number: 22,
                start: 160,
                end: 180
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 49)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }
    
    func test_that_if_there_is_no_next_page_then_it_goes_to_the_firstNonBlank_of_the_lastFileLine() {
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
we need
to add a bit more
here else it's not
gonna test very well
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 180,
            caretLocation: 32,
            selectedLength: 1,
            selectedText: """
        v
        """,
            visibleCharacterRange: 0..<101,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 180,
                number: 3,
                start: 27,
                end: 37
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 1)
        XCTAssertEqual(returnedElement.selectedLength, 2)
    }
    
}
