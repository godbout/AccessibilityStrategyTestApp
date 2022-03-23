import XCTest
import AccessibilityStrategy
import Common


class ASUT_NM_control_d_Tests: ASUT_NM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: .auto)
        
        return applyMoveBeingTested(on: element, &state)
    }
        
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEnginestate: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.controlD(on: element, &vimEnginestate)
    }
    
}


// Bip
extension ASUT_NM_control_d_Tests {
    
    func test_that_if_it_is_on_the_lastFileLine_then_it_Bips_and_does_not_move() {
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
            caretLocation: 104,
            selectedLength: 2,
            selectedText: """
        🐍
        """,
            visibleCharacterRange: 27..<114,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 114,
                number: 18,
                start: 102,
                end: 114
            )!
        )
        
        var state = VimEngineState(lastMoveBipped: false)
        let returnedElement = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(returnedElement.caretLocation, 104)
        XCTAssertEqual(returnedElement.selectedLength, 2)
        
        XCTAssertEqual(state.lastMoveBipped, true)   
    }
    
}


// Both
extension ASUT_NM_control_d_Tests {

    func test_that_it_goes_to_the_firstNonBlank_of_the_line_that_is_half_a_page_down_the_current_one() {
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
            caretLocation: 37,
            selectedLength: 1,
            selectedText: """


        """,
            visibleCharacterRange: 0..<101,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 114,
                number: 4,
                start: 37,
                end: 38
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 78)
        XCTAssertEqual(returnedElement.selectedLength, 2)
    }
    
    func test_that_if_adding_the_half_page_down_is_too_much_and_goes_after_the_end_of_the_text_then_it_goes_to_the_firstNonBlank_of_the_lastFileLine() {
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
            caretLocation: 87,
            selectedLength: 1,
            selectedText: """
        c
        """,
            visibleCharacterRange: 27..<114,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 114,
                number: 15,
                start: 87,
                end: 94
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 104)
        XCTAssertEqual(returnedElement.selectedLength, 2)
    }
    
}
