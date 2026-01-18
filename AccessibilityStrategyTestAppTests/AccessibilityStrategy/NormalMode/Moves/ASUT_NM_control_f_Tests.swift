import XCTest
import AccessibilityStrategy
import Common


class ASUT_NM_control_f_Tests: ASUT_NM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.controlF(on: element)
    }
    
}


// TextFields and TextViews
extension ASUT_NM_control_f_Tests {

    func test_that_it_goes_to_the_firstNonBlank_of_the_first_line_of_the_next_page() {
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
            length: 114,
            caretLocation: 37,
            selectedLength: 1,
            selectedText: """


        """,
            fullyVisibleArea: 0..<101,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 114,
                number: 4,
                start: 37,
                end: 38
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 104)
        XCTAssertEqual(returnedElement.selectedLength, 2)
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
            caretLocation: 78,
            selectedLength: 2,
            selectedText: """
        😂
        """,
            fullyVisibleArea: 58..<180,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 180,
                number: 12,
                start: 76,
                end: 84
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 160)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }
    
}
