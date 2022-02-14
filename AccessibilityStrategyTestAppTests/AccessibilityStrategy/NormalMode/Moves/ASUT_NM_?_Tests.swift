@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_interrogationMark_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int? = 1, to searchString: String, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.interrogationMark(times: count, to: searchString, on: element) 
    }
    
}


// count
extension ASUT_NM_interrogationMark_Tests {
    
    func test_that_it_implements_the_count_system() {
        let text = "hehe count is cool yeah count is cool"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 37,
            caretLocation: 33,
            selectedLength: 1,
            selectedText: "c",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 37,
                number: 1,
                start: 0,
                end: 37
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 2, to: "count", on: element)

        XCTAssertEqual(returnedElement.caretLocation, 5)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    // TODO: see /
    func test_that_if_the_count_is_too_high_it_loops_back_and_finds_the_first_occurence_in_the_whole_tex() {
        let text = "hehe count is cool yeah count is cool"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 37,
            caretLocation: 8,
            selectedLength: 1,
            selectedText: "n",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 37,
                number: 1,
                start: 0,
                end: 37
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 69, to: "cool", on: element)

        XCTAssertEqual(returnedElement.caretLocation, 33)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// Both
extension ASUT_NM_interrogationMark_Tests {
    
    func test_that_in_normal_setting_it_moves_the_caret_to_the_first_occurence_of_the_pattern_found_to_the_left() {
        let text = "hehe now it's real regex my man not some pussy pussy stuff like before"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 70,
            caretLocation: 59,
            selectedLength: 1,
            selectedText: "l",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 70,
                number: 1,
                start: 0,
                end: 70
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "pussy", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 47)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_it_considers_the_searchString_as_a_literal_string_by_escaping_the_metacharacters() {
        let text = "ok now we're gonna go harder asNormalMode.h(times: count) alright?"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 66,
            caretLocation: 58,
            selectedLength: 1,
            selectedText: "a",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 66,
                number: 1,
                start: 0,
                end: 66
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: ".h(", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 41)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_it_does_not_crash_if_the_searchString_is_empty() {
        let text = "there's a difference between try! and try?"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 12,
            selectedLength: 1,
            selectedText: "f",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 12)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_it_does_not_crash_if_the_text_is_empty() {
        let text = ""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 0,
            caretLocation: 0,
            selectedLength: 0,
            selectedText: "",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 0,
                number: 1,
                start: 0,
                end: 0
            )!
        )
            
        let returnedElement = applyMoveBeingTested(to: "hehe", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 0)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_searchPattern_is_not_found_then_the_caret_does_not_move() {
        let text = """
gonna look for a search pattern that is not there
and the caret shouldn't move else pan pan cul cul
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 99,
            caretLocation: 24,
            selectedLength: 1,
            selectedText: "p",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 99,
                number: 1,
                start: 0,
                end: 50
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "noooooooope", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 24)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_there_is_a_slash_in_the_searchString_then_the_searchPattern_is_considered_what_comes_before_that_slash() {
        let text = "ok so now we gonna use a searchString with a / inside"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 53,
            caretLocation: 49,
            selectedLength: 1,
            selectedText: "s",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 53,
                number: 1,
                start: 0,
                end: 53
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "search/hehe", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 25)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_we_are_already_located_at_the_first_character_of_the_searchPattern_then_it_goes_to_the_previous_found_and_does_not_get_stuck_at_the_current_one() {
        let text = """
ok time to play
with multilines and play
also with the caret getting
blocked haha. play
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 87,
            caretLocation: 36,
            selectedLength: 1,
            selectedText: "p",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 87,
                number: 2,
                start: 16,
                end: 41
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "play", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 11)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_the_same_as_above_but_with_the_searchPattern_at_the_end_of_the_text() {
        let text = """
ok time to play
with multilines and play
also with the caret getting
blocked haha. play
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 87,
            caretLocation: 83,
            selectedLength: 1,
            selectedText: "p",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 87,
                number: 2,
                start: 16,
                end: 41
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "play", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 36)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_we_are_located_after_the_first_character_of_the_searchPattern_but_still_within_the_searchPattern_then_it_finds_that_current_searchPattern() {
        let text = """
ok time to play
with multilines and play
also with the caret getting
blocked haha. play
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 87,
            caretLocation: 37,
            selectedLength: 1,
            selectedText: "p",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 87,
                number: 2,
                start: 16,
                end: 41
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "play", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 36)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_the_same_as_above_but_with_the_searchPattern_at_the_end_of_the_text_bis() {
        let text = """
ok time to play
with multilines and play
also with the caret getting
blocked haha. play
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 87,
            caretLocation: 84,
            selectedLength: 1,
            selectedText: "l",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 87,
                number: 4,
                start: 69,
                end: 87
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "play", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 83)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_there_is_no_searchPattern_found_on_the_left_but_there_are_on_the_right_in_the_whole_text_then_it_loops_around_and_finds_the_last_in_the_whole_text() {
        let text = """
so now we're gonna have some text
and we're gonna look for the next one
but they'll be none so it's gonna
loop around search back from the beginning
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 148,
            caretLocation: 3,
            selectedLength: 1,
            selectedText: "c",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 148,
                number: 4,
                start: 106,
                end: 148
            )!
        )
            
        let returnedElement = applyMoveBeingTested(to: "gonna", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 100)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }

}
