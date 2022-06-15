@testable import AccessibilityStrategy
import XCTest
import Common


// see `cABlock` for blah blah
class ASUT_NM_yABlock_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(using bracket: Character, on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.yABlock(using: bracket, on: element, &vimEngineState) 
    }
    
}


// Bip, copy deletion and LYS
// see `cABlock` for blah blah


// Both
extension ASUT_NM_yABlock_Tests {
    
    func test_that_it_there_is_no_block_found_it_bips_and_does_not_copy_anything_and_does_not_change_the_LastYankStyle() {
        let text = "no block here"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 13,
            caretLocation: 6,
            selectedLength: 1,
            selectedText: """
        c
        """,
            fullyVisibleArea: 0..<13,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 13,
                number: 1,
                start: 0,
                end: 13
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: false, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(using: "(", on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
        XCTAssertEqual(returnedElement.caretLocation, 6)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
        
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertEqual(state.lastMoveBipped, true)
    }

    func test_that_it_copies_the_block_and_puts_the_caret_on_the_opening_bracket_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise() {
        let text = "some text that {😂️ has some nice } braces"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 42,
            caretLocation: 26,
            selectedLength: 1,
            selectedText: "m",
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        var state = VimEngineState(lastMoveBipped: false, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(using: "{", on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "{😂️ has some nice }")
        XCTAssertEqual(returnedElement.caretLocation, 15)  
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
        
        XCTAssertEqual(state.lastYankStyle, .characterwise)        
        XCTAssertEqual(state.lastMoveBipped, false)        
    }
    
}


// TextViews
extension ASUT_NM_yABlock_Tests {
    
    func test_that_it_copies_the_block_on_different_lines_and_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise() {
        let text = """
this case is when { is not followed
by a linefeed
and } is not preceded by a linefeed
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 85,
            caretLocation: 25,
            selectedLength: 0,
            selectedText: "",
            fullyVisibleArea: 0..<85,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 85,
                number: 1,
                start: 0,
                end: 36
            )!
        )
        
        var state = VimEngineState(lastMoveBipped: false, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(using: "{", on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
{ is not followed
by a linefeed
and }
"""
        )
        XCTAssertEqual(returnedElement.caretLocation, 18)  
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
        
        XCTAssertEqual(state.lastYankStyle, .characterwise)        
        XCTAssertEqual(state.lastMoveBipped, false)  
    }
    
    func test_that_if_the_opening_bracket_is_immediately_followed_by_a_linefeed_contrary_to_innerBlock_the_whole_thing_is_copied_and_it_does_not_Bip_and_it_sets_the_LastYankStyle_to_Characterwise() {
        let text = """
this work when {
is followed by a linefeed
and } is not preceded by a linefeed
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 78,
            caretLocation: 29,
            selectedLength: 1,
            selectedText: "b",
            fullyVisibleArea: 0..<78,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 78,
                number: 2,
                start: 17,
                end: 43
            )!
        )
        
        var state = VimEngineState(lastMoveBipped: false, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(using: "{", on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
{
is followed by a linefeed
and }
"""
        )
        XCTAssertEqual(returnedElement.caretLocation, 15)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
                
        XCTAssertEqual(state.lastYankStyle, .characterwise)        
        XCTAssertEqual(state.lastMoveBipped, false)  
    }
    
    func test_that_if_the_closing_bracket_is_preceded_only_by_whitespaces_up_to_the_beginning_of_the_line_then_contrary_to_innerBlock_the_whole_thing_is_copied_and_it_does_not_Bip_but_it_sets_the_LastYankStyle_to_Characterwise() {
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
        
        var state = VimEngineState(lastMoveBipped: false, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(using: "{", on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
{ is not followed
by a linefeed and
     }
"""
        )
        XCTAssertEqual(returnedElement.caretLocation, 18)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
                
        XCTAssertEqual(state.lastYankStyle, .characterwise)        
        XCTAssertEqual(state.lastMoveBipped, false)  
    }
    
    func test_that_if_the_opening_bracket_is_immediately_followed_by_a_linefeed_and_the_closing_bracket_is_immediately_preceded_by_a_linefeed_then_contrary_the_innerBlock_the_move_copies_the_whole_thing_and_it_does_not_Bip_but_it_sets_the_LastYankStyle_to_Characterwise() {
        let text = """
this case is when {
is followed by a linefeed and
} is preceded by a linefeed
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 77,
            caretLocation: 36,
            selectedLength: 1,
            selectedText: " ",
            fullyVisibleArea: 0..<77,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 77,
                number: 2,
                start: 20,
                end: 50
            )!
        )
        
        var state = VimEngineState(lastMoveBipped: false, lastYankStyle: .linewise)
        let returnedElement = applyMoveBeingTested(using: "{", on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
{
is followed by a linefeed and
}
"""
        )
        XCTAssertEqual(returnedElement.caretLocation, 18)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
        
        XCTAssertEqual(state.lastYankStyle, .characterwise)        
        XCTAssertEqual(state.lastMoveBipped, false)  
    }
    
}
