import XCTest
@testable import AccessibilityStrategy


class ASUT_VML_k_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asVisualMode.kForVisualStyleLinewise(times: count, on: element)
    }

}


// count
extension ASUT_VML_k_Tests {
    
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
        XCTAssertEqual(returnedElement.selectedLength, 62)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 0)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 61)
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
        
        let returnedElement = applyMoveBeingTested(times: 4, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 22)
        XCTAssertEqual(returnedElement.selectedLength, 68)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 89)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 22)
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
                
        AccessibilityStrategyVisualMode.anchor = 62
        AccessibilityStrategyVisualMode.head = 137
        
        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 90)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 89)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 0)
    }
    
}


// TextFields
// see j for bla blah


// see gj for blah blah
//
// TextViews
extension ASUT_VML_k_Tests {

    func test_that_if_the_head_is_before_the_anchor_then_it_extends_the_selection_by_one_line_above_at_a_time() {
        let text = """
so pressing k if the head
is before the anchor will
extend the selection to
the line above nice
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 95,
            caretLocation: 76,
            selectedLength: 19,
            selectedText: "the line above nice",
            fullyVisibleArea: 0..<95,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 95,
                number: 9,
                start: 76,
                end: 85
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 94
        AccessibilityStrategyVisualMode.head = 76
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 52)
        XCTAssertEqual(returnedElement.selectedLength, 43)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 94)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 52)

    }
    
    func test_that_if_the_head_is_after_the_anchor_then_it_reduces_the_selection_by_one_line_above_at_a_time() {
        let text = """
so pressing k if the head
is after the anchor will
reduce the selection to
the line above nice
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 94,
            caretLocation: 0,
            selectedLength: 94,
            selectedText: """
so pressing k if the head
is after the anchor will
reduce the selection to
the line above nice
""",
            fullyVisibleArea: 0..<94,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 94,
                number: 1,
                start: 0,
                end: 12
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 0
        AccessibilityStrategyVisualMode.head = 93
    
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 75)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 0)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 74)
    }
    
    func test_that_if_the_caret_is_at_the_last_character_of_the_TextElement_and_on_an_EmptyLine_it_does_not_get_stuck_when_trying_to_move_up_and_selects_the_line_above() {
        let text = """
we gonna place the
caret at the last empty line

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 48,
            caretLocation: 48,
            selectedLength: 0,
            selectedText: "",
            fullyVisibleArea: 0..<48,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 48,
                number: 6,
                start: 48,
                end: 48
            )!
        )
        
        AccessibilityStrategyVisualMode.head = 48
        AccessibilityStrategyVisualMode.anchor = 48
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 19)
        XCTAssertEqual(returnedElement.selectedLength, 29)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 47)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 19)
    }
    
}


// special for this move:
// the Anchor has to be updated once the Head goes above it
// because through the V when entering NM, the Anchor will be at the beginning of a line
// but once the Head passes above it should be at the end of the line.
extension ASUT_VML_k_Tests {
   
    func test_that_the_Anchor_is_getting_updated_to_the_end_of_the_line_rather_than_the_start_when_the_Head_passes_above_it() {
        let text = """
this is a case that showed up
only because of ip else i guess
we would have never known
but who knows right
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 107,
            caretLocation: 62,
            selectedLength: 26,
            selectedText: """
        we would have never known

        """,
            fullyVisibleArea: 0..<107,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 107,
                number: 3,
                start: 62,
                end: 88
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 62
        AccessibilityStrategyVisualMode.head = 87
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 30)
        XCTAssertEqual(returnedElement.selectedLength, 58)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 87)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 30)
    }
    
}
