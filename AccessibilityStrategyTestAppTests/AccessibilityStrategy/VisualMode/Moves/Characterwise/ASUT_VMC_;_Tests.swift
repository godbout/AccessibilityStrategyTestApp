@testable import AccessibilityStrategy
import XCTest
import Common


// see NM ; for blah blah
class ASUT_VM_semicolon_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int? = 1, lastLeftRightSearch: LeftRightSearch, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let state = VimEngineState(visualStyle: .characterwise)

        return asVisualMode.semicolon(times: count, lastLeftRightSearch: lastLeftRightSearch, on: element, state)
    }
    
}


// see NM ; for blah blah
extension ASUT_VM_semicolon_Tests {
    
    func test_that_if_lastLeftRightSearch_is_F_it_simply_forward_parameters_to_the_F_move() {
        let text = "we gonna use the same sentence to do 💩️💩️💩️ several tests with different LastLeftRightSearch params"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 102,
            caretLocation: 80,
            selectedLength: 13,
            selectedText: "LeftRightSear",
            fullyVisibleArea: 0..<102,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 102,
                number: 1,
                start: 0,
                end: 102
            )!
        )
               
        AccessibilityStrategyVisualMode.anchor = 80
        AccessibilityStrategyVisualMode.head = 92
        
        let returnedElement = applyMoveBeingTested(times: 3, lastLeftRightSearch: LeftRightSearch(motion: .F, character: "a"), on: element)

        XCTAssertEqual(returnedElement.caretLocation, 52)
        XCTAssertEqual(returnedElement.selectedLength, 29)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_lastLeftRightSearch_is_f_it_simply_forward_parameters_to_the_f_move() {
        let text = "we gonna use the same sentence to do 💩️💩️💩️ several tests with different LastLeftRightSearch params"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 102,
            caretLocation: 1,
            selectedLength: 4,
            selectedText: "e go",
            fullyVisibleArea: 0..<102,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 102,
                number: 1,
                start: 0,
                end: 102
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 1
        AccessibilityStrategyVisualMode.head = 4
        
        let returnedElement = applyMoveBeingTested(times: 6, lastLeftRightSearch: LeftRightSearch(motion: .f, character: "e"), on: element)

        XCTAssertEqual(returnedElement.caretLocation, 1)
        XCTAssertEqual(returnedElement.selectedLength, 29)
        XCTAssertNil(returnedElement.selectedText)
    }
        
}


// and see NM ; for blah blah
extension ASUT_VM_semicolon_Tests {
    
    func test_that_if_lastLeftRightSearch_is_T_and_the_head_is_right_after_the_character_we_are_searching_for_and_the_count_is_nil_then_the_count_becomes_2_so_that_the_head_can_move_using_T() {
        let text = "we gonna use the same sentence to do 💩️💩️💩️ several tests with different LastLeftRightSearch params"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 102,
            caretLocation: 69,
            selectedLength: 14,
            selectedText: "ferent LastLef",
            fullyVisibleArea: 0..<102,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 102,
                number: 1,
                start: 0,
                end: 102
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 69
        AccessibilityStrategyVisualMode.head = 82

        let returnedElement = applyMoveBeingTested(times: nil, lastLeftRightSearch: LeftRightSearch(motion: .T, character: "e"), on: element)

        XCTAssertEqual(returnedElement.caretLocation, 69)
        XCTAssertEqual(returnedElement.selectedLength, 5)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_lastLeftRightSearch_is_T_and_the_head_is_right_after_the_character_we_are_searching_for_and_the_count_is_1_then_the_count_becomes_2_so_that_the_head_can_move_using_T() {
        let text = "we gonna use the same sentence to do 💩️💩️💩️ several tests with different LastLeftRightSearch params"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 102,
            caretLocation: 69,
            selectedLength: 14,
            selectedText: "ferent LastLef",
            fullyVisibleArea: 0..<102,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 102,
                number: 1,
                start: 0,
                end: 102
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 69
        AccessibilityStrategyVisualMode.head = 82

        let returnedElement = applyMoveBeingTested(times: 1, lastLeftRightSearch: LeftRightSearch(motion: .T, character: "e"), on: element)

        XCTAssertEqual(returnedElement.caretLocation, 69)
        XCTAssertEqual(returnedElement.selectedLength, 5)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_lastLeftRightSearch_is_t_and_the_head_is_right_before_the_character_we_are_searching_for_and_the_count_is_nil_then_the_count_becomes_2_so_that_the_head_can_move_using_t() {
        let text = "we gonna use the same sentence to do 💩️💩️💩️ several tests with different LastLeftRightSearch params"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 102,
            caretLocation: 2,
            selectedLength: 8,
            selectedText: " gonna u",
            fullyVisibleArea: 0..<102,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 102,
                number: 1,
                start: 0,
                end: 102
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 2
        AccessibilityStrategyVisualMode.head = 9
        
        let returnedElement = applyMoveBeingTested(times: nil, lastLeftRightSearch: LeftRightSearch(motion: .t, character: "s"), on: element)

        XCTAssertEqual(returnedElement.caretLocation, 2)
        XCTAssertEqual(returnedElement.selectedLength, 15)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_lastLeftRightSearch_is_t_and_the_head_is_right_before_the_character_we_are_searching_for_and_the_count_is_1_then_the_count_becomes_2_so_that_the_head_can_move_using_t() {
        let text = "we gonna use the same sentence to do 💩️💩️💩️ several tests with different LastLeftRightSearch params"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 102,
            caretLocation: 2,
            selectedLength: 8,
            selectedText: " gonna u",
            fullyVisibleArea: 0..<102,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 102,
                number: 1,
                start: 0,
                end: 102
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 2
        AccessibilityStrategyVisualMode.head = 9
        
        let returnedElement = applyMoveBeingTested(times: 1, lastLeftRightSearch: LeftRightSearch(motion: .t, character: "s"), on: element)

        XCTAssertEqual(returnedElement.caretLocation, 2)
        XCTAssertEqual(returnedElement.selectedLength, 15)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
