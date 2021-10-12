import XCTest
@testable import AccessibilityStrategy


class to_TV_caretLocationTests: ATEA_BaseTests {

    func test_that_we_can_set_the_caret_location_to_0_on_a_non_empty_TextView() {
        let text = """
so obviously that's
a TextView that is not empty
coz like come on there's so me shits inside.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 93,
            caretLocation: 0,
            selectedLength: 1,
            selectedText: nil,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 93,
                number: 1,
                start: 0,
                end: 20
            )
        )

        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(text)

        let conversionSucceeded = AccessibilityTextElementAdaptor.toAXFocusedElement(from: element)
        XCTAssertTrue(conversionSucceeded)

        let reconvertedAccessibilityTextElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
        XCTAssertEqual(reconvertedAccessibilityTextElement?.caretLocation, 0)
    }
    
    func test_that_we_can_set_the_caret_location_wherever_between_the_beginning_and_the_end_of_the_TextView() {
        let text = """
those shits never stop
i tell you
it's biiiiiiig 🍍️🍍️🍍️ and long
hallelujah
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 78,
            caretLocation: 30,
            selectedLength: 1,
            selectedText: nil,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 78,
                number: 2,
                start: 23,
                end: 34
            )
        )

        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(text)

        let conversionSucceeded = AccessibilityTextElementAdaptor.toAXFocusedElement(from: element)
        XCTAssertTrue(conversionSucceeded)

        let reconvertedAccessibilityTextElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
        XCTAssertEqual(reconvertedAccessibilityTextElement?.caretLocation, 30)
    }

    func test_that_the_conversion_fails_if_we_set_the_caret_location_out_of_range() throws {
        let text = """
i'm multiplug
but still not
that long.
"""
        // this element has correct info, as this is what will be
        // given by the AX API. setting a wrong caretLocation would come
        // after, like for example if there's a bug in a move.
        var element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 38,
            caretLocation: 22,
            selectedLength: 1,
            selectedText: "l",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 38,
                number: 2,
                start: 14,
                end: 28
            )
        )

        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(text)
        
        // this is where we mock a bug in a move that sets a wrong caretLocation that will
        // be pushed by the ATEAdaptor.
        element.caretLocation = 3669

        let conversionSucceeded = AccessibilityTextElementAdaptor.toAXFocusedElement(from: element)
        XCTAssertFalse(conversionSucceeded)
    }

}
