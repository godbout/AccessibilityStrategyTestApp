import XCTest
@testable import AccessibilityStrategy
import Common


// see ASUT_NM_cQuotedString_Tests for blah blah first

// then, it's a simplified version. the move is way harder than expected
// the real Vim move may grab the quotedString that is before, or after, or within, depending
// on where the Head is located in regard to the Anchor :cry:
// probably needs heavy regex to solve this in the future.
class ASUT_VM_quotedString_Tests: ASUT_VM_BaseTests {

    private func applyMoveBeingTested(using quote: QuoteType, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: .auto)
        
        return applyMoveBeingTested(using: quote, on: element, &state)
    }
    
    // see cQuotedString blahblah. tests done with innerQuotedString but both FT funcs are tested on their own
    // + we test we pass the right params
    private func applyMoveBeingTested(using quote: QuoteType, on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asVisualMode.quotedString(element.currentFileLine.innerQuotedString, quote, on: element, &vimEngineState)
    }
    
}


// Bip
// below we will have all the cases where this move should Bip and where nothing should move (caretLocation, Anchor, Head, etc.)
// TextFields and TextViews
extension ASUT_VM_quotedString_Tests {
    
    func test_that_if_the_Anchor_is_before_the_openingQuote_and_the_Head_is_also_before_the_openingQuote_but_the_Anchor_is_after_the_Head_then_it_Bips_and_does_not_move_and_does_not_reposition_the_Anchor_and_Head() {
        let text = """
some sentence with "some nice" quotes hehe
"""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 4,
            selectedLength: 11,
            selectedText: """
         sentence w
        """,
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 14
        AccessibilityStrategyVisualMode.head = 4
        
        let returnedElement = applyMoveBeingTested(using: .doubleQuote, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 4)
        XCTAssertEqual(returnedElement.selectedLength, 11)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 14)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 4)
    }
    
    func test_that_if_the_Anchor_is_within_the_innerQuotedString_and_the_Head_is_before_the_openingQuote_then_it_Bips_and_does_not_move_and_does_not_reposition_the_Anchor_and_Head() {
        let text = """
some sentence with 'some nice' quotes hehe
"""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 8,
            selectedLength: 16,
            selectedText: """
        tence with 'some
        """,
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 23
        AccessibilityStrategyVisualMode.head = 8
        
        let returnedElement = applyMoveBeingTested(using: .singleQuote, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 16)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 23)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 8)
    }
    
    func test_that_if_the_Anchor_is_before_the_openingQuote_and_the_Head_is_after_the_openingQuote_then_it_Bips_and_does_not_move_and_does_not_reposition_the_Anchor_and_Head() {
        let text = """
some sentence with `some nice` quotes hehe
"""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 9,
            selectedLength: 27,
            selectedText: """
        ence with `some nice` quote
        """,
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 9
        AccessibilityStrategyVisualMode.head = 35
        
        let returnedElement = applyMoveBeingTested(using: .backtick, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 27)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 9)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 35)
    }
    
    func test_that_if_the_Head_is_before_the_openingQuote_and_the_Anchor_is_after_the_openingQuote_then_it_Bips_and_does_not_move_and_does_not_reposition_the_Anchor_and_Head() {
        let text = """
some sentence with `some nice` quotes hehe
"""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 9,
            selectedLength: 27,
            selectedText: """
        ence with `some nice` quote
        """,
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 35
        AccessibilityStrategyVisualMode.head = 9
        
        let returnedElement = applyMoveBeingTested(using: .backtick, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 9)
        XCTAssertEqual(returnedElement.selectedLength, 27)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 35)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 9)
    }
    
    func test_that_if_the_Anchor_is_within_the_innerQuotedString_and_the_Head_is_after_the_upperBound_then_it_Bips_and_does_not_move_and_does_not_reposition_the_Anchor_and_Head() {
        let text = """
some sentence with `some nice` quotes hehe
"""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 22,
            selectedLength: 13,
            selectedText: """
        me nice` quot
        """,
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 22
        AccessibilityStrategyVisualMode.head = 34
        
        let returnedElement = applyMoveBeingTested(using: .backtick, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 22)
        XCTAssertEqual(returnedElement.selectedLength, 13)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 22)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 34)
    }
    
    func test_that_if_the_Anchor_is_after_the_upperBound_and_the_Head_is_also_after_the_upperBound_and_the_Anchor_is_before_the_Head_then_it_Bips_and_does_not_move_and_does_not_reposition_the_Anchor_and_Head() {
        let text = """
some sentence with 'some nice' quotes hehe
"""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 31,
            selectedLength: 9,
            selectedText: """
        quotes he
        """,
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 31
        AccessibilityStrategyVisualMode.head = 39
        
        let returnedElement = applyMoveBeingTested(using: .singleQuote, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 31)
        XCTAssertEqual(returnedElement.selectedLength, 9)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 31)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 39)
    }

}


// no Bip
// TextFields and TextViews
extension ASUT_VM_quotedString_Tests {

    // TODO: this is different from innerBlock LOL. the Bips and non Bips.
    // with quotedStrings it's gonna depend if the Anchor is before the Head, etc. and of course also the position
    // regarding the innerRange.
    
    func test_that_if_the_Anchor_is_before_the_openingQuote_and_the_Head_is_also_before_the_openingQuote_and_the_Anchor_is_before_the_Head_then_it_selects_the_innerQuotedString_and_repositions_the_Anchor_and_Head_properly() {
        let text = """
some sentence with "some nice" quotes hehe
"""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 4,
            selectedLength: 11,
            selectedText: """
         sentence w
        """,
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 4
        AccessibilityStrategyVisualMode.head = 14
        
        let returnedElement = applyMoveBeingTested(using: .doubleQuote, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 20)
        XCTAssertEqual(returnedElement.selectedLength, 9)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 20)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 28)
    }
        
    func test_that_if_the_Anchor_is_before_the_openingQuote_and_the_Head_is_within_the_innerQuotedString_then_it_selects_from_the_Anchor_to_the_innerQuotedString_upperBound_and_repositions_the_Head_properly() {
        let text = """
some sentence with 'some nice' quotes hehe
"""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 8,
            selectedLength: 16,
            selectedText: """
        tence with 'some
        """,
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 8
        AccessibilityStrategyVisualMode.head = 23
        
        let returnedElement = applyMoveBeingTested(using: .singleQuote, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 21)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 8)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 28)
    }
    
    func test_that_if_the_Anchor_is_within_the_innerQuotedString_and_the_Head_is_within_the_innerQuotedString_and_the_Anchor_is_before_the_Head_then_it_selects_the_innerQuotedString_and_repositions_the_Anchor_and_the_Head_properly() {
        let text = """
some sentence with 'some nice' quotes hehe
"""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 22,
            selectedLength: 6,
            selectedText: """
        me nic
        """,
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 22
        AccessibilityStrategyVisualMode.head = 27
        
        let returnedElement = applyMoveBeingTested(using: .singleQuote, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 20)
        XCTAssertEqual(returnedElement.selectedLength, 9)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 20)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 28)
    }
    
    func test_that_if_the_Anchor_is_within_the_innerQuotedString_and_the_Head_is_within_the_innerQuotedString_and_the_Anchor_is_after_the_Head_then_it_selects_the_innerQuotedString_and_repositions_the_Anchor_and_the_Head_properly() {
        let text = """
some sentence with 'some nice' quotes hehe
"""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 22,
            selectedLength: 6,
            selectedText: """
        me nic
        """,
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 27
        AccessibilityStrategyVisualMode.head = 22
        
        let returnedElement = applyMoveBeingTested(using: .singleQuote, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 20)
        XCTAssertEqual(returnedElement.selectedLength, 9)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 28)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 20)
    }
    
    func test_that_if_the_Anchor_is_after_the_upperBound_and_the_Head_is_within_the_innerQuotedString_then_it_selects_from_the_innerQuotedString_lowerBound_to_the_Anchor_and_repositions_the_Head_properly() {
        let text = """
some sentence with 'some nice' quotes hehe
"""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 24,
            selectedLength: 14,
            selectedText: """
         nice' quotes 
        """,
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 37
        AccessibilityStrategyVisualMode.head = 24
        
        let returnedElement = applyMoveBeingTested(using: .singleQuote, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 20)
        XCTAssertEqual(returnedElement.selectedLength, 18)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 37)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 20)
    }
        
    func test_that_if_the_Anchor_is_after_the_upperBound_and_the_Head_is_also_after_the_upperBound_and_the_Head_is_before_the_Anchor_then_it_selects_the_innerQuotedString_and_repositions_the_Anchor_and_the_Head_properly() {
        let text = """
some sentence with 'some nice' quotes hehe
"""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 31,
            selectedLength: 10,
            selectedText: """
        quotes heh
        """,
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 40
        AccessibilityStrategyVisualMode.head = 31
        
        let returnedElement = applyMoveBeingTested(using: .singleQuote, on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 20)
        XCTAssertEqual(returnedElement.selectedLength, 9)
        XCTAssertNil(returnedElement.selectedText)
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 28)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 20)
    }
    
}
