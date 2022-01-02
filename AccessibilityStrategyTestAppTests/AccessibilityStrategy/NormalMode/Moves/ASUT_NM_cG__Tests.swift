@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_cG__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.cG(on: element, pgR: false)
    }
    
}


// copy deleted text
extension ASUT_NM_cG__Tests {
    
    func test_that_it_copies_the_deleted_text_in_the_pasteboard() {
        let text = """
blah blah some line
some more
  haha geh
need to deal with
those faces 🥺️☹️😂️

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 80,
            caretLocation: 37,
            selectedLength: 1,
            selectedText: "g",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 80,
                number: 3,
                start: 30,
                end: 41
            )!
        )
        
        _ = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
  haha geh
need to deal with
those faces 🥺️☹️😂️

"""
        )
    }
    
}


// Both
extension ASUT_NM_cG__Tests {
    
    func test_that_it_deletes_the_line_up_to_the_firstNonBlankLimit() {
        let text = "    this is a single line ‼️‼️‼️"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 32,
            caretLocation: 15,
            selectedLength: 1,
            selectedText: "i",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 32,
                number: 1,
                start: 0,
                end: 32
            )!
        )
                
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 4)
        XCTAssertEqual(returnedElement?.selectedLength, 28)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
    
}


// TextViews
extension ASUT_NM_cG__Tests {
    
    func test_that_it_deletes_from_the_firstNonBlankLimit_of_the_current_line_to_the_end_of_the_TextView() {
        let text = """
blah blah some line
some more
  haha geh
need to deal with
those faces 🥺️☹️😂️

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 80,
            caretLocation: 37,
            selectedLength: 1,
            selectedText: "g",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 80,
                number: 3,
                start: 30,
                end: 41
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 32)
        XCTAssertEqual(returnedElement?.selectedLength, 48)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
    
}
