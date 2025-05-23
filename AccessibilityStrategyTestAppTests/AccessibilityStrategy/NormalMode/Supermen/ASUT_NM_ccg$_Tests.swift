@testable import AccessibilityStrategy
import XCTest
import Common


class ASUT_NM_ccg$_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: .auto)
        
        return applyMoveBeingTested(on: element, &vimEngineState)
    }
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        // sending currentFileLine coz we can test through UT, no need UI. but logic the same. one test will be done in UI for cgZero, to
        // make sure it sends the right line type parameter.
        return asNormalMode.ccgDollarSign(using: element.currentFileLine, on: element, &vimEngineState) 
    }
    
}


// Bip, copy deletion and LYS
extension ASUT_NM_ccg$_Tests {
    
    func test_that_when_it_is_on_an_empty_line_it_does_not_Bip_and_sets_the_LastYankStyle_to_Characterwise_and_copies_an_empty_string() {
        let text = """
hehe

hoho
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 10,
            caretLocation: 5,
            selectedLength: 0,
            selectedText: "",
            fullyVisibleArea: 0..<10,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 10,
                number: 2,
                start: 5,
                end: 6
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "")
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
    
    func test_that_when_it_is_not_on_an_empty_line_it_does_not_Bip_either_and_sets_the_LastYankStyle_to_Characterwise_also_but_copies_the_deletion() {
        let text = """
C will now work with file lines and is supposed to delete from the caret ☀️ to before the linefeed
and of course this is in the case there is a linefeed at the end of the line.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 176,
            caretLocation: 55,
            selectedLength: 1,
            selectedText: "t",
            fullyVisibleArea: 0..<176,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 176,
                number: 2,
                start: 51,
                end: 99
            )!
        )
        copyToClipboard(text: "some fake shit")
        
        var vimEngineState = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "te from the caret ☀️ to before the linefeed")
        XCTAssertEqual(vimEngineState.lastYankStyle, .characterwise)
        XCTAssertFalse(vimEngineState.lastMoveBipped)
    }
    
}


// Both
extension ASUT_NM_ccg$_Tests {
    
    func test_that_if_a_file_line_does_not_end_with_a_linefeed_it_deletes_from_the_caret_to_the_end_of_the_line() {
        let text = """
this time the line will not end with a linefeed so C should delete from the caret till the end!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 95,
            caretLocation: 11,
            selectedLength: 1,
            selectedText: "h",
            fullyVisibleArea: 0..<95,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 95,
                number: 1,
                start: 0,
                end: 53
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 11)
        XCTAssertEqual(returnedElement.selectedLength, 84)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
}


// TextViews
extension ASUT_NM_ccg$_Tests {

    func test_that_if_a_file_line_ends_with_a_linefeed_it_deletes_from_the_caret_to_before_that_linefeed() {
        let text = """
C will now work with file lines and is supposed to delete from the caret ☀️ to before the linefeed
and of course this is in the case there is a linefeed at the end of the line.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 176,
            caretLocation: 55,
            selectedLength: 1,
            selectedText: "t",
            fullyVisibleArea: 0..<176,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 176,
                number: 2,
                start: 51,
                end: 99
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
                
        XCTAssertEqual(returnedElement.caretLocation, 55)
        XCTAssertEqual(returnedElement.selectedLength, 43)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
    func test_that_it_does_not_delete_the_linefeed_even_for_an_empty_line() {
        let text = """
now we have an empty line and C should behave

and not delete that fucking shit
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 79,
            caretLocation: 46,
            selectedLength: 0,
            selectedText: "",
            fullyVisibleArea: 0..<79,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 79,
                number: 2,
                start: 46,
                end: 47
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
                
        XCTAssertEqual(returnedElement.caretLocation, 46)
        XCTAssertEqual(returnedElement.selectedLength, 0)
        XCTAssertNil(returnedElement.selectedText)
    }

}
