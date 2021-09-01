@testable import AccessibilityStrategy
import XCTest


class ASVM_AnchorAndHead_Tests: ASVM_BaseTests {}


// both
// TODO: test to move to KVE
//extension ASVM_AnchorAndHead_Tests {
//    
//    func test_that_anchor_and_head_get_reset_when_entering_NormalMode() {
//        AccessibilityStrategyVisualMode.anchor = 69
//        // head = 69 haha
//        AccessibilityStrategyVisualMode.head = 69
//        
//        KindaVimEngine.shared.enterNormalMode()
//        
//        XCTAssertNil(AccessibilityStrategyVisualMode.anchor)
//        XCTAssertNil(AccessibilityStrategyVisualMode.head)
//    }
//    
//}


// head
extension ASVM_AnchorAndHead_Tests {
    
    func test_that_when_setting_the_selected_length_the_head_gets_updated() {
        let text = "hello"
        var element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 5,
            caretLocation: 0,
            selectedLength: 1,
            selectedText: "h",
            currentLine: AccessibilityTextElementLine(
                fullValue: text,
                number: 1,
                start: 0,
                end: 5
            )
        )

        AccessibilityStrategyVisualMode.anchor = 0
        AccessibilityStrategyVisualMode.head = 69
        
        element.selectedLength = 3
        
        XCTAssertNotEqual(AccessibilityStrategyVisualMode.head, 69)
    }
    
    func test_that_when_the_caret_location_goes_before_the_anchor_then_the_head_becomes_the_caret_location() {
        let text = """
another long shit
for testing the anchor
and head
"""
        var element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 49,
            caretLocation: 27,
            selectedLength: 1,
            selectedText: "n",
            currentLine: AccessibilityTextElementLine(
                fullValue: text,
                number: 2,
                start: 18,
                end: 41
            )
        )
        
        AccessibilityStrategyVisualMode.anchor = 30
        AccessibilityStrategyVisualMode.head = 37
        
        element.caretLocation = 26
        element.selectedLength = 4
        
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 26)    
    }
    
    func test_that_when_the_caret_location_goes_after_the_anchor_then_the_head_becomes_the_caret_location_plus_the_selected_length_minus_1_lol() {
        let text = """
another long shit
for testing the anchor
and head
"""
        var element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 49,
            caretLocation: 27,
            selectedLength: 1,
            selectedText: "n",
            currentLine: AccessibilityTextElementLine(
                fullValue: text,
                number: 2,
                start: 18,
                end: 41
            )
        )
        
        AccessibilityStrategyVisualMode.anchor = 20
        AccessibilityStrategyVisualMode.head = 25
        
        element.caretLocation = 28
        element.selectedLength = 4
        
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 31)    
    }
    
}

