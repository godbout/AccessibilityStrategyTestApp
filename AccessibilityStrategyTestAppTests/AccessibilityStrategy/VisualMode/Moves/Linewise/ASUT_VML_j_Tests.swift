import XCTest
@testable import AccessibilityStrategy


class ASUT_VML_j_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asVisualMode.jForVisualStyleLinewise(times: count, on: element)
    }

}


// count
extension ASUT_VML_j_Tests {
    
    func test_it_implements_the_count_system_for_when_the_newHead_is_after_or_equal_to_the_Anchor() {
        let text = """
so pressing j in
Visual Mode is gonna be
cool because it will extend
the selection
when the head is after the anchor
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 116,
            caretLocation: 0,
            selectedLength: 41,
            selectedText: """
so pressing j in
Visual Mode is gonna be
""",
            fullyVisibleArea: 0..<116,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 116,
                number: 1,
                start: 0,
                end: 17
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 0
        AccessibilityStrategyVisualMode.head = 40
        
        let returnedElement = applyMoveBeingTested(times: 2, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 83)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 0)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 82)
    }
        
    func test_that_it_implements_the_count_system_for_when_the_newHead_is_before_the_Anchor() {
        let text = """
so pressing j in
Visual Mode is gonna be
cool because it will extend
the selection
when the head is after the anchor
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 116,
            caretLocation: 0,
            selectedLength: 41,
            selectedText: """
so pressing j in
Visual Mode is gonna be
""",
            fullyVisibleArea: 0..<116,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 116,
                number: 1,
                start: 0,
                end: 17
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 40
        AccessibilityStrategyVisualMode.head = 0
        
        let returnedElement = applyMoveBeingTested(times: 3, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 17)
        XCTAssertEqual(returnedElement.selectedLength, 66)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 17)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 82)
    }
        
    func test_that_if_the_count_is_too_high_it_selects_until_the_end_of_the_text() {
        let text = """
so pressing j in
Visual Mode is gonna be
cool because it will extend
the selection
when the head is after the anchor
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 116,
            caretLocation: 0,
            selectedLength: 41,
            selectedText: """
so pressing j in
Visual Mode is gonna be
""",
            fullyVisibleArea: 0..<116,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 116,
                number: 1,
                start: 0,
                end: 17
            )!
        )
                
        AccessibilityStrategyVisualMode.anchor = 40
        AccessibilityStrategyVisualMode.head = 0
        
        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 17)
        XCTAssertEqual(returnedElement.selectedLength, 99)
    }
    
}


// TextFields
// Alfred style stuff is handled and tested in kVE now


// TextViews
extension ASUT_VML_j_Tests {
    
    func test_that_if_the_head_is_after_the_anchor_then_it_extends_the_selection_by_one_line_below_at_a_time() {
        let text = """
so pressing j in
Visual Mode is gonna be
cool because it will extend
the selection
when the head is after the anchor
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 116,
            caretLocation: 0,
            selectedLength: 17,
            selectedText: "so pressing j in\n",
            fullyVisibleArea: 0..<116,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 116,
                number: 1,
                start: 0,
                end: 12
            )!
        )
                
        AccessibilityStrategyVisualMode.head = 0
        AccessibilityStrategyVisualMode.anchor = 16
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 41)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 0)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 40)
    }
    
    func test_that_if_the_head_is_before_the_anchor_then_it_reduces_the_selection_by_one_line_below_at_a_time() {
        let text = """
so pressing j in
Visual Mode is gonna be
cool because it will reduce
the selection when the
head if before the anchor
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 117,
            caretLocation: 17,
            selectedLength: 100,
            selectedText: """
Visual Mode is gonna be
cool because it will reduce
the selection when the
head if before the anchor
""",
            fullyVisibleArea: 0..<117,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 117,
                number: 3,
                start: 17,
                end: 29
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 116
        AccessibilityStrategyVisualMode.head = 17
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 41)
        XCTAssertEqual(returnedElement.selectedLength, 76)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 116)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 41)
    }
    
    func test_that_it_does_not_skip_empty_lines() {
        let text = """
wow that one is

ass off lol
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 28,
            caretLocation: 0,
            selectedLength: 16,
            selectedText: "wow that one is\n",
            fullyVisibleArea: 0..<28,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 28,
                number: 1,
                start: 0,
                end: 13
            )!
        )
        
        AccessibilityStrategyVisualMode.head = 0
        AccessibilityStrategyVisualMode.anchor = 15
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 17)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 0)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 16)
    }
    
    // this is intrinsic to Linewise, Anchor/Head and the `j` move with a count of 1.
    // when only one line is highlighted and we go down with `j`, we may have to swap the Anchor and Head position. this can't be done
    // in ATE and didSet of selectedLength, because we can only know where is the Anchor and where is the Head if we know from which move
    // it's coming, in this particular case. (not even `k`, in `k` because it goes up not down, the calculations are always correct.)
    func test_that_if_the_Anchor_and_the_Head_are_on_the_same_line_and_the_Head_is_before_the_Anchor_then_the_Head_and_the_Anchor_get_swapped_and_the_move_works() {
        let text = """
so pressing j in
Visual Mode is gonna be
cool because it will reduce
the selection when the
head if before the anchor
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 117,
            caretLocation: 41,
            selectedLength: 28,
            selectedText: """
        cool because it will reduce\n
        """,
            fullyVisibleArea: 0..<117,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 117,
                number: 3,
                start: 41,
                end: 69
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 68
        AccessibilityStrategyVisualMode.head = 41
        
        _ = applyMoveBeingTested(on: element)

        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 41)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 91)
    }
    
}


// bugs found
extension ASUT_VML_j_Tests {
    
    func test_that_when_we_use_the_count_and_reverse_the_Head_and_Anchor_then_they_are_updated_correctly() {
        let text = """
it seems that moves
themselves
have to updated
Head and Anchor
and that can't be
done automatically
in the cp didSet
at least for VML
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 133,
            caretLocation: 20,
            selectedLength: 43,
            selectedText: """
        themselves
        have to updated
        Head and Anchor

        """,
            fullyVisibleArea: 0..<133,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 133,
                number: 2,
                start: 20,
                end: 31
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 62
        AccessibilityStrategyVisualMode.head = 20
        
        let returnedElement = applyMoveBeingTested(times: 5, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 47)
        XCTAssertEqual(returnedElement.selectedLength, 70)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 47)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 116)
    }
}
