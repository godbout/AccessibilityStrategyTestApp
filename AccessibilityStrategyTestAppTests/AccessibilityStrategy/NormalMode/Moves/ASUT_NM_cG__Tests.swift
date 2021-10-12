@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_cG__Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.cG(on: element) 
    }
    
}


// line
extension ASUT_NM_cG__Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen lines. it will just pass by
them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 115,
            caretLocation: 59,
            selectedLength: 1,
            selectedText: "b",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 3,
                start: 54,
                end: 62
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 0)
        XCTAssertEqual(returnedElement?.selectedLength, 115)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
     
}



// Both
extension ASUT_NM_cG__Tests {
    
    func test_that_it_deletes_the_whole_line() {
        let text = "this is a single line ‼️‼️‼️"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 28,
            caretLocation: 14,
            selectedLength: 1,
            selectedText: "l",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 28,
                number: 2,
                start: 10,
                end: 22
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 0)
        XCTAssertEqual(returnedElement?.selectedLength, 28)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
    
}


// TextViews
extension ASUT_NM_cG__Tests {
    
    func test_that_it_deletes_from_the_beginning_of_the_current_line_to_the_end_of_the_TextView() {
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
            length: 78,
            caretLocation: 35,
            selectedLength: 1,
            selectedText: "g",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 78,
                number: 3,
                start: 30,
                end: 39
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 30)
        XCTAssertEqual(returnedElement?.selectedLength, 48)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
    
}
