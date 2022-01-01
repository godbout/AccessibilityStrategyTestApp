@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_C__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.C(on: element, pgR: false) 
    } 
    
}



// copy deleted text
extension ASUT_NM_C__Tests {
    
    func test_that_it_copies_the_deleted_text_in_the_pasteboard() {
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 176,
                number: 2,
                start: 51,
                end: 99
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        _ = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "te from the caret ☀️ to before the linefeed")
    }
    
}


// both
extension ASUT_NM_C__Tests {
    
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 95,
                number: 1,
                start: 0,
                end: 53
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 11)
        XCTAssertEqual(returnedElement?.selectedLength, 84)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
    
}


// TextViews
extension ASUT_NM_C__Tests {

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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 176,
                number: 2,
                start: 51,
                end: 99
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
                
        XCTAssertEqual(returnedElement?.caretLocation, 55)
        XCTAssertEqual(returnedElement?.selectedLength, 43)
        XCTAssertEqual(returnedElement?.selectedText, "")
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
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 79,
                number: 2,
                start: 46,
                end: 47
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
                
        XCTAssertEqual(returnedElement?.caretLocation, 46)
        XCTAssertEqual(returnedElement?.selectedLength, 0)
        XCTAssertNil(returnedElement?.selectedText)
    }

}

