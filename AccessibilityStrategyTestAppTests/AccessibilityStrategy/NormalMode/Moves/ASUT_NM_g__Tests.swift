import XCTest
@testable import AccessibilityStrategy


// see ^ for blah blah
class ASUT_NM_g__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.gUnderscore(on: element) 
    }
    
}


// line
extension ASUT_NM_g__Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
  this move stops at screen lines, which         🇧🇶️eans it will
  stop even without a linefeed. that's         how special it is😂️
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 134,
            caretLocation: 83,
            selectedLength: 1,
            selectedText: "o",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 134,
                number: 8,
                start: 79,
                end: 89
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 131)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }
     
}


// TextViews
extension ASUT_NM_g__Tests {
    
    func test_that_for_an_empty_line_it_stops_at_the_beginning_of_the_line() {
        let text = """
a multiline and the next

is an empty one.
"""        
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 42,
            caretLocation: 25,
            selectedLength: 1,
            selectedText: "\n",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 3,
                start: 25,
                end: 26
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 25)  
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
