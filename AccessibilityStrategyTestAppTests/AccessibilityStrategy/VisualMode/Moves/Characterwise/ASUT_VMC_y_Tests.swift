import AccessibilityStrategy
import XCTest
import Common


class ASUT_VMC_y_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: .auto, visualStyle: .characterwise)
        
        return applyMoveBeingTested(on: element, &vimEngineState)
    }
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        vimEngineState.visualStyle = .characterwise
        
        return asVisualMode.y(on: element, &vimEngineState)
    }
    
}


// Bip, yank and LYS
extension ASUT_VMC_y_Tests {

    func test_that_it_always_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_copies_the_selected_text_even_for_an_EmptyLine() {
        let text = """
all that VM d does
in characterwi😂️e is deleting
the selection!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 64,
            caretLocation: 14,
            selectedLength: 19,
            selectedText: "does\nin characterwi",
            fullyVisibleArea: 0..<64,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 64,
                number: 1,
                start: 0,
                end: 19
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
does
in characterwi
"""
        )
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
    
}


// TextFields and TextViews
extension ASUT_VMC_y_Tests {
  
    func test_that_it_yanks_the_selection() {
        let text = "well VM v plus then VM y should copy the selected text."
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 55,
            caretLocation: 15,
            selectedLength: 27,
            selectedText: "then VM y should copy the s",
            fullyVisibleArea: 0..<55,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 55,
                number: 1,
                start: 0,
                end: 55
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "then VM y should copy the s")
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)        
    }
    
    func test_that_after_yanking_it_gets_back_to_the_caret_position() {
        let text = "after yanking you go back to caret you bastard!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 47,
            caretLocation: 8,
            selectedLength: 31,
            selectedText: "nking you go back to caret you ",
            fullyVisibleArea: 0..<47,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 47,
                number: 1,
                start: 0,
                end: 47
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_TextElement_is_empty_it_works_and_copies_the_emptiness_of_life() {
        let text = ""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 0,
            caretLocation: 0,
            selectedLength: 0,
            selectedText: "",
            fullyVisibleArea: 0..<0,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 0,
                number: 1,
                start: 0,
                end: 0
            )!
        )
        copyToClipboard(text: "test 1 for The 3 Cases VM y")
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "")
        XCTAssertEqual(returnedElement.selectedLength, 0)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_caret_is_at_the_last_character_of_the_TextElement_and_on_an_EmptyLine_on_its_own_it_works_and_copies_nothing() {
        let text = """
caret is on its
own empty
line

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 31,
            caretLocation: 31,
            selectedLength: 0,
            selectedText: "",
            fullyVisibleArea: 0..<31,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 4,
                start: 31,
                end: 31
            )!
        )
        copyToClipboard(text: "test 3 of The 3 Cases VM y")
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "")
        XCTAssertEqual(returnedElement.selectedLength, 0)
        XCTAssertNil(returnedElement.selectedText)
    }   
    
}


// emojis
extension ASUT_VMC_y_Tests {
    
    func test_that_it_handles_emojis() {
        let text = "after ya🍦️king you go back to caret you bastard!"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 49,
            caretLocation: 8,
            selectedLength: 33,
            selectedText: "🍦️king you go back to caret you ",
            fullyVisibleArea: 0..<49,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 49,
                number: 1,
                start: 0,
                end: 49
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 8)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
