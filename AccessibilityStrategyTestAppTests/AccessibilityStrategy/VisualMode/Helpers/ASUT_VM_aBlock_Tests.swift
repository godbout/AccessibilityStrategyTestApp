@testable import AccessibilityStrategy
import XCTest
import Common


// see innerBlock for blah blah
class ASUT_VM_aBlock_Tests: ASUT_VM_BaseTests {

    private func applyMoveBeingTested(using openingBlock: OpeningBlockType, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: .auto)
        
        return applyMoveBeingTested(using: openingBlock, on: element, &vimEngineState)
    }
        
    private func applyMoveBeingTested(using openingBlock: OpeningBlockType, on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asVisualMode.aBlock(using: openingBlock, on: element, &vimEngineState)
    }
    
}

// Bip
// see innerBlock for blah blah
extension ASUT_VM_aBlock_Tests {

    func test_that_if_the_selectionStart_is_at_the_aBlock_lowerBound_and_the_selectionEnd_is_within_the_aBlock_but_not_at_the_upperBound_then_it_Bips_and_does_not_move_and_does_not_reposition_the_Anchor_and_Head() {
        let text = "this is [some block] hehe"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 25,
            caretLocation: 8,
            selectedLength: 7,
            selectedText: """
        [some b
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
        
        AccessibilityStrategyVisualMode.anchor = 8
        AccessibilityStrategyVisualMode.head = 14
        
        var vimEngineState = VimEngineState(lastMoveBipped: false)
        let returnedElement = applyMoveBeingTested(using: .leftBracket, on: element, &vimEngineState)
        
        XCTAssertTrue(vimEngineState.lastMoveBipped)
        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 7)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 8)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 14)
    }
       
    func test_that_if_the_selectionStart_is_at_the_aBlock_lowerBound_and_the_selectionEnd_is_at_the_aBlock_upperBound_then_it_Bips_and_does_not_move_and_does_not_reposition_the_Anchor_and_Head() {
        let text = "this is [some block] hehe"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 25,
            caretLocation: 8,
            selectedLength: 12,
            selectedText: """
        [some block]
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
        
        AccessibilityStrategyVisualMode.anchor = 8
        AccessibilityStrategyVisualMode.head = 20
        
        var vimEngineState = VimEngineState(lastMoveBipped: false)
        let returnedElement = applyMoveBeingTested(using: .leftBracket, on: element, &vimEngineState)
        
        XCTAssertTrue(vimEngineState.lastMoveBipped)
        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 12)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 8)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 20)
    }
    
    func test_that_if_the_selectionStart_is_at_the_aBlock_lowerBound_and_the_selectionEnd_is_after_the_aBlock_upperBound_then_it_Bips_and_does_not_move_and_does_not_reposition_the_Anchor_and_Head() {
        let text = """
this is (some blo
ck) hehe
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 27,
            caretLocation: 8,
            selectedLength: 15,
            selectedText: """
        (some blo
        ck) h
        """,
            fullyVisibleArea: 0..<27,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 27,
                number: 1,
                start: 0,
                end: 18
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 8
        AccessibilityStrategyVisualMode.head = 22
        
        var vimEngineState = VimEngineState(lastMoveBipped: false)
        let returnedElement = applyMoveBeingTested(using: .leftParenthesis, on: element, &vimEngineState)
        
        XCTAssertTrue(vimEngineState.lastMoveBipped)
        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 15)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 8)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 22)
    }
    
}


// no Bip
// TextFields and TextViews
extension ASUT_VM_aBlock_Tests {

    func test_that_if_the_selectionStart_is_before_the_openingBlock_and_the_selectionEnd_is_also_before_the_openingBlock_then_it_selects_the_aBlock_and_repositions_the_Anchor_and_Head_properly() {
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
        
        AccessibilityStrategyVisualMode.anchor = 1
        AccessibilityStrategyVisualMode.head = 5
        
        let returnedElement = applyMoveBeingTested(using: .leftParenthesis, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 12)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 8)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 19)
    }
    
    func test_that_if_the_selectionStart_is_before_the_openingBlock_and_the_selectionEnd_is_within_the_aBlock_but_not_at_the_upperBound_then_it_selects_the_aBlock_and_repositions_the_Anchor_and_Head_properly() {
        let text = "this is {some block} hehe"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 25,
            caretLocation: 3,
            selectedLength: 14,
            selectedText: """
        s is {some blo
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
        
        AccessibilityStrategyVisualMode.anchor = 3
        AccessibilityStrategyVisualMode.head = 16
        
        let returnedElement = applyMoveBeingTested(using: .leftBrace, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 12)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 8)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 19)
    }
    
    func test_that_if_the_selectionStart_is_before_the_openingBlock_and_the_selectionEnd_is_at_the_aBlock_upperBound_then_it_selects_the_aBlock_and_repositions_the_Anchor_and_Head_properly() {
        let text = "this is [some block] hehe"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 25,
            caretLocation: 3,
            selectedLength: 17,
            selectedText: """
        s is [some block]
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
        
        AccessibilityStrategyVisualMode.anchor = 3
        AccessibilityStrategyVisualMode.head = 19
        
        var vimEngineState = VimEngineState(lastMoveBipped: false)
        let returnedElement = applyMoveBeingTested(using: .leftBracket, on: element, &vimEngineState)
        
        XCTAssertFalse(vimEngineState.lastMoveBipped)
        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 12)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 8)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 19)
    }
    
    func test_that_if_the_selectionStart_is_before_the_openingBlock_and_the_selectionEnd_is_after_the_aBlock_then_it_selects_the_aBlock_and_repositions_the_Anchor_and_Head_properly() {
        let text = """
this is [
    some block
] hehe
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 31,
            caretLocation: 3,
            selectedLength: 26,
            selectedText: """
        s is [
            some block
        ] he
        """,
            fullyVisibleArea: 0..<31,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 1,
                start: 0,
                end: 10
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 3
        AccessibilityStrategyVisualMode.head = 28
        
        var vimEngineState = VimEngineState(lastMoveBipped: false)
        let returnedElement = applyMoveBeingTested(using: .leftBracket, on: element, &vimEngineState)
        
        XCTAssertFalse(vimEngineState.lastMoveBipped)
        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 18)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 8)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 25)
    }
    
    
    func test_that_for_if_the_selectionStart_is_within_the_aBlock_but_not_at_the_lowerbound_and_the_selectionEnd_is_within_the_aBlock_but_not_at_the_upperBound_then_it_selects_the_aBlock_and_repositions_the_Anchor_and_Head_properly() {
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
        
        AccessibilityStrategyVisualMode.anchor = 11
        AccessibilityStrategyVisualMode.head = 15
        
        let returnedElement = applyMoveBeingTested(using: .leftParenthesis, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 12)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 8)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 19)
    }
    
    func test_that_if_the_selectionStart_is_within_the_aBlock_but_not_at_the_lowerbound_and_the_selectionEnd_is_at_the_aBlock_upperBound_then_it_selects_the_aBlock_and_repositions_the_Anchor_and_Head_properly() {
        let text = "this is (some block) hehe"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 25,
            caretLocation: 11,
            selectedLength: 9,
            selectedText: """
        me block)
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
        
        AccessibilityStrategyVisualMode.anchor = 19
        AccessibilityStrategyVisualMode.head = 11
        
        let returnedElement = applyMoveBeingTested(using: .leftParenthesis, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 12)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 8)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 19)
    }
    
    func test_that_for_if_the_selectionStart_is_within_the_aBlock_but_not_at_the_lowerbound_and_the_selectionEnd_is_after_the_aBlock_then_it_selects_the_aBlock_and_repositions_the_Anchor_and_Head_properly() {
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
        
        AccessibilityStrategyVisualMode.anchor = 15
        AccessibilityStrategyVisualMode.head = 23
        
        let returnedElement = applyMoveBeingTested(using: .leftParenthesis, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 12)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 8)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 19)
    }
    
    func test_that_if_the_selectionStart_is_at_the_aBlock_upperBound_and_the_selectionEnd_is_after_the_aBlock_then_it_selects_the_aBlock_and_repositions_the_Anchor_and_Head_properly() {
        let text = "this is (some block) hehe"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 25,
            caretLocation: 19,
            selectedLength: 3,
            selectedText: """
        ) h
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
        
        AccessibilityStrategyVisualMode.anchor = 19
        AccessibilityStrategyVisualMode.head = 21
        
        let returnedElement = applyMoveBeingTested(using: .leftParenthesis, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 12)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 8)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 19)
    }
    
    func test_on_multilines_that_in_normal_setting_it_selects_from_the_openingBlock_to_the_closingBlock_and_does_not_Bip() {
        let text = """
this case is when { is not followed
by a linefeed hehe
and } is not preceded by a linefeed
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 85,
            caretLocation: 23,
            selectedLength: 20,
            selectedText: """
        not followed
        by a li
        """,
            fullyVisibleArea: 0..<85,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 85,
                number: 1,
                start: 0,
                end: 36
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 23
        AccessibilityStrategyVisualMode.head = 42
        
        var vimEngineState = VimEngineState(lastMoveBipped: true)
        let returnedElement = applyMoveBeingTested(using: .leftBrace, on: element, &vimEngineState)
        
        XCTAssertFalse(vimEngineState.lastMoveBipped)
        XCTAssertEqual(returnedElement.caretLocation, 18)
        XCTAssertEqual(returnedElement.selectedLength, 42)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 18)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 59)
    }

    func test_on_multilines_that_if_the_closingBlock_is_preceded_only_by_whitespaces_up_to_the_lineStart_then_it_works_normally_and_selects_from_the_openingBlock_to_the_closingBlock() {
        let text = """
this case is when { is not followed
by a linefeed and
     } is preceded by a linefeed
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 86,
            caretLocation: 5,
            selectedLength: 12,
            selectedText: """
        case is when
        """,
            fullyVisibleArea: 0..<86,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 86,
                number: 1,
                start: 0,
                end: 36
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 16
        AccessibilityStrategyVisualMode.head = 5
        
        var vimEngineState = VimEngineState(lastMoveBipped: true)
        let returnedElement = applyMoveBeingTested(using: .leftBrace, on: element, &vimEngineState)
        
        XCTAssertEqual(vimEngineState.lastMoveBipped, false)
        XCTAssertEqual(returnedElement.caretLocation, 18)
        XCTAssertEqual(returnedElement.selectedLength, 42)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 18)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 59)
    }
    
    func test_that_on_multilines_if_the_openingBlock_is_immediately_followed_by_a_Newline_then_it_works_normally_and_selects_from_the_openingBlock_to_the_closingBlock() {
        let text = """
this work when <
is followed by a linefeed
and > is not preceded by a linefeed
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 78,
            caretLocation: 24,
            selectedLength: 29,
            selectedText: """
        owed by a linefeed
        and > is n
        """,
            fullyVisibleArea: 0..<78,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 78,
                number: 2,
                start: 17,
                end: 43
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 24
        AccessibilityStrategyVisualMode.head = 52
        
        var vimEngineState = VimEngineState(lastMoveBipped: true)
        let returnedElement = applyMoveBeingTested(using: .leftChevron, on: element, &vimEngineState)
        
        XCTAssertEqual(vimEngineState.lastMoveBipped, false)
        XCTAssertEqual(returnedElement.caretLocation, 15)
        XCTAssertEqual(returnedElement.selectedLength, 33)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 15)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 47)
    }

    func test_that_on_multilines_if_the_openingBlock_is_immediately_followed_by_a_Newline_and_the_closingBlock_is_immediately_preceded_by_a_Newline_then_then_it_works_normally_and_selects_from_the_openingBlock_to_the_closingBlock() {
        let text = """
this case is when (
is followed by a linefeed and
) is preceded by a linefeed
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 77,
            caretLocation: 5,
            selectedLength: 21,
            selectedText: """
        case is when (
        is fol
        """,
            fullyVisibleArea: 0..<77,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 77,
                number: 1,
                start: 0,
                end: 20
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 5
        AccessibilityStrategyVisualMode.head = 25
        
        var vimEngineState = VimEngineState(lastMoveBipped: true)
        let returnedElement = applyMoveBeingTested(using: .leftParenthesis, on: element, &vimEngineState)
        
        XCTAssertEqual(vimEngineState.lastMoveBipped, false)
        XCTAssertEqual(returnedElement.caretLocation, 18)
        XCTAssertEqual(returnedElement.selectedLength, 33)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 18)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 50)
    }
    
}
