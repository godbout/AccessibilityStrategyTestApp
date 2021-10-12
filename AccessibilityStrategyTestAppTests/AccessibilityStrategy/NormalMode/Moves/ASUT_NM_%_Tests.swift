@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_percent_Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.percent(on: element) 
    }
    
}


// line
extension ASUT_NM_percent_Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen lines. it will just pass by
them like nothin🇫🇷️ happened. (that's how special) it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 121,
            caretLocation: 78,
            selectedLength: 5,
            selectedText: "🇫🇷️",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 121,
                number: 9,
                start: 72,
                end: 84
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 113)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
     
}


// Both
extension ASUT_NM_percent_Tests {
    
    func test_that_the_caret_does_not_move_if_it_cannot_find_an_item_to_pair() {
        let text = "no item to pair on this line"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 28,
            caretLocation: 4,
            selectedLength: 1,
            selectedText: "t",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 28,
                number: 1,
                start: 0,
                end: 11
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 4)        
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }    
    
    func test_that_it_finds_the_next_item_to_match_and_goes_to_the_pairing_item_on_a_same_line() {
        let text = """
a line without shit to pair
and a ( nice pair line ) :))
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 56,
            caretLocation: 30,
            selectedLength: 1,
            selectedText: "d",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 56,
                number: 4,
                start: 28,
                end: 41
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 51)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_if_the_pair_cannot_be_matched_then_it_does_not_move() {
        let text = "the last { will not match } because there's { no closing"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 56,
            caretLocation: 34,
            selectedLength: 1,
            selectedText: "e",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 56,
                number: 4,
                start: 28,
                end: 36
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 34)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_it_always_works_with_brackets() {
        let text = "because by default the [ unmatched functions ] don't ] handle brackets"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 70,
            caretLocation: 14,
            selectedLength: 1,
            selectedText: "a",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 70,
                number: 2,
                start: 11,
                end: 23
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 45)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}


// TextViews
extension ASUT_NM_percent_Tests {
    
    func test_that_it_finds_the_next_item_to_match_and_goes_to_the_pairing_item_even_on_a_different_line() {
        let text = """
func someBull() {
    let var = "huhu"
}
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 40,
            caretLocation: 39,
            selectedLength: 1,
            selectedText: "}",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 40,
                number: 5,
                start: 39,
                end: 40
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 16)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}


// emojis
extension ASUT_NM_percent_Tests {
    
    func test_that_it_handles_emojis() {
        let text = """
need 🥠️🥠️to  { deal🥠️ with
those faces 🥺️☹️ } 😂️
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 53,
            caretLocation: 3,
            selectedLength: 1,
            selectedText: "d",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 53,
                number: 1,
                start: 0,
                end: 15
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 48)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
