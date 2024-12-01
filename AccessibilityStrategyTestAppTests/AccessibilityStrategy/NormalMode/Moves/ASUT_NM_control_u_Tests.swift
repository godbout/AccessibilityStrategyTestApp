import XCTest
import AccessibilityStrategy
import Common


class ASUT_NM_control_u_Tests: ASUT_NM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: .auto)
        
        return applyMoveBeingTested(on: element, &vimEngineState)
    }
        
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEnginestate: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.controlU(on: element, &vimEnginestate)
    }
    
}


// Bip
extension ASUT_NM_control_u_Tests {
    
    func test_that_if_it_is_on_the_firstFileLine_then_it_Bips_and_does_not_move() {
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
            caretLocation: 1,
            selectedLength: 2,
            selectedText: """
        😂
        """,
            fullyVisibleArea: 0..<84,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 114,
                number: 1,
                start: 0,
                end: 18
            )!
        )
        
        var vimEngineState = VimEngineState(lastMoveBipped: false)
        let returnedElement = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(returnedElement.caretLocation, 1)
        XCTAssertEqual(returnedElement.selectedLength, 2)
        
        XCTAssertEqual(vimEngineState.lastMoveBipped, true)   
    }
    
    // this test because there was a bug
    func test_that_if_it_is_on_the_firstScreenLine_it_does_not_Bip_if_it_is_not_the_firstFileLine_also() {
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
            caretLocation: 49,
            selectedLength: 1,
            selectedText: """
        s
        """,
            fullyVisibleArea: 49..<114,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 114,
                number: 6,
                start: 49,
                end: 58
            )!
        )
        
        var vimEngineState = VimEngineState(lastMoveBipped: false)
        let returnedElement = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(returnedElement.caretLocation, 1)
        XCTAssertEqual(returnedElement.selectedLength, 2)
        
        XCTAssertEqual(vimEngineState.lastMoveBipped, false)  
    }
    
}


// Both
extension ASUT_NM_control_u_Tests {

    func test_that_it_goes_to_the_firstNonBlank_of_the_line_that_is_half_a_page_up_the_current_one() {
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
            caretLocation: 78,
            selectedLength: 2,
            selectedText: """
        😂
        """,
            fullyVisibleArea: 0..<101,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 114,
                number: 12,
                start: 76,
                end: 84
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 37)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }
    
    func test_that_if_adding_the_half_page_up_is_too_much_and_goes_before_the_beginning_of_the_text_then_it_goes_to_the_firstNonBlank_of_the_firstFileLine() {
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
            caretLocation: 32,
            selectedLength: 1,
            selectedText: """
        v
        """,
            fullyVisibleArea: 0..<101,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 114,
                number: 3,
                start: 27,
                end: 37
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 1)
        XCTAssertEqual(returnedElement.selectedLength, 2)
    }
    
    // this test because there was a bug
    func test_that_if_a_FileLine_fills_the_whole_input_it_can_still_go_half_a_page_down() {
        let text = """
this is gonna be one big long ass line but that is gonna fill the whole input and after that there's gonna be an other line.
ok here we go now.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 143,
            caretLocation: 125,
            selectedLength: 1,
            selectedText: """
        o
        """,
            fullyVisibleArea: 51..<143,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 143,
                number: 17,
                start: 125,
                end: 133
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }
    
}
