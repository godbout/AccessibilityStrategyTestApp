import XCTest
import AccessibilityStrategy


class ASUT_VMC_gg_Tests: ASVM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asVisualMode.ggForVisualStyleCharacterwise(on: element)
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

        XCTAssertEqual(returnedElement?.caretLocation, 1)
        XCTAssertEqual(returnedElement?.selectedLength, 8)
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

        XCTAssertEqual(returnedElement?.caretLocation, 4)
        XCTAssertEqual(returnedElement?.selectedLength, 43)
    }
    
}
