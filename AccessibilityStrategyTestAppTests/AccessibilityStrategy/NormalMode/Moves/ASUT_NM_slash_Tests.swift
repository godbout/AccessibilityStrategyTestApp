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
    
    func test_that_if_the_count_is_too_high_and_therefore_string_is_not_found_then_it_does_not_move() {
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

        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}



// Both
extension ASUT_NM_slash_Tests {
    
    func test_that_in_normal_setting_it_moves_the_caret_to_the_first_occurence_of_the_pattern_found_to_the_right() {
        let text = "hehe now it's real regex my man not some pussy pussy stuff like before"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 70,
            caretLocation: 25,
            selectedLength: 1,
            selectedText: "m",
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
    
    func test_that_if_there_is_a_slash_in_the_searchString_then_the_searchPattern_is_what_comes_before_that_slash() {
        let text = "ok so now we gonna use a searchString with a / inside"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 53,
            caretLocation: 20,
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
    
//    func test_that_if_the_character_is_not_found_then_the_caret_does_not_move() {
//        let text = """
//gonna look for a character that is not there
//and the caret shouldn't move else pan pan cul cul
//"""
//        let element = AccessibilityTextElement(
//            role: .textArea,
//            value: text,
//            length: 94,
//            caretLocation: 22,
//            selectedLength: 1,
//            selectedText: "c",
//            currentScreenLine: ScreenLine(
//                fullTextValue: text,
//                fullTextLength: 94,
//                number: 3,
//                start: 17,
//                end: 27
//            )!
//        )
//        
//        let returnedElement = applyMoveBeingTested(to: "z", on: element)
//        
//        XCTAssertEqual(returnedElement.caretLocation, 22)
//        XCTAssertEqual(returnedElement.selectedLength, 1)
//        XCTAssertNil(returnedElement.selectedText)
//    }
//    
//    func test_that_if_it_is_on_a_character_and_we_look_for_the_same_character_it_moves_to_that_next_occurrence() {
//        let text = """
//it you're already on a z for example and wanna go to the next z it should work
//"""
//        let element = AccessibilityTextElement(
//            role: .textArea,
//            value: text,
//            length: 78,
//            caretLocation: 23,
//            selectedLength: 1,
//            selectedText: "z",
//            currentScreenLine: ScreenLine(
//                fullTextValue: text,
//                fullTextLength: 78,
//                number: 2,
//                start: 10,
//                end: 25
//            )!
//        )
//        
//        let returnedElement = applyMoveBeingTested(to: "z", on: element)
//        
//        XCTAssertEqual(returnedElement.caretLocation, 62)
//        XCTAssertEqual(returnedElement.selectedLength, 1)
//        XCTAssertNil(returnedElement.selectedText)
//    }
    
}
