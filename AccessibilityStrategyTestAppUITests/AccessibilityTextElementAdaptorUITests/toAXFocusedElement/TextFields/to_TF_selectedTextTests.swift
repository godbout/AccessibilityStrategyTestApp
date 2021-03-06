import XCTest
@testable import AccessibilityStrategy


class to_TF_selectedTextTests: ATEA_BaseTests {

    func test_that_we_can_set_the_selected_text_for_a_TextField() {
        let text = "gonna try to set the selected text"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 34,
            caretLocation: 6,
            selectedLength: 0,
            selectedText: "banana 🍌️ ",
            fullyVisibleArea: 0..<34,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 34,
                number: 1,
                start: 0,
                end: 34
            )!
        )
        
        let textInAXFocusedElement = text
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        let conversionSucceeded = AccessibilityTextElementAdaptor.toAXFocusedElement(from: element)
        XCTAssertTrue(conversionSucceeded)
        
        let reconvertedAccessibilityTextElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
        XCTAssertEqual(reconvertedAccessibilityTextElement?.caretLocation, 17)
        XCTAssertEqual(reconvertedAccessibilityTextElement?.fileText.value, "gonna banana 🍌️ try to set the selected text")
    }
    
}
