import XCTest
import AccessibilityStrategy


// see H for blah blah
class ASUI_NM_L__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1) -> AccessibilityTextElement {
        return applyMove { asNormalMode.L(times: count, on: $0) }
    }
    
}


// count
extension ASUI_NM_L__Tests {

    func test_that_it_implements_the_count_system() {
        let textInAXFocusedElement = """
 😂k so now we're
going to
have very

long lines
so that
   😂he H
and

M

and
L

can be
tested

properly!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        let accessibilityElement = applyMoveBeingTested(times: 3)
    
        XCTAssertEqual(accessibilityElement.caretLocation, 89)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "t")
        XCTAssertEqual(accessibilityElement.fullyVisibleArea, 67..<106)
    }
    
    func test_that_if_the_count_is_too_high_it_ends_up_on_the_firstNonBlank_of_the_highest_screenLine() {
        let textInAXFocusedElement = """
 😂k so now we're
going to
have very

long lines
so that
   😂he H
and

M

and
L

can be
tested

properly!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        let accessibilityElement = applyMoveBeingTested(times: 100)
    
        XCTAssertEqual(accessibilityElement.caretLocation, 67)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "a")
        XCTAssertEqual(accessibilityElement.fullyVisibleArea, 67..<106)
    }

}


// TextViews
extension ASUI_NM_L__Tests {
    
    func test_that_in_normal_setting_it_goes_to_the_firstNonBlank_of_the_lowest_screenLine() {
        let textInAXFocusedElement = """
 😂k so now we're
going to
have very

long lines
so that
   😂he H
and

M

and
L

can be
tested

properly!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.G(times: 7, on: $0) }
                
        let accessibilityElement = applyMoveBeingTested()
    
        XCTAssertEqual(accessibilityElement.caretLocation, 75)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "a")
        XCTAssertEqual(accessibilityElement.fullyVisibleArea, 0..<75)
    }
    
    func test_that_if_the_text_is_shorter_than_the_input_element_it_still_goes_to_the_lowest_screenLine_that_contains_text() {
        let textInAXFocusedElement = """
pretty
short text
  here
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
    
        XCTAssertEqual(accessibilityElement.caretLocation, 20)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "h")
        XCTAssertEqual(accessibilityElement.fullyVisibleArea, 0..<24)
    }
    
    
    func test_that_if_the_lowest_screenLine_is_an_empty_line_it_still_goes_there() {
        let textInAXFocusedElement = """
that's a lot
of shits to
test

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
    
        XCTAssertEqual(accessibilityElement.caretLocation, 30)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
        XCTAssertEqual(accessibilityElement.fullyVisibleArea, 0..<30)
    }
    
    // this one is pretty important. it tests that the screenLine(at:) and screenLine(number:) work correctly
    // in some weird edge case that combine one of the 3 Cases + the Start-At-Big-Sur Bug. this can't be tested properly in
    // ATEAdaptor UIT because the Start-At-Big-Sur Bug fails when setting a position through the AX, so we need to pretend a
    // move. very painful stuff.
    func test_that_if_the_lowest_screenLine_is_an_empty_line_it_still_goes_there2() {
        let textInAXFocusedElement = """
that's a lot
of shits to
test


"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
    
        XCTAssertEqual(accessibilityElement.caretLocation, 31)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
        XCTAssertEqual(accessibilityElement.fullyVisibleArea, 0..<31)
    }
        
    func test_that_the_text_is_not_scrolled_even_when_the_lastScreenLine_is_an_empty_line() {
        let textInAXFocusedElement = """
 😂k so now we're
going to
have very

long lines
so that
   😂he H
and

M

and
L

can be
tested

properly!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.G(times: 6, on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
    
        XCTAssertEqual(accessibilityElement.caretLocation, 74)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "\n")
        XCTAssertEqual(accessibilityElement.fullyVisibleArea, 0..<75)
    }

}
