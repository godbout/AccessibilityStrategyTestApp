import XCTest
@testable import AccessibilityStrategy


class ASUT_NM_gg_Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.gg(on: element)
    }
    
}


// line
extension ASUT_NM_gg_Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen lines. it will just pass by
them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 115,
            caretLocation: 86,
            selectedLength: 1,
            selectedText: "e",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 10,
                start: 80,
                end: 90
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 0)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
     
}


// TextFields
extension ASUT_NM_gg_Tests {
    
    func test_that_it_goes_to_the_beginning_of_the_line_if_it_starts_with_non_blank() {
        let text = "a normal sentence"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 17,
            caretLocation: 13,
            selectedLength: 1,
            selectedText: "e",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 17,
                number: 2,
                start: 9,
                end: 17
            )!
        )
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 0)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
    }
    
    func test_that_it_goes_to_the_first_non_blank_of_the_line() {
        let text = "      😀️g should go to 😀️"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 27,
            caretLocation: 24,
            selectedLength: 3,
            selectedText: "😀️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 27,
                number: 3,
                start: 24,
                end: 27
            )!
        )
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 6)
        XCTAssertEqual(returnedElement?.selectedLength, 3)
    }
    
    func test_that_it_goes_to_the_end_limit_of_the_line_if_there_is_no_non_blank() {
        let text = "         "
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 9,
            caretLocation: 5,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 9,
                number: 1,
                start: 0,
                end: 9
            )!
        )
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 8)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
    }
    
}


// TextViews
extension ASUT_NM_gg_Tests {
    
    func test_that_it_goes_to_the_first_character_of_the_TextView_if_it_starts_with_non_blank() {
        let text = """
a beautiful poem
right
here
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 27,
            caretLocation: 20,
            selectedLength: 1,
            selectedText: "h",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 27,
                number: 3,
                start: 17,
                end: 23
            )!
        )
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 0)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
    }
    
    func test_that_it_goes_to_the_first_non_blank_of_the_TextView() {
        let text = """
   🇫🇷️ couple of spaces
then a lot
of
bullshit
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 48,
            caretLocation: 38,
            selectedLength: 1,
            selectedText: "f",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 48,
                number: 4,
                start: 37,
                end: 40
            )!
        )
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 3)
        XCTAssertEqual(returnedElement?.selectedLength, 5)
    }
    
    func test_that_it_works_with_an_empty_first_line() {
        let text = """

first line is
completely empty
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 31,
            caretLocation: 30,
            selectedLength: 1,
            selectedText: "y",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 5,
                start: 26,
                end: 31
            )!
        )
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 0)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
    }
    
    func test_that_it_stops_at_the_end_limit_when_the_first_line_is_just_spaces() {
        let text = """
        
lol lots of spaces
again only
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 38,
            caretLocation: 13,
            selectedLength: 1,
            selectedText: "l",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 38,
                number: 2,
                start: 9,
                end: 21
            )!
        )
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 7)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
    }
    
}
