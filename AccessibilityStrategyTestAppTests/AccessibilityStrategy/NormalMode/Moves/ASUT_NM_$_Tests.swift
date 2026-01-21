import XCTest
@testable import AccessibilityStrategy


// see ^ for blah blah
class ASUT_NM_$_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.dollarSign(times: count, on: element) 
    }
    
}


// line
extension ASUT_NM_$_Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen lines. it will just pass by
them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 115,
            caretLocation: 29,
            selectedLength: 1,
            selectedText: "r",
            fullyVisibleArea: 0..<115,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 2,
                start: 27,
                end: 54
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 60)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
     
}


// count
extension ASUT_NM_$_Tests {
    
    func test_that_it_implements_the_count_system() {
        let text = """
testing with count
should be awesome to use
  😂️ctually nobody uses counts
LMAO
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 80,
            caretLocation: 15,
            selectedLength: 1,
            selectedText: "u",
            fullyVisibleArea: 0..<80,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 80,
                number: 1,
                start: 0,
                end: 19
            )!
        )
                
        let returnedElement = applyMoveBeingTested(times: 3, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 74)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_count_is_too_high_it_ends_up_on_the_last_line() {
        let text = """
testing with count
should be awesome to use
  😂️ctually nobody uses counts
LMAO
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 80,
            caretLocation: 15,
            selectedLength: 1,
            selectedText: "u",
            fullyVisibleArea: 0..<80,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 80,
                number: 1,
                start: 0,
                end: 19
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 79)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
        

// TextFields and TextViews
extension ASUT_NM_$_Tests {
    
    func test_that_if_the_line_does_not_end_with_Newline_it_goes_one_character_before_the_end() {
        let text = "hello world and that's a long one that we gonna wrap 🗺️"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 56,
            caretLocation: 36,
            selectedLength: 1,
            selectedText: "a",
            fullyVisibleArea: 0..<56,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 56,
                number: 2,
                start: 30,
                end: 56
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 53)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_it_sets_both_the_ATE_ColumnNumbers_to_nil() {
        let text = """
when using $
the screenLineColumnNumber
is set to nil so that next
j or k will go to the line endLimit
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 102,
            caretLocation: 49,
            selectedLength: 1,
            selectedText: " ",
            fullyVisibleArea: 0..<102,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 102,
                number: 5,
                start: 40,
                end: 50
            )!
        )
        
        AccessibilityTextElement.fileLineColumnNumber = 10
        AccessibilityTextElement.screenLineColumnNumber = 10
        
        _ = applyMoveBeingTested(on: element)

        XCTAssertNil(AccessibilityTextElement.fileLineColumnNumber)
        XCTAssertNil(AccessibilityTextElement.screenLineColumnNumber)
    }

}
    

// TextViews
extension ASUT_NM_$_Tests {
    
    func test_that_if_the_line_ends_with_a_Newline_it_goes_two_characters_before_the_end() {
        let text = """
indeed that is a multiline
and yes my friend they all
gonna be wrapped
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 70,
            caretLocation: 18,
            selectedLength: 1,
            selectedText: "u",
            fullyVisibleArea: 0..<70,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 70,
                number: 2,
                start: 17,
                end: 27
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 25)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_a_line_is_empty_it_does_not_move() {
        let text = """
$ shouldn't go up one else

it's a bug! my friend hehehehe
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 58,
            caretLocation: 27,
            selectedLength: 0,
            selectedText: "",
            fullyVisibleArea: 0..<58,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 58,
                number: 2,
                start: 27,
                end: 28
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 27)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }

}
