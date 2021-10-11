import XCTest
@testable import AccessibilityStrategy


// here we test what we really receive or calculate from the Adaptor,
// we don't test the computed properties. those are tested in Unit Tests,
// ATE and ATELine
class The2CasesTests: ATEA_BaseTests {}


// TextFields
// only 1 cases for TF
extension The2CasesTests {
    
    func test_that_we_grab_a_correct_AccessibilityTextElement_when_the_TextField_is_empty() {
        let textInAXFocusedElement = ""
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        let accessibilityElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
        
        XCTAssertEqual(accessibilityElement?.role, .textField)
        // TODO: fileText to be tested somewhere? what about screenText?
        XCTAssertEqual(accessibilityElement?.fileText.value, "")
        XCTAssertEqual(accessibilityElement?.length, 0)
        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
        XCTAssertEqual(accessibilityElement?.currentScreenLine.value, "")
        XCTAssertEqual(accessibilityElement?.currentScreenLine.number, 1)
        XCTAssertEqual(accessibilityElement?.currentScreenLine.start, 0)
        XCTAssertEqual(accessibilityElement?.currentScreenLine.end, 0)
    }
    
}


// TextViews
extension The2CasesTests {
    
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
        XCTAssertEqual(accessibilityElement?.currentScreenLine.value, "")
        XCTAssertEqual(accessibilityElement?.currentScreenLine.number, 1)
        XCTAssertEqual(accessibilityElement?.currentScreenLine.start, 0)
        XCTAssertEqual(accessibilityElement?.currentScreenLine.end, 0)
    }
    
    func test_that_we_grab_a_correct_AccessibilityTextElement_when_the_caret_is_at_the_end_of_the_TextView_on_an_empty_line() {
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
        XCTAssertEqual(accessibilityElement?.currentScreenLine.value, "")
        XCTAssertEqual(accessibilityElement?.currentScreenLine.number, 4)
        XCTAssertEqual(accessibilityElement?.currentScreenLine.start, 47)
        XCTAssertEqual(accessibilityElement?.currentScreenLine.end, 47)
    }
    
}
