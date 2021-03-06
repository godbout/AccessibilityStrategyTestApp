import XCTest
@testable import AccessibilityStrategy


class ASUT_NM_gg_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int? = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.gg(times: count, on: element)
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
            fullyVisibleArea: 0..<115,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 10,
                start: 80,
                end: 90
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
     
}


// count
extension ASUT_NM_gg_Tests {
    
    func test_that_it_implements_the_count_system() {
        let text = """
ok now we've stop playing
and we add count for gg and G
  😂️nd we're gonna go to some line
but hey surprise mofo
"""        
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 113,
            caretLocation: 112,
            selectedLength: 1,
            selectedText: "o",
            fullyVisibleArea: 0..<113,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 113,
                number: 4,
                start: 92,
                end: 113
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 3, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 58)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_count_is_nil_then_it_goes_to_the_first_line() {
        let text = """
ok now we've stop playing
and we add count for gg and G
  😂️nd we're gonna go to some line
but hey surprise mofo
"""        
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 113,
            caretLocation: 112,
            selectedLength: 1,
            selectedText: "o",
            fullyVisibleArea: 0..<113,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 113,
                number: 4,
                start: 92,
                end: 113
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: nil, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_count_is_1_then_it_goes_to_the_first_line() {
        let text = """
ok now we've stop playing
and we add count for gg and G
  😂️nd we're gonna go to some line
but hey surprise mofo
"""        
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 113,
            caretLocation: 112,
            selectedLength: 1,
            selectedText: "o",
            fullyVisibleArea: 0..<113,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 113,
                number: 4,
                start: 92,
                end: 113
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 1, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_count_is_too_high_it_goes_to_the_last_line() {
        let text = """
ok now we've stop playing
and we add count for gg and G
  😂️nd we're gonna go to some line
but hey surprise mofo
"""        
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 113,
            caretLocation: 112,
            selectedLength: 1,
            selectedText: "o",
            fullyVisibleArea: 0..<113,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 113,
                number: 4,
                start: 92,
                end: 113
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 92)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
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
            fullyVisibleArea: 0..<17,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 17,
                number: 2,
                start: 9,
                end: 17
            )!
        )
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 1)
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
            fullyVisibleArea: 0..<27,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 27,
                number: 3,
                start: 24,
                end: 27
            )!
        )
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 6)
        XCTAssertEqual(returnedElement.selectedLength, 3)
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
            fullyVisibleArea: 0..<9,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 9,
                number: 1,
                start: 0,
                end: 9
            )!
        )
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 1)
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
            fullyVisibleArea: 0..<27,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 27,
                number: 3,
                start: 17,
                end: 23
            )!
        )
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 1)
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
            fullyVisibleArea: 0..<48,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 48,
                number: 4,
                start: 37,
                end: 40
            )!
        )
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 3)
        XCTAssertEqual(returnedElement.selectedLength, 5)
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
            fullyVisibleArea: 0..<31,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 5,
                start: 26,
                end: 31
            )!
        )
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 1)
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
            fullyVisibleArea: 0..<38,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 38,
                number: 2,
                start: 9,
                end: 21
            )!
        )
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 7)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }
    
}
