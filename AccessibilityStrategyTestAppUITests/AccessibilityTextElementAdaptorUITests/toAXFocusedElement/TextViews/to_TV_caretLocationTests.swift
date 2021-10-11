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
        // TODO: create a init?
        throw XCTSkip("current crashes coz wrong element. may need to create a failable initializer.")
        
        let text = """
i'm multiplug
but still not
that long.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 38,
            caretLocation: 1993,
            selectedLength: 3,
            selectedText: nil,
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

        let conversionSucceeded = AccessibilityTextElementAdaptor.toAXFocusedElement(from: element)
        XCTAssertFalse(conversionSucceeded)
    }

}
