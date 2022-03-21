@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_H__Tests: ASUT_NM_BaseTests {

    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.H(times: count, on: element) 
    }
    
}


// scroll
extension ASUT_NM_H__Tests {
    
    func test_that_it_should_not_scroll() {
        let text = ""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 0,
            caretLocation: 0,
            selectedLength: 0,
            selectedText: """

        """,
            visibleCharacterRange: 0..<0,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 0,
                number: 1,
                start: 0,
                end: 0
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertFalse(returnedElement.shouldScroll)
    }

}


// count
extension ASUT_NM_H__Tests {

    func test_that_it_implements_the_count_system() {
        let text = """
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
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 106,
            caretLocation: 75,
            selectedLength: 1,
            selectedText: """
        a
        """,
            visibleCharacterRange: 27..<82,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 106,
                number: 12,
                start: 75,
                end: 79
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 5, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 60)
        XCTAssertEqual(returnedElement.selectedLength, 2)
    }

    func test_that_if_the_count_is_too_high_it_ends_up_on_the_firstNonBlank_of_the_lowest_screenLine() {
        let text = """
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
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 106,
            caretLocation: 72,
            selectedLength: 1,
            selectedText: """
        M
        """,
            visibleCharacterRange: 27..<82,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 106,
                number: 10,
                start: 72,
                end: 74
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 82)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }

}


// TextViews
extension ASUT_NM_H__Tests {

    func test_that_in_normal_setting_it_goes_to_the_firstNonBlank_of_the_highest_screenLine() {
        let text = """
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
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 106,
            caretLocation: 75,
            selectedLength: 1,
            selectedText: """
        a
        """,
            visibleCharacterRange: 27..<82,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 106,
                number: 12,
                start: 75,
                end: 79
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 27)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }

}
