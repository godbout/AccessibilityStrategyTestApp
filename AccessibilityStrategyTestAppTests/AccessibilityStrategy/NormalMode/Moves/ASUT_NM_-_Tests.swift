import XCTest
@testable import AccessibilityStrategy
import Common


class ASUT_NM_minus_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int? = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState()
        
        return asNormalMode.minus(times: count, on: element, &vimEngineState)
    }
    
    private func applyMoveBeingTested(times count: Int? = 1, on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.minus(times: count, on: element, &vimEngineState)
    }

}


// line
extension ASUT_NM_minus_Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen lines. it will just pass by
them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 115,
            caretLocation: 97,
            selectedLength: 1,
            selectedText: """
        h
        """,
            fullyVisibleArea: 0..<115,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 2,
                start: 62,
                end: 115
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
     
}


// Bip
extension ASUT_NM_minus_Tests {
    
    func test_that_if_the_caret_is_at_the_first_line_then_it_bips() {
        let text = "well first line or TV 🍍️ or a TF same same"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 43,
            caretLocation: 19,
            selectedLength: 1,
            selectedText: """
        T
        """,
            fullyVisibleArea: 0..<43,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 43,
                number: 1,
                start: 0,
                end: 43
            )!
        )

        var vimEngineState = VimEngineState(lastMoveBipped: false)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertTrue(vimEngineState.lastMoveBipped)
    }

}


// count
extension ASUT_NM_minus_Tests {
    
    func test_that_it_implements_the_count_system() {
        let text = """
let's go some count down
  some lines
with minus
   😀️ok?
ok.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 62,
            caretLocation: 55,
            selectedLength: 1,
            selectedText: """
        o
        """,
            fullyVisibleArea: 0..<62,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 62,
                number: 4,
                start: 49,
                end: 59
            )!
        )

        let returnedElement = applyMoveBeingTested(times: 2, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 27)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_count_is_too_high_it_goes_to_the_first_line() {
        let text = """
let's go some count down
some lines
with minus
   😀️ok?
ok.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 60,
            caretLocation: 53,
            selectedLength: 1,
            selectedText: """
        o
        """,
            fullyVisibleArea: 0..<60,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 60,
                number: 4,
                start: 47,
                end: 57
            )!
        )

        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// Both
extension ASUT_NM_minus_Tests {

    func test_that_if_the_caret_is_at_the_first_line_then_it_does_not_move() {
        let text = "whether a TF or the first 🍎️ line of a TV"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 26,
            selectedLength: 3,
            selectedText: """
        🍎️
        """,
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 26)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// TextViews
extension ASUT_NM_minus_Tests {

    func test_that_it_goes_to_the_first_character_of_the_previous_line() {
        let text = """
hehehe
🪓️ave xxx
do you want to
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 32,
            caretLocation: 22,
            selectedLength: 1,
            selectedText: """
        o
        """,
            fullyVisibleArea: 0..<32,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 32,
                number: 3,
                start: 18,
                end: 32
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 7)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }

    func test_that_it_actually_goes_to_the_first_non_blank_of_the_previous_line() {
        let text = """
hehe so return in AS
        will go
    😂️o the the first
non blank of previous line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 86,
            caretLocation: 41,
            selectedLength: 3,
            selectedText: """
        😂️
        """,
            fullyVisibleArea: 0..<86,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 86,
                number: 3,
                start: 37,
                end: 60
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 29)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_it_works_with_an_empty_line() {
        let text = """
the next line
will be empty

hehe
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 33,
            caretLocation: 30,
            selectedLength: 1,
            selectedText: """
        e
        """,
            fullyVisibleArea: 0..<33,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 33,
                number: 4,
                start: 29,
                end: 33
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 28)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    // this test contains blanks
    func test_that_it_stops_at_the_first_non_blank_limit_if_line_is_just_spaces() {
        let text = """
fucking loads of spaces
             
that we can't see
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 55,
            caretLocation: 48,
            selectedLength: 1,
            selectedText: """
        n
        """,
            fullyVisibleArea: 0..<55,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 55,
                number: 3,
                start: 38,
                end: 55
            )!
        )
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 36)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
