@testable import AccessibilityStrategy
import XCTest

// reminder: in VM we don't test those motions independently because they all call the wOrDMotionForward/Backward
// so it is NOT tested that we call the wOrD funcs properly, including pass the count. this is hard to fuck up
// (with Swift strict check and protocols) but it's good to be aware of it. testing each move independently would be great
// but it's a LOT of (quite unnecessary) work.

// this is used by VMC w, W, e, E.
// they all call their own TextEngine func but the VM part of testing the Anchor, Head, and set
// the caretLocation, selectedLength and selectedText are the same, hence the wordMotionForward function.
class ASUT_VM_wOrDMotionForward_Tests: ASUT_VM_BaseTests {

    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement, using wordMotionForwardFunction: (Int) -> Int?) -> AccessibilityTextElement {
        return asVisualMode.wOrDMotionForward(times: count, on: element, using: wordMotionForwardFunction)
    }
    
}


// count
extension ASUT_VM_wOrDMotionForward_Tests {
    
    func test_that_it_implements_the_count_system_for_when_the_Head_is_after_or_equal_to_the_Anchor() {
        let text = "gonna start with text moves in Visual Mode"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 2,
            selectedLength: 6,
            selectedText: "nna st",
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 2
        AccessibilityStrategyVisualMode.head = 7
        
        let returnedElement = applyMoveBeingTested(times: 5, on: element, using: element.fileText.beginningOfWordForward)
        
        XCTAssertEqual(returnedElement.caretLocation, 2)
        XCTAssertEqual(returnedElement.selectedLength, 30)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_it_implements_the_count_system_for_when_the_Head_is_before_the_Anchor() {
        let text = "gonna start with text moves in Visual Mode"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 2,
            selectedLength: 6,
            selectedText: "nna st",
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 7
        AccessibilityStrategyVisualMode.head = 2
        
        let returnedElement = applyMoveBeingTested(times: 6, on: element, using: element.fileText.endOfWordForward)
        
        XCTAssertEqual(returnedElement.caretLocation, 7)
        XCTAssertEqual(returnedElement.selectedLength, 23)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_count_is_too_high_it_selects_until_the_end_of_the_text() {
        let text = """
long ass text there
and if the count is too high
then something magical
will happen
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 83,
            caretLocation: 53,
            selectedLength: 1,
            selectedText: " ",
            fullyVisibleArea: 0..<83,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 83,
                number: 3,
                start: 49,
                end: 72
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 53
        AccessibilityStrategyVisualMode.head = 53
        
        let returnedElement = applyMoveBeingTested(times: 69, on: element, using: element.fileText.endOfWordBackward)
        
        XCTAssertEqual(returnedElement.caretLocation, 53)
        XCTAssertEqual(returnedElement.selectedLength, 30)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// Both
extension ASUT_VM_wOrDMotionForward_Tests {
    
    func test_that_if_the_head_is_after_the_anchor_it_extends_the_selected_length_to_the_new_head_location_related_to_the_word_motion_move() {
        let text = "gonna start with text moves in Visual Mode"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 14,
            selectedLength: 9,
            selectedText: "th text m",
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 14
        AccessibilityStrategyVisualMode.head = 22
        
        let returnedElement = applyMoveBeingTested(on: element, using: element.fileText.beginningOfWordForward)
        
        XCTAssertEqual(returnedElement.caretLocation, 14)
        XCTAssertEqual(returnedElement.selectedLength, 15)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_head_is_before_the_anchor_it_reduces_the_selected_length_to_the_new_head_location_related_to_the_word_motion_move() {
        let text = "applyMove(on: element, using: element.fileText.beginningOfWORDForward)"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 64,
            caretLocation: 3,
            selectedLength: 8,
            selectedText: "lyMove(o",
            fullyVisibleArea: 0..<64,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 64,
                number: 1,
                start: 0,
                end: 64
            )!
        )

        AccessibilityStrategyVisualMode.anchor = 10
        AccessibilityStrategyVisualMode.head = 3

        let returnedElement = applyMoveBeingTested(on: element, using: element.fileText.beginningOfWORDForward)

        XCTAssertEqual(returnedElement.caretLocation, 10)
        XCTAssertEqual(returnedElement.selectedLength, 5)
        XCTAssertNil(returnedElement.selectedText)
    }

    func test_that_if_the_head_and_the_anchor_are_equal_it_does_not_get_blocked() {
        let text = "the first time we tried those moves we had some problems :D"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 59,
            caretLocation: 26,
            selectedLength: 1,
            selectedText: "o",
            fullyVisibleArea: 0..<59,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 59,
                number: 1,
                start: 0,
                end: 59
            )!
        )

        AccessibilityStrategyVisualMode.anchor = 26
        AccessibilityStrategyVisualMode.head = 26

        let returnedElement = applyMoveBeingTested(on: element, using: element.fileText.endOfWordForward)

        XCTAssertEqual(returnedElement.caretLocation, 26)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }

}


// emojis
extension ASUT_VM_wOrDMotionForward_Tests {

    func test_that_it_handles_emojis_when_head_and_anchor_are_the_same() {
        let text = "because ☀️urrently 🤖️t-seems it does"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 37,
            caretLocation: 19,
            selectedLength: 3,
            selectedText: "🤖️",
            fullyVisibleArea: 0..<37,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 37,
                number: 1,
                start: 0,
                end: 37
            )!
        )

        AccessibilityStrategyVisualMode.anchor = 19
        AccessibilityStrategyVisualMode.head = 19

        let returnedElement = applyMoveBeingTested(on: element, using: element.fileText.endOfWORDForward)

        XCTAssertEqual(returnedElement.caretLocation, 19)
        XCTAssertEqual(returnedElement.selectedLength, 10)
        XCTAssertNil(returnedElement.selectedText)
    }

    func test_that_it_handles_emojis_when_the_head_is_before_the_anchor_and_will_stay_before_even_after_the_move_is_done() {
        let text = "because ☀️urrently 🤖️t seems it does"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 37,
            caretLocation: 8,
            selectedLength: 14,
            selectedText: "☀️urrently 🤖️",
            fullyVisibleArea: 0..<37,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 37,
                number: 1,
                start: 0,
                end: 37
            )!
        )

        AccessibilityStrategyVisualMode.anchor = 19
        AccessibilityStrategyVisualMode.head = 8

        let returnedElement = applyMoveBeingTested(on: element, using: element.fileText.beginningOfWordForward)

        XCTAssertEqual(returnedElement.caretLocation, 10)
        XCTAssertEqual(returnedElement.selectedLength, 12)
        XCTAssertNil(returnedElement.selectedText)
    }

    func test_that_it_handles_emojis_when_the_head_is_before_the_anchor_and_goes_after_the_anchor_after_the_move_is_done() {
        let text = "because ☀️🤖️🤖️🤖️🤖️🤖️🤖️ t seems it does"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 44,
            caretLocation: 8,
            selectedLength: 11,
            selectedText: "☀️🤖️🤖️🤖️",
            fullyVisibleArea: 0..<44,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 1,
                start: 0,
                end: 44
            )!
        )

        AccessibilityStrategyVisualMode.anchor = 16
        AccessibilityStrategyVisualMode.head = 8

        let returnedElement = applyMoveBeingTested(on: element, using: element.fileText.beginningOfWORDForward)

        XCTAssertEqual(returnedElement.caretLocation, 16)
        XCTAssertEqual(returnedElement.selectedLength, 14)
        XCTAssertNil(returnedElement.selectedText)
    }

    func test_that_it_handles_emojis_by_not_getting_stuck_in_front_of_them_sacrebleu() {
        let text = "because🤖️🤖️🤖️🤖️🤖️🤖️ t seems it does"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 41,
            caretLocation: 4,
            selectedLength: 2,
            selectedText: "se",
            fullyVisibleArea: 0..<41,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 41,
                number: 1,
                start: 0,
                end: 41
            )!
        )

        AccessibilityStrategyVisualMode.anchor = 4
        AccessibilityStrategyVisualMode.head = 5

        let returnedElement = applyMoveBeingTested(on: element, using: element.fileText.endOfWORDForward)

        XCTAssertEqual(returnedElement.caretLocation, 4)
        XCTAssertEqual(returnedElement.selectedLength, 21)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
