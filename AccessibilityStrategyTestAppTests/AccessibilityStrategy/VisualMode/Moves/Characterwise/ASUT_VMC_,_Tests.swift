@testable import AccessibilityStrategy
import XCTest
import Common


// see NM ; for blah blah
class ASUT_VM_comma_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int? = 1, lastLeftRightSearch: LeftRightSearch, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let vimEngineState = VimEngineState(visualStyle: .characterwise)
                
        return asVisualMode.comma(times: count, lastLeftRightSearch: lastLeftRightSearch, on: element, vimEngineState)
    }
    
}


// see NM ; for blah blah
extension ASUT_VM_comma_Tests {
    
    func test_that_if_lastLeftRightSearch_is_F_it_simply_forward_parameters_to_the_f_move() {
        let text = "we gonna use the same sentence to do 💩️💩️💩️ several tests with different LastLeftRightSearch params"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 102,
            caretLocation: 7,
            selectedLength: 19,
            selectedText: "a use the same sent",
            fullyVisibleArea: 0..<102,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 102,
                number: 1,
                start: 0,
                end: 102
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 25
        AccessibilityStrategyVisualMode.head = 7
        
        let returnedElement = applyMoveBeingTested(times: 3, lastLeftRightSearch: LeftRightSearch(motion: .F, character: "a"), on: element)

        XCTAssertEqual(returnedElement.caretLocation, 25)
        XCTAssertEqual(returnedElement.selectedLength, 53)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_lastLeftRightSearch_is_f_it_simply_forward_parameters_to_the_F_move() {
        let text = "we gonna use the same sentence to do 💩️💩️💩️ several tests with different LastLeftRightSearch params"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 102,
            caretLocation: 96,
            selectedLength: 5,
            selectedText: "param",
            fullyVisibleArea: 0..<102,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 102,
                number: 1,
                start: 0,
                end: 102
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 100
        AccessibilityStrategyVisualMode.head = 96
        
        let returnedElement = applyMoveBeingTested(times: 6, lastLeftRightSearch: LeftRightSearch(motion: .f, character: "e"), on: element)

        XCTAssertEqual(returnedElement.caretLocation, 50)
        XCTAssertEqual(returnedElement.selectedLength, 51)
        XCTAssertNil(returnedElement.selectedText)
    }
        
}


// and see NM ; for blah blah
extension ASUT_VM_comma_Tests {
    
    func test_that_if_lastLeftRightSearch_is_T_and_the_head_is_right_before_the_character_we_are_searching_for_and_the_count_is_nil_then_the_count_becomes_2_so_that_the_head_can_move_using_t() {
        let text = "we gonna use the same sentence to do 💩️💩️💩️ several tests with different LastLeftRightSearch params"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 102,
            caretLocation: 6,
            selectedLength: 14,
            selectedText: "na use the sam",
            fullyVisibleArea: 0..<102,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 102,
                number: 1,
                start: 0,
                end: 102
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 6
        AccessibilityStrategyVisualMode.head = 19

        let returnedElement = applyMoveBeingTested(times: nil, lastLeftRightSearch: LeftRightSearch(motion: .T, character: "e"), on: element)

        XCTAssertEqual(returnedElement.caretLocation, 6)
        XCTAssertEqual(returnedElement.selectedLength, 17)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_lastLeftRightSearch_is_T_and_the_head_is_right_before_the_character_we_are_searching_for_and_the_count_is_1_then_the_count_becomes_2_so_that_the_head_can_move_using_t() {
        let text = "we gonna use the same sentence to do 💩️💩️💩️ several tests with different LastLeftRightSearch params"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 102,
            caretLocation: 6,
            selectedLength: 14,
            selectedText: "na use the sam",
            fullyVisibleArea: 0..<102,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 102,
                number: 1,
                start: 0,
                end: 102
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 6
        AccessibilityStrategyVisualMode.head = 19

        let returnedElement = applyMoveBeingTested(times: 1, lastLeftRightSearch: LeftRightSearch(motion: .T, character: "e"), on: element)

        XCTAssertEqual(returnedElement.caretLocation, 6)
        XCTAssertEqual(returnedElement.selectedLength, 17)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_lastLeftRightSearch_is_t_and_the_head_is_right_after_the_character_we_are_searching_for_and_the_count_is_nil_then_the_count_becomes_2_so_that_the_head_can_move_using_T() {
        let text = "we gonna use the same sentence to do 💩️💩️💩️ several tests with different LastLeftRightSearch params"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 102,
            caretLocation: 69,
            selectedLength: 11,
            selectedText: "ferent Last",
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
        AccessibilityStrategyVisualMode.head = 79
        
        let returnedElement = applyMoveBeingTested(times: nil, lastLeftRightSearch: LeftRightSearch(motion: .t, character: "s"), on: element)

        XCTAssertEqual(returnedElement.caretLocation, 60)
        XCTAssertEqual(returnedElement.selectedLength, 10)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_lastLeftRightSearch_is_t_and_the_head_is_right_after_the_character_we_are_searching_for_and_the_count_is_1_then_the_count_becomes_2_so_that_the_head_can_move_using_T() {
        let text = "we gonna use the same sentence to do 💩️💩️💩️ several tests with different LastLeftRightSearch params"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 102,
            caretLocation: 69,
            selectedLength: 11,
            selectedText: "ferent Last",
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
        AccessibilityStrategyVisualMode.head = 79
        
        let returnedElement = applyMoveBeingTested(times: 1, lastLeftRightSearch: LeftRightSearch(motion: .t, character: "s"), on: element)

        XCTAssertEqual(returnedElement.caretLocation, 60)
        XCTAssertEqual(returnedElement.selectedLength, 10)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
