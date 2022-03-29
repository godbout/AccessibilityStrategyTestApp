@testable import AccessibilityStrategy
import XCTest


class ASUI_NM_i_Tests: ASUT_NM_BaseTests {}


// Both
extension ASUI_NM_i_Tests {
    
    func test_that_it_does_nothing_lol() {
        let text = "i just doesn't do shit lol. so lazy"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 35,
            caretLocation: 24,
            selectedLength: 1,
            selectedText: "o",
            fullyVisibleArea: 0..<35,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 1,
                start: 0,
                end: 35
            )!
        )
        
        let returnedElement = asNormalMode.i(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 24)    
        XCTAssertEqual(returnedElement.selectedLength, 0)
        XCTAssertNil(returnedElement.selectedText)
    }    
    
}


// emojis
extension ASUI_NM_i_Tests {
    
    func test_that_it_handles_emojis() {
        let text = """
need to deal with
those💨️💨️💨️ faces 🥺️☹️😂️ h😀️ha
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 54,
            caretLocation: 44,
            selectedLength: 3,
            selectedText: "😂️",
            fullyVisibleArea: 0..<54,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 54,
                number: 2,
                start: 18,
                end: 54
            )!
        )
        
        let returnedElement = asNormalMode.i(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 44)    
        XCTAssertEqual(returnedElement.selectedLength, 0)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}

