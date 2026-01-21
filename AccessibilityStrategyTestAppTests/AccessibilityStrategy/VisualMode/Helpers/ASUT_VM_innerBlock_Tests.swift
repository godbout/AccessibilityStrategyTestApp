@testable import AccessibilityStrategy
import XCTest
import Common


// this move uses FT.innerBlock. innerBlock is already heavily tested on its own.
// here we're gonna test the stuff specific to VM innerBlock, which is cases where it Bips, repositioning Anchor and Head, etc.
class ASUT_VM_innerBlock_Tests: ASUT_VM_BaseTests {

    private func applyMoveBeingTested(using openingBlock: OpeningBlockType, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: .auto)
        
        return applyMoveBeingTested(using: openingBlock, on: element, &vimEngineState)
    }
        
    private func applyMoveBeingTested(using openingBlock: OpeningBlockType, on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asVisualMode.innerBlock(using: openingBlock, on: element, &vimEngineState)
    }
    
}


// Bip
// below we will have all the cases where this move should Bip and where nothing should move (caretLocation, Anchor, Head, etc.)
// TextFields and TextViews
extension ASUT_VM_innerBlock_Tests {
    
    func test_that_if_the_selectionStart_is_before_the_openingBlock_and_the_selectionEnd_is_at_the_innerBlock_upperBound_then_it_Bips_and_does_not_move_and_does_not_reposition_the_Anchor_and_Head() {
        let text = "this is [some block] hehe"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 25,
            caretLocation: 3,
            selectedLength: 16,
            selectedText: """
        s is [some block
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
        AccessibilityStrategyVisualMode.head = 18
        
        var vimEngineState = VimEngineState(lastMoveBipped: false)
        let returnedElement = applyMoveBeingTested(using: .leftBracket, on: element, &vimEngineState)
        
        XCTAssertTrue(vimEngineState.lastMoveBipped)
        XCTAssertEqual(returnedElement.caretLocation, 3)
        XCTAssertEqual(returnedElement.selectedLength, 16)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 3)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 18)
    }
    
    func test_that_if_the_selectionStart_is_before_the_openingBlock_and_the_selectionEnd_is_after_the_innerBlock_then_it_Bips_and_does_not_move_and_does_not_reposition_the_Anchor_and_Head() {
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
        
        XCTAssertTrue(vimEngineState.lastMoveBipped)
        XCTAssertEqual(returnedElement.caretLocation, 3)
        XCTAssertEqual(returnedElement.selectedLength, 26)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 3)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 28)
    }
    
    func test_that_if_the_selectionStart_is_at_the_innerBlock_lowerBound_and_the_selectionEnd_is_at_the_innerBlock_upperBound_then_it_Bips_and_does_not_move_and_does_not_reposition_the_Anchor_and_Head() {
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
        
        AccessibilityStrategyVisualMode.anchor = 9
        AccessibilityStrategyVisualMode.head = 18
        
        var vimEngineState = VimEngineState(lastMoveBipped: false)
        let returnedElement = applyMoveBeingTested(using: .leftBracket, on: element, &vimEngineState)
        
        XCTAssertTrue(vimEngineState.lastMoveBipped)
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 10)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 9)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 18)
    }
    
    func test_that_if_the_selectionStart_is_at_the_innerBlock_lowerBound_and_the_selectionEnd_is_after_the_innerBlock_upperBound_then_it_Bips_and_does_not_move_and_does_not_reposition_the_Anchor_and_Head() {
        let text = """
this is (some blo
ck) hehe
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 26,
            caretLocation: 9,
            selectedLength: 14,
            selectedText: """
        some blo
        ck) h
        """,
            fullyVisibleArea: 0..<26,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 26,
                number: 1,
                start: 0,
                end: 18
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 9
        AccessibilityStrategyVisualMode.head = 22
        
        var vimEngineState = VimEngineState(lastMoveBipped: false)
        let returnedElement = applyMoveBeingTested(using: .leftParenthesis, on: element, &vimEngineState)
        
        XCTAssertTrue(vimEngineState.lastMoveBipped)
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 14)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 9)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 22)
    }
    
}


// no Bip
// TextFields and TextViews
extension ASUT_VM_innerBlock_Tests {

    func test_that_if_the_selectionStart_is_before_the_openingBlock_and_the_selectionEnd_is_also_before_the_openingBlock_then_it_selects_the_innerBlock_and_repositions_the_Anchor_and_Head_properly() {
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
        
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 10)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 9)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 18)
    }
    
    func test_that_if_the_selectionStart_is_before_the_openingBlock_and_the_seletionHead_is_within_the_innerBlock_but_not_at_the_upperBound_then_it_selects_the_innerBlock_and_repositions_the_Anchor_and_Head_properly() {
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
        
        AccessibilityStrategyVisualMode.anchor = 3
        AccessibilityStrategyVisualMode.head = 16
        
        let returnedElement = applyMoveBeingTested(using: .leftBrace, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 10)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 9)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 18)
    }
    
    func test_that_if_the_selectionStart_is_at_the_innerBlock_lowerBound_and_the_selectionEnd_is_within_the_innerBlock_but_not_at_the_upperBound_then_it_selects_the_innerBlock_and_repositions_the_Anchor_and_Head_properly() {
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
        
        AccessibilityStrategyVisualMode.anchor = 9
        AccessibilityStrategyVisualMode.head = 15
        
        let returnedElement = applyMoveBeingTested(using: .leftBracket, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 10)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 9)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 18)
    }
    
    
    func test_that_for_if_the_selectionStart_is_within_the_innerBlock_but_not_at_the_lowerbound_and_the_selectionEnd_is_within_the_innerBlock_but_not_at_the_upperBound_then_it_selects_the_innerBlock_and_repositions_the_Anchor_and_Head_properly() {
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
        
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 10)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 9)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 18)
    }
    
    func test_that_if_the_selectionStart_is_within_the_innerBlock_but_not_at_the_lowerbound_and_the_selectionEnd_is_at_the_innerBlock_upperBound_then_it_selects_the_innerBlock_and_repositions_the_Anchor_and_Head_properly() {
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
        
        AccessibilityStrategyVisualMode.anchor = 12
        AccessibilityStrategyVisualMode.head = 18
        
        let returnedElement = applyMoveBeingTested(using: .leftParenthesis, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 10)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 9)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 18)
    }
    
    func test_that_for_if_the_selectionStart_is_within_the_innerBlock_but_not_at_the_lowerbound_and_the_selectionEnd_is_after_the_innerBlock_then_it_selects_the_innerBlock_and_repositions_the_Anchor_and_Head_properly() {
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
        
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 10)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 9)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 18)
    }
    
    func test_that_if_the_selectionStart_is_at_the_innerBlock_upperBound_and_the_selectionEnd_is_after_the_innerBlock_then_it_selects_the_innerBlock_and_repositions_the_Anchor_and_Head_properly() {
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
        
        AccessibilityStrategyVisualMode.anchor = 18
        AccessibilityStrategyVisualMode.head = 24
        
        let returnedElement = applyMoveBeingTested(using: .leftParenthesis, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 10)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 9)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 18)
    }
    
    func test_on_multilines_that_in_normal_setting_it_selects_between_the_openingBlock_and_the_closingBlock_and_does_not_Bip() {
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
        
        XCTAssertEqual(vimEngineState.lastMoveBipped, false)
        XCTAssertEqual(returnedElement.caretLocation, 19)
        XCTAssertEqual(returnedElement.selectedLength, 40)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 19)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 58)
    }

    func test_on_multilines_that_if_the_closingBlock_is_preceded_only_by_whitespaces_up_to_the_lineStart_then_it_selects_the_previous_line_Newline_and_does_not_Bip() {
        let text = """
this case is when { is not followed
by a linefeed and
     } is preceded by a linefeed
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 86,
            caretLocation: 11,
            selectedLength: 45,
            selectedText: """
        s when { is not followed
        by a linefeed and
          
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
        
        AccessibilityStrategyVisualMode.anchor = 11
        AccessibilityStrategyVisualMode.head = 55
        
        var vimEngineState = VimEngineState(lastMoveBipped: true)
        let returnedElement = applyMoveBeingTested(using: .leftBrace, on: element, &vimEngineState)
        
        XCTAssertEqual(vimEngineState.lastMoveBipped, false)
        XCTAssertEqual(returnedElement.caretLocation, 19)
        XCTAssertEqual(returnedElement.selectedLength, 35)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 19)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 53)
    }

    func test_that_on_multilines_if_the_openingBlock_is_immediately_followed_by_a_Newline_the_Newline_is_not_selected_and_it_does_not_Bip() {
        let text = """
this work when [
is followed by a linefeed
and ] is not preceded by a linefeed
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 78,
            caretLocation: 27,
            selectedLength: 27,
            selectedText: """
        d by a linefeed
        and ] is no
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
        
        AccessibilityStrategyVisualMode.anchor = 53
        AccessibilityStrategyVisualMode.head = 27
        
        var vimEngineState = VimEngineState(lastMoveBipped: true)
        let returnedElement = applyMoveBeingTested(using: .leftBracket, on: element, &vimEngineState)
        
        XCTAssertEqual(vimEngineState.lastMoveBipped, false)
        XCTAssertEqual(returnedElement.caretLocation, 17)
        XCTAssertEqual(returnedElement.selectedLength, 30)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 17)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 46)
    }

    func test_that_on_multilines_if_the_openingBlock_is_immediately_followed_by_a_Newline_and_the_closingBlock_is_immediately_preceded_by_a_Newline_then_it_selects_the_line_in_between_the_blocks_including_the_Newline_and_does_not_Bip() {
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
        XCTAssertEqual(returnedElement.caretLocation, 20)
        XCTAssertEqual(returnedElement.selectedLength, 30)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 20)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 49)
    }
    
    func test_that_on_multilines_if_the_openingBlock_is_immediately_followed_by_a_Newline_and_the_closingBlock_is_immediately_preceded_by_a_Newline_then_it_selects_the_lines_in_between_the_blocks_starting_from_their_start_and_including_the_Newlines_and_does_not_Bip() {
        let text = """
this case is when <
    is followed by a linefeed and
    and even some more
> is preceded by a linefeed
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 105,
            caretLocation: 8,
            selectedLength: 57,
            selectedText: """
        e is when <
            is followed by a linefeed and
            and eve
        """,
            fullyVisibleArea: 0..<105,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 105,
                number: 1,
                start: 0,
                end: 20
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 8
        AccessibilityStrategyVisualMode.head = 64
        
        var vimEngineState = VimEngineState(lastMoveBipped: true)
        let returnedElement = applyMoveBeingTested(using: .leftChevron, on: element, &vimEngineState)
        
        XCTAssertEqual(vimEngineState.lastMoveBipped, false)
        XCTAssertEqual(returnedElement.caretLocation, 20)
        XCTAssertEqual(returnedElement.selectedLength, 57)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 20)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 76)
    }
    
}
