import XCTest
import AccessibilityStrategy
import Common


class ASUT_VML___Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int? = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let state = VimEngineState(visualStyle: .linewise)
        
        return asVisualMode.underscore(times: count, on: element, state)
    }
   
}


// count
extension ASUT_VML___Tests {
    
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
            length: 142,
            caretLocation: 22,
            selectedLength: 40,
            selectedText: """
to test that move on
multiline and this
""",
            fullyVisibleArea: 0..<142,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 142,
                number: 2,
                start: 22,
                end: 43
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 22
        AccessibilityStrategyVisualMode.head = 61
        
        let returnedElement = applyMoveBeingTested(times: 3, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 22)
        XCTAssertEqual(returnedElement.selectedLength, 91)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 22)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 112)
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
            caretLocation: 22,
            selectedLength: 91,
            selectedText: """
to test that move on
multiline and this
is something for VisualMode
so it's probably gonna
""",
            fullyVisibleArea: 0..<138,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 138,
                number: 2,
                start: 22,
                end: 43
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 112
        AccessibilityStrategyVisualMode.head = 22
        
        let returnedElement = applyMoveBeingTested(times: 4, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 90)
        XCTAssertEqual(returnedElement.selectedLength, 23)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 90)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 112)
    }
    
    func test_that_if_the_count_is_too_high_it_selects_until_the_end_of_the_text() {
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
            caretLocation: 22,
            selectedLength: 40,
            selectedText: """
to test that move on
multiline and this
""",
            fullyVisibleArea: 0..<138,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 138,
                number: 2,
                start: 22,
                end: 43
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 61
        AccessibilityStrategyVisualMode.head = 23
        
        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 43)
        XCTAssertEqual(returnedElement.selectedLength, 95)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 43)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 137)
    }
    
}


// Both
extension ASUT_VML___Tests {
    
    func test_that_if_only_one_line_is_selected_then_it_keeps_the_selection_because_without_a_count_it_does_nothing_in_Linewise() {
        let text = "        so here we gonna test VG"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 32,
            caretLocation: 0,
            selectedLength: 32,
            selectedText: "        so here we gonna test VG",
            fullyVisibleArea: 0..<32,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 32,
                number: 1,
                start: 0,
                end: 32
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 0
        AccessibilityStrategyVisualMode.head = 31

        let accessibilityElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(accessibilityElement.caretLocation, 0)
        XCTAssertEqual(accessibilityElement.selectedLength, 32)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 0)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 31)
    }
    
}


// TextViews
extension ASUT_VML___Tests {

    func test_that_if_several_lines_are_selected_then_it_keeps_the_selection_because_without_a_count_it_does_nothing_in_Linewise() {
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
            caretLocation: 21,
            selectedLength: 49,
            selectedText: """
😂️ be a longer one
and we're gonna
select until
""",
            fullyVisibleArea: 0..<77,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 77,
                number: 2,
                start: 21,
                end: 41
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 21
        AccessibilityStrategyVisualMode.head = 69

        let accessibilityElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(accessibilityElement.caretLocation, 21)
        XCTAssertEqual(accessibilityElement.selectedLength, 49)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 21)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 69)
    }
   
}
