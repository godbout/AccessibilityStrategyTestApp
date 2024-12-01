import XCTest
import AccessibilityStrategy
import Common


class ASUT_VMC_gg_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int? = nil, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let vimEngineState = VimEngineState(visualStyle: .characterwise)
        
        return asVisualMode.gg(times: count, on: element, vimEngineState)
    }
   
}


// count
extension ASUT_VMC_gg_Tests {
    
    func test_it_implements_the_count_system_for_when_the_newHead_is_after_or_equal_to_the_Anchor() {
        let text = """
so pressing gg in
Visual Mode is gonna be
cool because it will extend
   the selection
when the head is after the anchor
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 120,
            caretLocation: 7,
            selectedLength: 23,
            selectedText: """
sing gg in
Visual Mode 
""",
            fullyVisibleArea: 0..<120,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 120,
                number: 1,
                start: 0,
                end: 18
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 29
        AccessibilityStrategyVisualMode.head = 7
        
        let returnedElement = applyMoveBeingTested(times: 4, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 29)
        XCTAssertEqual(returnedElement.selectedLength, 45)
    }
        
    func test_that_it_implements_the_count_system_for_when_the_newHead_is_before_the_Anchor() {
        let text = """
so pressing gg in
Visual Mode is gonna be
cool because it will extend
the selection
when the head is after the anchor
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 117,
            caretLocation: 21,
            selectedLength: 77,
            selectedText: """
ual Mode is gonna be
cool because it will extend
the selection
when the head 
""",
            fullyVisibleArea: 0..<117,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 117,
                number: 2,
                start: 18,
                end: 42
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 97
        AccessibilityStrategyVisualMode.head = 21
        
        let returnedElement = applyMoveBeingTested(times: 2, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 18)
        XCTAssertEqual(returnedElement.selectedLength, 80)
    }
    
    func test_that_if_the_count_is_nil_it_selects_until_the_firstNonBlank_of_the_firstFileLine() {
        let text = """
   so pressing gg in
Visual Mode is gonna be
cool because it will extend
the selection
   when the head is after the anchor
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 123,
            caretLocation: 21,
            selectedLength: 38,
            selectedText: """
Visual Mode is gonna be
cool because i
""",
            fullyVisibleArea: 0..<123,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 123,
                number: 2,
                start: 21,
                end: 45
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 21
        AccessibilityStrategyVisualMode.head = 58
        
        let returnedElement = applyMoveBeingTested(times: nil, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 3)
        XCTAssertEqual(returnedElement.selectedLength, 19)
    }
        
    func test_that_if_the_count_is_too_high_it_selects_until_the_firstNonBlank_of_the_firstFileLine() {
        let text = """
   so pressing gg in
Visual Mode is gonna be
cool because it will extend
the selection
   when the head is after the anchor
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 123,
            caretLocation: 21,
            selectedLength: 38,
            selectedText: """
Visual Mode is gonna be
cool because i
""",
            fullyVisibleArea: 0..<123,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 123,
                number: 2,
                start: 21,
                end: 45
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 21
        AccessibilityStrategyVisualMode.head = 58
        
        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 3)
        XCTAssertEqual(returnedElement.selectedLength, 19)
    }
    
}


// Both
extension ASUT_VMC_gg_Tests {
    
    // see G for blah blah!
    func test_that_if_the_new_head_location_is_after_the_anchor_then_it_selects_from_the_anchor_to_the_new_head_location() {
        let text = "        so here we gonna test vgg"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 33,
            caretLocation: 1,
            selectedLength: 1,
            selectedText: " ",
            fullyVisibleArea: 0..<33,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 33,
                number: 1,
                start: 0,
                end: 33
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 1
        AccessibilityStrategyVisualMode.head = 1

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 1)
        XCTAssertEqual(returnedElement.selectedLength, 8)
    }
    
}


// TextViews
extension ASUT_VMC_gg_Tests {

    func test_that_if_the_new_head_location_is_before_the_anchor_then_it_selects_from_anchor_to_the_new_head_location() {
        let text = """
    ⛱️e gonna put the caret
way after the new head location
and it's gonna run smooooooooooooth
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 95,
            caretLocation: 46,
            selectedLength: 1,
            selectedText: "h",
            fullyVisibleArea: 0..<95,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 95,
                number: 5,
                start: 38,
                end: 51
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 46
        AccessibilityStrategyVisualMode.head = 46
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 4)
        XCTAssertEqual(returnedElement.selectedLength, 43)
    }
    
}
