import XCTest
import AccessibilityStrategy
import Common


class ASUT_VML_gg_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int? = nil, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let state = VimEngineState(visualStyle: .linewise)
                
        return asVisualMode.gg(times: count, on: element, state)
    }

}


// count
extension ASUT_VML_gg_Tests {
    
    func test_it_implements_the_count_system_for_when_the_newHead_is_after_or_equal_to_the_Anchor() {
        let text = """
ok so now we're going
to test that move on
multiline and this
is something for VisualMode
so it's probably gonna
select some stuff and all
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 138,
            caretLocation: 0,
            selectedLength: 113,
            selectedText: """
ok so now we're going
to test that move on
multiline and this
is something for VisualMode
so it's probably gonna
""",
            fullyVisibleArea: 0..<138,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 138,
                number: 1,
                start: 0,
                end: 22
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 0
        AccessibilityStrategyVisualMode.head = 112
        
        let returnedElement = applyMoveBeingTested(times: 2, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 43)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 0)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 42)
    }
        
    func test_that_it_implements_the_count_system_for_when_the_newHead_is_before_the_Anchor() {
        let text = """
ok so now we're going
to test that move on
multiline and this
is something for VisualMode
so it's probably gonna
select some stuff and all
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 138,
            caretLocation: 62,
            selectedLength: 76,
            selectedText: """
is something for VisualMode
so it's probably gonna
select some stuff and all
""",
            fullyVisibleArea: 0..<138,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 138,
                number: 4,
                start: 62,
                end: 90
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 62
        AccessibilityStrategyVisualMode.head = 137
        
        let returnedElement = applyMoveBeingTested(times: 3, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 43)
        XCTAssertEqual(returnedElement.selectedLength, 47)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 89)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 43)
    }
    
    func test_that_if_the_count_is_nil_it_selects_until_the_beginning_of_the_text() {
        let text = """
ok so now we're going
to test that move on
multiline and this
is something for VisualMode
so it's probably gonna
select some stuff and all
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 138,
            caretLocation: 62,
            selectedLength: 76,
            selectedText: """
is something for VisualMode
so it's probably gonna
select some stuff and all
""",
            fullyVisibleArea: 0..<138,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 138,
                number: 4,
                start: 62,
                end: 90
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 62
        AccessibilityStrategyVisualMode.head = 137
        
        let returnedElement = applyMoveBeingTested(times: nil, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 90)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 89)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 0)
    }
        
    func test_that_if_the_count_is_too_high_it_selects_until_the_beginning_of_the_text() {
        let text = """
ok so now we're going
to test that move on
multiline and this
is something for VisualMode
so it's probably gonna
select some stuff and all
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 138,
            caretLocation: 62,
            selectedLength: 76,
            selectedText: """
is something for VisualMode
so it's probably gonna
select some stuff and all
""",
            fullyVisibleArea: 0..<138,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 138,
                number: 4,
                start: 62,
                end: 90
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 137
        AccessibilityStrategyVisualMode.head = 69
        
        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 138)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 137)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 0)
    }
    
}


// Both
extension ASUT_VML_gg_Tests {
    
    func test_that_if_the_TextElement_is_just_a_single_line_then_it_keeps_the_whole_line_selected() {
        let text = "        so here we gonna test Vgg"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 33,
            caretLocation: 0,
            selectedLength: 33,
            selectedText: "        so here we gonna test Vgg",
            fullyVisibleArea: 0..<33,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 33,
                number: 1,
                start: 0,
                end: 33
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 0
        AccessibilityStrategyVisualMode.head = 32

        let accessibilityElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(accessibilityElement.caretLocation, 0)
        XCTAssertEqual(accessibilityElement.selectedLength, 33)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 0)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 32)
    }
    
}


// TextViews
extension ASUT_VML_gg_Tests {

    func test_that_if_the_head_is_after_the_line_of_the_anchor_then_it_selects_from_the_anchor_to_the_beginning_of_the_text() {
        let text = """
so now this is gonna
😂️ be a longer one
and we're gonna
select until
the end
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 77,
            caretLocation: 41,
            selectedLength: 29,
            selectedText: "and we're gonna\nselect until\n",
            fullyVisibleArea: 0..<77,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 77,
                number: 5,
                start: 41,
                end: 51
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 41
        AccessibilityStrategyVisualMode.head = 69

        let accessibilityElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(accessibilityElement.caretLocation, 0)
        XCTAssertEqual(accessibilityElement.selectedLength, 57)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 56)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 0)
    }
    
    func test_that_if_the_head_is_before_or_at_the_same_line_as_the_anchor_then_it_selects_from_the_anchor_to_the_beginning_of_the_text() {
        let text = """
so now this is gonna
😂️ be a longer one
and we're gonna
select until
the end
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 77,
            caretLocation: 41,
            selectedLength: 29,
            selectedText: "and we're gonna\nselect until\n",
            fullyVisibleArea: 0..<77,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 77,
                number: 5,
                start: 41,
                end: 51
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 69
        AccessibilityStrategyVisualMode.head = 41

        let accessibilityElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(accessibilityElement.caretLocation, 0)
        XCTAssertEqual(accessibilityElement.selectedLength, 70)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 69)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 0)
    }
    
}
