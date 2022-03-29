@testable import AccessibilityStrategy
import XCTest
import Common


// see ; for blah blah
class ASUT_NM_comma_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int? = 1, lastLeftRightSearch: LastLeftRightSearch, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.comma(times: count, lastLeftRightSearch: lastLeftRightSearch, on: element)
    }
    
}


// see ; for blah blah
extension ASUT_NM_comma_Tests {
    
    func test_that_if_lastLeftRightSearch_is_F_it_simply_forward_parameters_to_the_f_move() {
        let text = "we gonna use the same sentence to do 💩️💩️💩️ several tests with different LastLeftRightSearch params"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 102,
            caretLocation: 80,
            selectedLength: 1,
            selectedText: "L",
            fullyVisibleArea: 0..<102,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 102,
                number: 1,
                start: 0,
                end: 102
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 3, lastLeftRightSearch: LastLeftRightSearch(motion: .F, character: "a"), on: element)

        XCTAssertEqual(returnedElement.caretLocation, 99)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_lastLeftRightSearch_is_f_it_simply_forward_parameters_to_the_F_move() {
        let text = "we gonna use the same sentence to do 💩️💩️💩️ several tests with different LastLeftRightSearch params"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 29,
            caretLocation: 49,
            selectedLength: 1,
            selectedText: "L",
            fullyVisibleArea: 0..<29,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 102,
                number: 1,
                start: 0,
                end: 102
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 6, lastLeftRightSearch: LastLeftRightSearch(motion: .f, character: "e"), on: element)

        XCTAssertEqual(returnedElement.caretLocation, 15)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
        
}


// and see ; for blah blah
extension ASUT_NM_comma_Tests {
    
    func test_that_if_lastLeftRightSearch_is_T_and_the_caret_is_right_before_the_character_we_are_searching_for_and_the_count_is_nil_then_the_count_becomes_2_so_that_the_caret_can_move_using_t() {
        let text = "we gonna use the same sentence to do 💩️💩️💩️ several tests with different LastLeftRightSearch params"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 102,
            caretLocation: 69,
            selectedLength: 1,
            selectedText: "n",
            fullyVisibleArea: 0..<102,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 102,
                number: 1,
                start: 0,
                end: 102
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: nil, lastLeftRightSearch: LastLeftRightSearch(motion: .T, character: "e"), on: element)

        XCTAssertEqual(returnedElement.caretLocation, 71)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_lastLeftRightSearch_is_T_and_the_caret_is_right_before_the_character_we_are_searching_for_and_the_count_is_1_then_the_count_becomes_2_so_that_the_caret_can_move_using_t() {
        let text = "we gonna use the same sentence to do 💩️💩️💩️ several tests with different LastLeftRightSearch params"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 102,
            caretLocation: 69,
            selectedLength: 1,
            selectedText: "n",
            fullyVisibleArea: 0..<102,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 102,
                number: 1,
                start: 0,
                end: 102
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 1, lastLeftRightSearch: LastLeftRightSearch(motion: .T, character: "e"), on: element)

        XCTAssertEqual(returnedElement.caretLocation, 71)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_lastLeftRightSearch_is_t_and_the_caret_is_right_after_the_character_we_are_searching_for_and_the_count_is_nil_then_the_count_becomes_2_so_that_the_caret_can_move_using_T() {
        let text = "we gonna use the same sentence to do 💩️💩️💩️ several tests with different LastLeftRightSearch params"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 102,
            caretLocation: 18,
            selectedLength: 1,
            selectedText: "n",
            fullyVisibleArea: 0..<102,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 102,
                number: 1,
                start: 0,
                end: 102
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: nil, lastLeftRightSearch: LastLeftRightSearch(motion: .t, character: "s"), on: element)

        XCTAssertEqual(returnedElement.caretLocation, 11)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_lastLeftRightSearch_is_t_and_the_caret_is_right_after_the_character_we_are_searching_for_and_the_count_is_1_then_the_count_becomes_2_so_that_the_caret_can_move_using_T() {
        let text = "we gonna use the same sentence to do 💩️💩️💩️ several tests with different LastLeftRightSearch params"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 102,
            caretLocation: 18,
            selectedLength: 1,
            selectedText: "n",
            fullyVisibleArea: 0..<102,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 102,
                number: 1,
                start: 0,
                end: 102
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 1, lastLeftRightSearch: LastLeftRightSearch(motion: .t, character: "s"), on: element)

        XCTAssertEqual(returnedElement.caretLocation, 11)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
