@testable import AccessibilityStrategy
import XCTest
import Common


// TODO: test Bip by itself. no need for Anchor before Head for single AND multiline. that was a crazy thought lol


// this move uses FT.innerBlock so we're not gonna test this. innerBlock is already heavily tested on its own.
// here we're gonna test the stuff specific to VM innerBlock, which is cases where it Bips, repositioning Anchor and Head, etc.
class ASUT_VM_innerBlock_AnchorBeforeHead_Tests: ASUT_VM_BaseTests {

    private func applyMoveBeingTested(using openingBlock: OpeningBlockType, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: .auto)
        
        return applyMoveBeingTested(using: openingBlock, on: element, &state)
    }
        
    private func applyMoveBeingTested(using openingBlock: OpeningBlockType, on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asVisualMode.innerBlock(using: openingBlock, on: element, &vimEngineState)
    }
    
}


extension ASUT_VM_innerBlock_AnchorBeforeHead_Tests {
    
    func test_that_for_Anchor_before_Head_if_the_Anchor_is_before_the_openingBlock_and_the_Head_is_also_before_the_openingBlock_then_it_selects_the_innerBlock_and_repositions_the_Anchor_and_Head_properly() {
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
    
    func test_that_for_Anchor_before_Head_if_the_Anchor_is_before_the_openingBlock_and_the_Head_is_within_the_innerBlock_but_not_at_the_upperBound_then_it_selects_the_innerBlock_and_repositions_the_Anchor_and_Head_properly() {
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
    
    func test_that_for_Anchor_before_Head_if_the_Anchor_is_before_the_openingBlock_and_the_Head_is_at_the_innerBlock_upperBound_then_it_Bips_and_does_not_move_and_does_not_reposition_the_Anchor_and_Head() {
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
        
        AccessibilityStrategyVisualMode.anchor = 3
        AccessibilityStrategyVisualMode.head = 18
        
        var state = VimEngineState(lastMoveBipped: false)
        let returnedElement = applyMoveBeingTested(using: .leftBracket, on: element, &state)
        
        XCTAssertTrue(state.lastMoveBipped)
        XCTAssertEqual(returnedElement.caretLocation, 3)
        XCTAssertEqual(returnedElement.selectedLength, 16)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 3)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 18)
    }
    
    func test_that_for_Anchor_before_Head_if_the_Anchor_is_before_the_openingBlock_and_the_Head_is_after_the_innerBlock_then_it_Bips_and_does_not_move_and_does_not_reposition_the_Anchor_and_Head() {
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
        
        AccessibilityStrategyVisualMode.anchor = 3
        AccessibilityStrategyVisualMode.head = 22
        
        var state = VimEngineState(lastMoveBipped: false)
        let returnedElement = applyMoveBeingTested(using: .leftBracket, on: element, &state)
        
        XCTAssertTrue(state.lastMoveBipped)
        XCTAssertEqual(returnedElement.caretLocation, 3)
        XCTAssertEqual(returnedElement.selectedLength, 20)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 3)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 22)
    }
    
    func test_that_for_Anchor_before_Head_if_the_Anchor_is_within_innerBlock_at_the_lowerBound_and_the_Head_is_within_the_innerBlock_but_not_at_the_upperBound_then_it_selects_the_innerBlock_and_repositions_the_Anchor_and_Head_properly() {
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
    
    func test_that_for_Anchor_before_Head_if_the_Anchor_is_at_the_innerBlock_lowerBound_and_the_Head_is_at_the_innerBlock_upperBound_then_it_Bips_and_does_not_move_and_does_not_reposition_the_Anchor_and_Head() {
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
        
        var state = VimEngineState(lastMoveBipped: false)
        let returnedElement = applyMoveBeingTested(using: .leftBracket, on: element, &state)
        
        XCTAssertTrue(state.lastMoveBipped)
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 10)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 9)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 18)
    }
    
    func test_that_for_Anchor_before_Head_if_the_Anchor_is_at_the_innerBlock_lowerBound_and_the_Head_is_after_the_innerBlock_upperBound_then_it_Bips_and_does_not_move_and_does_not_reposition_the_Anchor_and_Head() {
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
        
        AccessibilityStrategyVisualMode.anchor = 9
        AccessibilityStrategyVisualMode.head = 22
        
        var state = VimEngineState(lastMoveBipped: false)
        let returnedElement = applyMoveBeingTested(using: .leftParenthesis, on: element, &state)
        
        XCTAssertTrue(state.lastMoveBipped)
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 14)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 9)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 22)
    }
    
    func test_that_for_Anchor_before_Head_if_the_Anchor_is_within_the_innerBlock_but_not_at_the_lowerbound_and_the_Head_is_within_the_innerBlock_but_not_at_the_upperBound_then_it_selects_the_innerBlock_and_repositions_the_Anchor_and_Head_properly() {
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
    
    func test_that_for_Anchor_before_Head_if_the_Anchor_is_within_the_innerBlock_but_not_at_the_lowerbound_and_the_Head_is_within_the_innerBlock_at_the_upperBound_then_it_selects_the_innerBlock_and_repositions_the_Anchor_and_Head_properly() {
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
    
    func test_that_for_Anchor_before_Head_if_the_Anchor_is_within_the_innerBlock_but_not_at_the_lowerbound_and_the_Head_is_after_the_innerBlock_then_it_selects_the_innerBlock_and_repositions_the_Anchor_and_Head_properly() {
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
    
    func test_that_for_Anchor_before_Head_if_the_Anchor_is_within_the_innerBlock_at_the_upperBound_and_the_Head_is_after_the_innerBlock_then_it_selects_the_innerBlock_and_repositions_the_Anchor_and_Head_properly() {
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
    
}


// TextViews
extension ASUT_VM_innerBlock_AnchorBeforeHead_Tests {
    
    // TODO: change name
    func test_that_it_gets_the_content_between_two_brackets_on_different_lines_and_does_not_Bip() {
        let text = """
this case is when { is not followed
by a linefeed
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

        
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(using: .leftBrace, on: element, &state)
        
        XCTAssertEqual(state.lastMoveBipped, false)
        XCTAssertEqual(returnedElement.caretLocation, 19)
        XCTAssertEqual(returnedElement.selectedLength, 35)
        XCTAssertNil(returnedElement.selectedText)
    }

    // TODO: change name
    func test_that_if_the_closing_bracket_is_preceded_only_by_whitespaces_up_to_the_beginning_of_the_line_then_the_previous_line_linefeed_is_not_deleted_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise() {
        let text = """
this case is when { is not followed
by a linefeed and
     } is preceded by a linefeed
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 86,
            caretLocation: 23,
            selectedLength: 1,
            selectedText: "n",
            fullyVisibleArea: 0..<86,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 86,
                number: 1,
                start: 0,
                end: 36
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(using: .leftBrace, on: element, &state)

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
 is not followed
by a linefeed and
"""
        )        
        XCTAssertEqual(returnedElement.caretLocation, 19)
        XCTAssertEqual(returnedElement.selectedLength, 34)
        XCTAssertEqual(returnedElement.selectedText, "")
        
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertEqual(state.lastMoveBipped, false)
    }
//    
//    func test_that_in_the_case_where_it_leaves_an_empty_line_between_the_brackets_it_positions_the_cursor_according_to_the_first_non_blank_of_the_first_line_that_is_after_the_opening_bracket_and_does_not_Bip_and_sets_the_LastYankStyle_to_Linewise() {
//        let text = """
//now that shit will get cleaned (
//    and the non blank
//  will be respected!
//)
//"""
//        let element = AccessibilityTextElement(
//            role: .textArea,
//            value: text,
//            length: 77,
//            caretLocation: 55,
//            selectedLength: 1,
//            selectedText: " ",
//            fullyVisibleArea: 0..<77,
//            currentScreenLine: ScreenLine(
//                fullTextValue: text,
//                fullTextLength: 77,
//                number: 3,
//                start: 55,
//                end: 76
//            )!
//        )
//        
//        copyToClipboard(text: "some fake shit")
//        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
//        let returnedElement = applyMoveBeingTested(using: .leftParenthesis, on: element, &state)
//
//        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
//    and the non blank
//  will be respected!\n
//"""
//        )
//        XCTAssertEqual(returnedElement.caretLocation, 37)
//        XCTAssertEqual(returnedElement.selectedLength, 38)
//        XCTAssertEqual(returnedElement.selectedText, "")
//        
//        XCTAssertEqual(state.lastYankStyle, .linewise)
//        XCTAssertEqual(state.lastMoveBipped, false)
//    }
//
//    func test_that_if_the_opening_bracket_is_immediately_followed_by_a_linefeed_the_linefeed_is_not_deleted_and_it_does_not_Bip_and_it_sets_the_LastYankStyle_to_Characterwise() {
//        let text = """
//this work when [
//is followed by a linefeed
//and ] is not preceded by a linefeed
//"""
//        let element = AccessibilityTextElement(
//            role: .textArea,
//            value: text,
//            length: 78,
//            caretLocation: 41,
//            selectedLength: 1,
//            selectedText: "d",
//            fullyVisibleArea: 0..<78,
//            currentScreenLine: ScreenLine(
//                fullTextValue: text,
//                fullTextLength: 78,
//                number: 2,
//                start: 17,
//                end: 43
//            )!
//        )
//        
//        copyToClipboard(text: "some fake shit")
//        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
//        let returnedElement = applyMoveBeingTested(using: .leftBracket, on: element, &state)
//
//        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
//is followed by a linefeed
//and 
//"""
//        )
//        XCTAssertEqual(returnedElement.caretLocation, 17)
//        XCTAssertEqual(returnedElement.selectedLength, 30)
//        XCTAssertEqual(returnedElement.selectedText, "")
//        
//        XCTAssertEqual(state.lastYankStyle, .characterwise)
//        XCTAssertEqual(state.lastMoveBipped, false)
//    }
//
//    func test_that_if_the_opening_bracket_is_immediately_followed_by_a_linefeed_and_the_closing_bracket_is_immediately_preceded_by_a_linefeed_then_the_move_keeps_an_empty_line_between_the_brackets_and_it_does_not_Bip_and_it_sets_the_LastYankStyle_to_Linewise() {
//        let text = """
//this case is when (
//is followed by a linefeed and
//) is preceded by a linefeed
//"""
//        let element = AccessibilityTextElement(
//            role: .textArea,
//            value: text,
//            length: 77,
//            caretLocation: 46,
//            selectedLength: 1,
//            selectedText: "a",
//            fullyVisibleArea: 0..<77,
//            currentScreenLine: ScreenLine(
//                fullTextValue: text,
//                fullTextLength: 77,
//                number: 2,
//                start: 20,
//                end: 50
//            )!
//        )
//        
//        copyToClipboard(text: "some fake shit")
//        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
//        let returnedElement = applyMoveBeingTested(using: .leftParenthesis, on: element, &state)
//        
//        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
//is followed by a linefeed and\n
//"""
//        )
//        XCTAssertEqual(returnedElement.caretLocation, 20)
//        XCTAssertEqual(returnedElement.selectedLength, 29)
//        XCTAssertEqual(returnedElement.selectedText, "")
//        
//        XCTAssertEqual(state.lastYankStyle, .linewise)
//        XCTAssertEqual(state.lastMoveBipped, false)
//    }
    
}
