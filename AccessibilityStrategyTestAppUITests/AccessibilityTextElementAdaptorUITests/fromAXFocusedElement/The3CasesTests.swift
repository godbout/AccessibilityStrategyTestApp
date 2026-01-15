import XCTest
@testable import AccessibilityStrategy


// here we test what we really receive or calculate from the Adaptor,
// we don't test the computed properties. those are tested in Unit Tests,
// ATE and ATELine
// 2022-04-05: the 2nd case is back. will be needed for calculation of ScreenLines with visibleCharacterRange
// because the visibleCharacterRange is a range that goes from one character to AFTER another one, which could be the last one.
// so even though we cannot set the caret location there, we still need to ping that location and generate proper data where the AX fails.
class The3CasesTests: ATEA_BaseTests {}


// TextFields
// only 1 cases for TF
extension The3CasesTests {
    
    func test_that_we_grab_a_correct_AccessibilityTextElement_when_the_TextField_is_empty() {
        let textInAXFocusedElement = ""
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        let accessibilityElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
        
        XCTAssertEqual(accessibilityElement?.role, .textField)
        XCTAssertEqual(accessibilityElement?.fileText.value, "")
        XCTAssertEqual(accessibilityElement?.length, 0)
        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
        XCTAssertEqual(accessibilityElement?.fullyVisibleArea, 0..<0)
        XCTAssertEqual(accessibilityElement?.currentScreenLine.value, "")
        XCTAssertEqual(accessibilityElement?.currentScreenLine.number, 1)
        XCTAssertEqual(accessibilityElement?.currentScreenLine.start, 0)
        XCTAssertEqual(accessibilityElement?.currentScreenLine.end, 0)
    }
    
}


// TextViews
extension The3CasesTests {
    
    func test_that_we_grab_a_correct_AccessibilityTextElement_when_the_TextView_is_empty() {
        let textInAXFocusedElement = ""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        let accessibilityElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
        
        XCTAssertEqual(accessibilityElement?.role, .textArea)
        XCTAssertEqual(accessibilityElement?.fileText.value, "")
        XCTAssertEqual(accessibilityElement?.length, 0)
        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
        XCTAssertEqual(accessibilityElement?.fullyVisibleArea, 0..<0)
        XCTAssertEqual(accessibilityElement?.currentScreenLine.value, "")
        XCTAssertEqual(accessibilityElement?.currentScreenLine.number, 1)
        XCTAssertEqual(accessibilityElement?.currentScreenLine.start, 0)
        XCTAssertEqual(accessibilityElement?.currentScreenLine.end, 0)
    }
    
    func test_that_we_grab_a_correct_AccessibilityTextElement_when_the_caret_is_at_the_end_of_the_TextView_on_an_EmptyLine() {
        let textInAXFocusedElement = """
it's four O eight
and i'm still having fun
😅️

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        let accessibilityElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
        
        XCTAssertEqual(accessibilityElement?.role, .textArea)
        XCTAssertEqual(accessibilityElement?.fileText.value, """
it's four O eight
and i'm still having fun
😅️

"""
        )
        XCTAssertEqual(accessibilityElement?.length, 47)
        XCTAssertEqual(accessibilityElement?.caretLocation, 47)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
        XCTAssertEqual(accessibilityElement?.fullyVisibleArea, 0..<47)
        XCTAssertEqual(accessibilityElement?.currentScreenLine.value, "")
        XCTAssertEqual(accessibilityElement?.currentScreenLine.number, 4)
        XCTAssertEqual(accessibilityElement?.currentScreenLine.start, 47)
        XCTAssertEqual(accessibilityElement?.currentScreenLine.end, 47)
    }
    
    func test_that_we_grab_a_correct_AccessibilityTextElement_when_the_caret_is_at_the_end_of_the_TextView_on_a_line_with_a_single_character() {
        let textInAXFocusedElement = """
that one bug appears when we
started working with HLM zz
visibleArea etc
.
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        let accessibilityElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
        
        XCTAssertEqual(accessibilityElement?.role, .textArea)
        XCTAssertEqual(accessibilityElement?.fileText.value, """
that one bug appears when we
started working with HLM zz
visibleArea etc
.
"""
        )
        XCTAssertEqual(accessibilityElement?.length, 74)
        XCTAssertEqual(accessibilityElement?.caretLocation, 74)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
        XCTAssertEqual(accessibilityElement?.fullyVisibleArea, 0..<74)
        XCTAssertEqual(accessibilityElement?.currentScreenLine.value, ".")
        XCTAssertEqual(accessibilityElement?.currentScreenLine.number, 6)
        XCTAssertEqual(accessibilityElement?.currentScreenLine.start, 73)
        XCTAssertEqual(accessibilityElement?.currentScreenLine.end, 74)
    }

}
