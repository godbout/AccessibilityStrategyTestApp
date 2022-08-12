@testable import AccessibilityStrategy
import XCTest
import Common


// see AnchorBeforeHead for blah blah
class ASUT_VM_innerBlock_HeadBeforeAnchor_Tests: ASUT_VM_BaseTests {

    private func applyMoveBeingTested(using openingBlock: OpeningBlockType, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: .auto)
        
        return applyMoveBeingTested(using: openingBlock, on: element, &state)
    }
        
    private func applyMoveBeingTested(using openingBlock: OpeningBlockType, on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asVisualMode.innerBlock(using: openingBlock, on: element, &vimEngineState)
    }
    
}


extension ASUT_VM_innerBlock_HeadBeforeAnchor_Tests {
    
    func test_that_for_Head_before_Anchor_if_the_Head_is_before_the_openingBlock_and_the_Anchor_is_also_before_the_openingBlock_then_it_selects_the_innerBlock_and_repositions_the_Anchor_and_Head_properly() {
        let text = "this is (some block) hehe"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 25,
            caretLocation: 1,
            selectedLength: 5,
            selectedText: """
        his i
        """,
            fullyVisibleArea: 0..<25,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 25,
                number: 1,
                start: 0,
                end: 25
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 5
        AccessibilityStrategyVisualMode.head = 1
        
        let returnedElement = applyMoveBeingTested(using: .leftParenthesis, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 10)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 9)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 18)
    }
    
    func test_that_for_Head_before_Anchor_if_the_Head_is_before_the_openingBlock_and_the_Anchor_is_within_the_innerBlock_but_not_at_the_upperBound_then_it_selects_the_innerBlock_and_repositions_the_Anchor_and_Head_properly() {
        let text = "this is {some block} hehe"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 25,
            caretLocation: 3,
            selectedLength: 14,
            selectedText: """
        s is (some blo
        """,
            fullyVisibleArea: 0..<25,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 25,
                number: 1,
                start: 0,
                end: 25
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 16
        AccessibilityStrategyVisualMode.head = 3
        
        let returnedElement = applyMoveBeingTested(using: .leftBrace, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 10)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 9)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 18)
    }
    
    func test_that_for_Head_before_Anchor_if_the_Head_is_before_the_openingBlock_and_the_Anchor_is_at_the_innerBlock_upperBound_then_it_Bips_and_does_not_move_and_does_not_reposition_the_Anchor_and_Head() {
        let text = "this is [some block] hehe"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 25,
            caretLocation: 3,
            selectedLength: 16,
            selectedText: """
        s is (some block
        """,
            fullyVisibleArea: 0..<25,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 25,
                number: 1,
                start: 0,
                end: 25
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 18
        AccessibilityStrategyVisualMode.head = 3
        
        var state = VimEngineState(lastMoveBipped: false)
        let returnedElement = applyMoveBeingTested(using: .leftBracket, on: element, &state)
        
        XCTAssertTrue(state.lastMoveBipped)
        XCTAssertEqual(returnedElement.caretLocation, 3)
        XCTAssertEqual(returnedElement.selectedLength, 16)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 18)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 3)
    }
    
    func test_that_for_Head_before_Anchor_if_the_Head_is_before_the_openingBlock_and_the_Anchor_is_after_the_innerBlock_then_it_Bips_and_does_not_move_and_does_not_reposition_the_Anchor_and_Head() {
        let text = "this is [some block] hehe"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 25,
            caretLocation: 3,
            selectedLength: 20,
            selectedText: """
        s is [some block] he
        """,
            fullyVisibleArea: 0..<25,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 25,
                number: 1,
                start: 0,
                end: 25
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 22
        AccessibilityStrategyVisualMode.head = 3
        
        var state = VimEngineState(lastMoveBipped: false)
        let returnedElement = applyMoveBeingTested(using: .leftBracket, on: element, &state)
        
        XCTAssertTrue(state.lastMoveBipped)
        XCTAssertEqual(returnedElement.caretLocation, 3)
        XCTAssertEqual(returnedElement.selectedLength, 20)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 22)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 3)
    }
    
    func test_that_for_Head_before_Anchor_if_the_Head_is_within_innerBlock_at_the_lowerBound_and_the_Anchor_is_within_the_innerBlock_but_not_at_the_upperBound_then_it_selects_the_innerBlock_and_repositions_the_Anchor_and_Head_properly() {
        let text = "this is [some block] hehe"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 25,
            caretLocation: 9,
            selectedLength: 7,
            selectedText: """
        some bl
        """,
            fullyVisibleArea: 0..<25,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 25,
                number: 1,
                start: 0,
                end: 25
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 15
        AccessibilityStrategyVisualMode.head = 9
        
        let returnedElement = applyMoveBeingTested(using: .leftBracket, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 10)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 9)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 18)
    }
    
    func test_that_for_Head_before_Anchor_if_the_Head_is_at_the_innerBlock_lowerBound_and_the_Anchor_is_at_the_innerBlock_upperBound_then_it_Bips_and_does_not_move_and_does_not_reposition_the_Anchor_and_Head() {
        let text = "this is [some block] hehe"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 25,
            caretLocation: 9,
            selectedLength: 10,
            selectedText: """
        some block
        """,
            fullyVisibleArea: 0..<25,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 25,
                number: 1,
                start: 0,
                end: 25
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 18
        AccessibilityStrategyVisualMode.head = 9
        
        var state = VimEngineState(lastMoveBipped: false)
        let returnedElement = applyMoveBeingTested(using: .leftBracket, on: element, &state)
        
        XCTAssertTrue(state.lastMoveBipped)
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 10)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 18)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 9)
    }
    
    func test_that_for_Head_before_Anchor_if_the_Head_is_at_the_innerBlock_lowerBound_and_the_Anchor_is_after_the_innerBlock_upperBound_then_it_Bips_and_does_not_move_and_does_not_reposition_the_Anchor_and_Head() {
        let text = "this is (some block) hehe"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 25,
            caretLocation: 9,
            selectedLength: 14,
            selectedText: """
        some block) he
        """,
            fullyVisibleArea: 0..<25,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 25,
                number: 1,
                start: 0,
                end: 25
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 22
        AccessibilityStrategyVisualMode.head = 9
        
        var state = VimEngineState(lastMoveBipped: false)
        let returnedElement = applyMoveBeingTested(using: .leftParenthesis, on: element, &state)
        
        XCTAssertTrue(state.lastMoveBipped)
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 14)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 22)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 9)
    }

    func test_that_for_Head_before_Anchor_if_the_Head_is_within_the_innerBlock_but_not_at_the_lowerbound_and_the_Anchor_is_within_the_innerBlock_but_not_at_the_upperBound_then_it_selects_the_innerBlock_and_repositions_the_Anchor_and_Head_properly() {
        let text = "this is (some block) hehe"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 25,
            caretLocation: 11,
            selectedLength: 5,
            selectedText: """
        me bl
        """,
            fullyVisibleArea: 0..<25,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 25,
                number: 1,
                start: 0,
                end: 25
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 15
        AccessibilityStrategyVisualMode.head = 11
        
        let returnedElement = applyMoveBeingTested(using: .leftParenthesis, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 10)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 9)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 18)
    }
    
    func test_that_for_Head_before_Anchor_if_the_Head_is_within_the_innerBlock_but_not_at_the_lowerbound_and_the_Anchor_is_within_the_innerBlock_at_the_upperBound_then_it_selects_the_innerBlock_and_repositions_the_Anchor_and_Head_properly() {
        let text = "this is (some block) hehe"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 25,
            caretLocation: 12,
            selectedLength: 7,
            selectedText: """
        e block
        """,
            fullyVisibleArea: 0..<25,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 25,
                number: 1,
                start: 0,
                end: 25
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 18
        AccessibilityStrategyVisualMode.head = 12
        
        let returnedElement = applyMoveBeingTested(using: .leftParenthesis, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 10)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 9)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 18)
    }
    
    func test_that_for_Head_before_Anchor_if_the_Head_is_within_the_innerBlock_but_not_at_the_lowerbound_and_the_Anchor_is_after_the_innerBlock_then_it_selects_the_innerBlock_and_repositions_the_Anchor_and_Head_properly() {
        let text = "this is (some block) hehe"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 25,
            caretLocation: 15,
            selectedLength: 9,
            selectedText: """
        lock) heh
        """,
            fullyVisibleArea: 0..<25,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 25,
                number: 1,
                start: 0,
                end: 25
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 23
        AccessibilityStrategyVisualMode.head = 15
        
        let returnedElement = applyMoveBeingTested(using: .leftParenthesis, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 10)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 9)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 18)
    }
    
    func test_that_for_Head_before_Anchor_if_the_Head_is_within_the_innerBlock_at_the_upperBound_and_the_Anchor_is_after_the_innerBlock_then_it_selects_the_innerBlock_and_repositions_the_Anchor_and_Head_properly() {
        let text = "this is (some block) hehe"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 25,
            caretLocation: 18,
            selectedLength: 6,
            selectedText: """
        k) heh
        """,
            fullyVisibleArea: 0..<25,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 25,
                number: 1,
                start: 0,
                end: 25
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 24
        AccessibilityStrategyVisualMode.head = 18
        
        let returnedElement = applyMoveBeingTested(using: .leftParenthesis, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 10)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 9)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 18)
    }
    
}
