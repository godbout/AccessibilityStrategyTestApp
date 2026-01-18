@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_slash_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int? = 1, to searchString: String, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.slash(times: count, to: searchString, on: element) 
    }
    
}


// count
extension ASUT_NM_slash_Tests {
    
    func test_that_it_implements_the_count_system() {
        let text = "hehe count is cool yeah count is cool"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 37,
            caretLocation: 8,
            selectedLength: 1,
            selectedText: "n",
            fullyVisibleArea: 0..<37,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 37,
                number: 1,
                start: 0,
                end: 37
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 2, to: "cool", on: element)

        XCTAssertEqual(returnedElement.caretLocation, 33)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    // TODO: this test and the description (func name) are wrong
    // it should loop back through the text, and actually count the pattern skipped
    func test_that_if_the_count_is_too_high_it_loops_back_and_finds_the_first_occurence_in_the_whole_text() {
        let text = "hehe count is cool yeah count is cool"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 37,
            caretLocation: 8,
            selectedLength: 1,
            selectedText: "n",
            fullyVisibleArea: 0..<37,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 37,
                number: 1,
                start: 0,
                end: 37
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 69, to: "cool", on: element)

        XCTAssertEqual(returnedElement.caretLocation, 14)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// regex correct vs regex not correct
extension ASUT_NM_slash_Tests {
    
    func test_that_if_the_regex_given_is_correct_then_it_uses_that_regex_to_search() {
        let text = "ok now we're gonna go harder asNormalMode.h(times: count) alright?"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 66,
            caretLocation: 29,
            selectedLength: 1,
            selectedText: "a",
            fullyVisibleArea: 0..<66,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 66,
                number: 1,
                start: 0,
                end: 66
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "N.*M", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 31)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
       
    func test_that_if_the_regex_is_valid_and_contains_anchors_the_anchors_match_lines() {
        let text = """
ok so now we gonna have
multilines
and $ and ^ should match
end and start of lines
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 82,
            caretLocation: 10,
            selectedLength: 1,
            selectedText: """
        w
        """,
            fullyVisibleArea: 0..<82,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 82,
                number: 1,
                start: 0,
                end: 24
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "h$", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 58)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_regex_given_is_not_correct_then_it_uses_the_literal_version_if_it_to_search() {
        let text = "ok now we're gonna go harder asNormalMode.h(times: count) alright?"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 66,
            caretLocation: 29,
            selectedLength: 1,
            selectedText: "a",
            fullyVisibleArea: 0..<66,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 66,
                number: 1,
                start: 0,
                end: 66
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "h(", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 42)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// TextFields and TextViews
extension ASUT_NM_slash_Tests {
    
    func test_that_in_normal_setting_it_moves_the_caret_to_the_first_occurrence_of_the_pattern_found_to_the_right() {
        let text = "hehe now it's real regex my man not some pussy pussy stuff like before"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 70,
            caretLocation: 25,
            selectedLength: 1,
            selectedText: "m",
            fullyVisibleArea: 0..<70,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 70,
                number: 1,
                start: 0,
                end: 70
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "pussy", on: element)
        
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
            fullyVisibleArea: 0..<42,
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
            fullyVisibleArea: 0..<0,
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
            fullyVisibleArea: 0..<99,
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
            caretLocation: 20,
            selectedLength: 1,
            selectedText: "s",
            fullyVisibleArea: 0..<53,
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
    
    func test_that_if_we_are_already_located_at_the_first_character_of_the_searchPattern_then_it_goes_to_the_next_found_and_does_not_get_stuck_at_the_current_one() {
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
            caretLocation: 11,
            selectedLength: 1,
            selectedText: "p",
            fullyVisibleArea: 0..<87,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 87,
                number: 1,
                start: 0,
                end: 16
            )!
        )
            
        let returnedElement = applyMoveBeingTested(to: "play", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 36)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_there_is_no_searchPattern_found_on_the_right_but_there_are_on_the_left_in_the_whole_text_then_it_loops_around_and_finds_the_first_in_the_whole_text() {
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
            caretLocation: 127,
            selectedLength: 1,
            selectedText: "c",
            fullyVisibleArea: 0..<148,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 148,
                number: 4,
                start: 106,
                end: 148
            )!
        )
            
        let returnedElement = applyMoveBeingTested(to: "gonna", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 13)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }

}
