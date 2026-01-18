import XCTest
import AccessibilityStrategy
import Common


class ASUT_NM_control_d_Tests: ASUT_NM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: .auto)
        
        return applyMoveBeingTested(on: element, &vimEngineState)
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
            fullyVisibleArea: 27..<114,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 114,
                number: 18,
                start: 102,
                end: 114
            )!
        )
        
        var vimEngineState = VimEngineState(lastMoveBipped: false)
        let returnedElement = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(returnedElement.caretLocation, 104)
        XCTAssertEqual(returnedElement.selectedLength, 2)
        
        XCTAssertEqual(vimEngineState.lastMoveBipped, true)   
    }
    
    // this test because there was a bug
    func test_that_if_it_is_on_the_lastScreenLine_it_does_not_Bip_if_it_is_not_the_lastFileLine_also() {
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
            caretLocation: 84,
            selectedLength: 1,
            selectedText: """
        L
        """,
            fullyVisibleArea: 0..<84,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 114,
                number: 13,
                start: 84,
                end: 86
            )!
        )
        
        var vimEngineState = VimEngineState(lastMoveBipped: false)
        let returnedElement = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(returnedElement.caretLocation, 104)
        XCTAssertEqual(returnedElement.selectedLength, 2)
        
        XCTAssertEqual(vimEngineState.lastMoveBipped, false)  
    }
    
}


// TextFields and TextViews
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
            fullyVisibleArea: 27..<114,
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
            caretLocation: 0,
            selectedLength: 1,
            selectedText: """
        t
        """,
            fullyVisibleArea: 0..<93,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 143,
                number: 1,
                start: 0,
                end: 8
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 125)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }
    
}
