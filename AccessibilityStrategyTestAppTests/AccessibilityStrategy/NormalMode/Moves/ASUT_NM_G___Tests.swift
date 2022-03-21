import XCTest
@testable import AccessibilityStrategy


class ASUT_NM_G__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int? = nil, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.G(times: count, on: element)
    }
    
}


// line
extension ASUT_NM_G__Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen lines. it will just pass by
them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 115,
            caretLocation: 13,
            selectedLength: 1,
            selectedText: "s",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 2,
                start: 10,
                end: 19
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 62)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
     
}


// count
extension ASUT_NM_G__Tests {
    
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
            visibleCharacterRange: 0..<113,
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
    
    func test_that_if_count_is_nil_then_it_goes_to_the_last_line() {
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
            visibleCharacterRange: 0..<113,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 113,
                number: 4,
                start: 92,
                end: 113
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: nil, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 92)
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
            visibleCharacterRange: 0..<113,
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
            visibleCharacterRange: 0..<113,
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


// both
extension ASUT_NM_G__Tests {
    
    func test_that_it_goes_to_the_beginning_of_the_line_if_it_starts_with_non_blank() {
        let text = "a normal sentence for G"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 23,
            caretLocation: 14,
            selectedLength: 1,
            selectedText: "n",
            visibleCharacterRange: 0..<23,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 23,
                number: 1,
                start: 0,
                end: 23
            )!
        )
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }
    
    func test_that_it_goes_to_the_first_non_blank_of_the_line() {
        let text = "      🍆️ should go to well 🍆️"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 31,
            caretLocation: 16,
            selectedLength: 1,
            selectedText: " ",
            visibleCharacterRange: 0..<31,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 1,
                start: 0,
                end: 31
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
            caretLocation: 6,
            selectedLength: 1,
            selectedText: " ",
            visibleCharacterRange: 0..<9,
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
extension ASUT_NM_G__Tests {
    
    func test_that_it_goes_to_the_first_character_of_the_last_line_of_the_TextView_if_that_line_starts_with_non_blank() {
        let text = """
hehehe
do you want to
🪓️ave xxx
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 32,
            caretLocation: 30,
            selectedLength: 1,
            selectedText: "x",
            visibleCharacterRange: 0..<32,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 32,
                number: 4,
                start: 22,
                end: 32
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 22)
        XCTAssertEqual(returnedElement.selectedLength, 3)
    }
    
    func test_that_it_goes_to_the_first_non_blank_of_the_last_line_of_the_TextView() {
        let text = """
 that's another
story bro
   and it's not easy
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 46,
            caretLocation: 4,
            selectedLength: 1,
            selectedText: "t",
            visibleCharacterRange: 0..<46,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 46,
                number: 1,
                start: 0,
                end: 16
            )!
        )
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 29)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }
    
    func test_that_it_works_with_an_empty_last_line() {
        let text = """
last line is
completely empty

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 30,
            caretLocation: 6,
            selectedLength: 1,
            selectedText: "i",
            visibleCharacterRange: 0..<30,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 30,
                number: 1,
                start: 0,
                end: 13
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 30)
        XCTAssertEqual(returnedElement.selectedLength, 0)
    }
    
    func test_that_it_stops_at_the_end_limit_when_the_last_line_is_just_spaces() {
        let text = """
fucking loads of spaces
again at the last line
             
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 60,
            caretLocation: 20,
            selectedLength: 1,
            selectedText: "c",
            visibleCharacterRange: 0..<60,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 60,
                number: 3,
                start: 17,
                end: 24
            )!
        )
       
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 59)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }
    
    func test_that_if_the_last_line_is_not_empty_and_the_caret_is_not_on_that_line_then_the_caret_still_goes_to_the_last_line_and_does_not_get_stuck_on_the_current_line() {
        let text = """
caret seems stuck
to the line it is
why
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 39,
            caretLocation: 4,
            selectedLength: 1,
            selectedText: "t",
            visibleCharacterRange: 0..<39,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 39,
                number: 1,
                start: 0,
                end: 12
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 36)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }
    
}
