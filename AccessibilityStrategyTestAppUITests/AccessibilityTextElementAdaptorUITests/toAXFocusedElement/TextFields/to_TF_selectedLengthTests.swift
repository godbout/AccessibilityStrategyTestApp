import XCTest
@testable import AccessibilityStrategy


class to_TF_selectedLengthTests: ATEA_BaseTests {
    
    func test_that_we_can_set_a_selection_length() {
        let text = "hello you dear 🍏️"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 18,
            caretLocation: 10,
            selectedLength: 8,
            selectedText: nil,
            fullyVisibleArea: 0..<18,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 18,
                number: 1,
                start: 0,
                end: 18
            )!
        )
        
        let textInAXFocusedElement = text
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        let conversionSucceeded = AccessibilityTextElementAdaptor.toAXFocusedElement(from: element)
        XCTAssertTrue(conversionSucceeded)
        
        let reconvertedAccessibilityTextElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
        XCTAssertEqual(reconvertedAccessibilityTextElement?.selectedLength, 8)
    }
    
}
