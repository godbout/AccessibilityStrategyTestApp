@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_slash_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(to pattern: String, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.slash(to: pattern, on: element) 
    }
    
}


// Both
extension ASUT_NM_slash_Tests {
    
    func test_that_in_normal_setting_it_moves_the_caret_to_the_first_occurence_of_the_pattern_found_to_the_right() {
        let text = "hehe now it's real regex my man not some pussy stuff like before"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 64,
            caretLocation: 15,
            selectedLength: 1,
            selectedText: "e",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 64,
                number: 1,
                start: 0,
                end: 64
            )!
        )
        
        let returnedElement = applyMoveBeingTested(to: "pussy", on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 41)
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
