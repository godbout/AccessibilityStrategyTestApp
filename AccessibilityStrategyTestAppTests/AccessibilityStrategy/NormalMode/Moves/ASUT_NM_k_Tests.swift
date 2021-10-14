import XCTest
import AccessibilityStrategy


class ASUT_NM_k_Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.k(on: element) 
    }
    
}


// line
extension ASUT_NM_k_Tests {
    
    func test_conspicuously_that_it_works_with_FileLines() {
        let text = """
this move works with FileLiens, not ScreenLines.
it eats them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 110,
            caretLocation: 90,
            selectedLength: 1,
            selectedText: "s",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 110,
                number: 2,
                start: 49,
                end: 110
            )!
        )
        
        AccessibilityTextElement.globalColumnNumber = 6
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 41)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
     
}


// TextFields
extension ASUT_NM_k_Tests {
    
    func test_that_for_TextFields_k_returns_nil_coz_we_want_the_KS_to_take_over() {
        let text = "k on a TextField shouldn't use the AS! think Alfred"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 51,
            caretLocation: 36,
            selectedLength: 1,
            selectedText: "S",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 51,
                number: 1,
                start: 0,
                end: 51
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertNil(returnedElement)
    }
    
}


// TextViews
extension ASUT_NM_k_Tests {

    func test_that_in_normal_setting_k_goes_to_the_previous_line_at_the_same_column() {
        let text = """
so now we're
testing k and
it should go up
to the same column
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 61,
            caretLocation: 55,
            selectedLength: 1,
            selectedText: "c",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 61,
                number: 7,
                start: 55,
                end: 61
            )!
        )
        
        AccessibilityTextElement.globalColumnNumber = 1

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 39)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
    }

    func test_that_if_the_previous_line_is_shorter_k_goes_to_the_end_of_line_limit_of_that_previous_line() {
        let text = """
a line
shorter than
the previous shorter
than the previous shorter than...
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 74,
            caretLocation: 71,
            selectedLength: 1,
            selectedText: ".",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 74,
                number: 8,
                start: 67,
                end: 74
            )!
        )
        
        AccessibilityTextElement.globalColumnNumber = 5

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 39)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
    }

    func test_that_the_column_number_is_saved_and_reapplied_properly() {
        let text = """
first one is prettyyyyy long too
a pretty long line i would believe
a shorter line
another quite long line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 106,
            caretLocation: 101,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 106,
                number: 11,
                start: 91,
                end: 102
            )!
        )
        
        AccessibilityTextElement.globalColumnNumber = 11
                        
        let firstK = applyMoveBeingTested(on: element)
        XCTAssertEqual(firstK?.caretLocation, 81)
        XCTAssertEqual(firstK?.selectedLength, 1)

        let secondK = applyMoveBeingTested(on: firstK)
        XCTAssertEqual(secondK?.caretLocation, 51)
        XCTAssertEqual(secondK?.selectedLength, 1)

        let thirdK = applyMoveBeingTested(on: secondK)
        XCTAssertEqual(thirdK?.caretLocation, 18)
        XCTAssertEqual(thirdK?.selectedLength, 1)
    }

    func test_that_when_at_the_first_line_k_does_nothing() {
        let text = """
a the first line
k should do
nothing ankulay
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 44,
            caretLocation: 0,
            selectedLength: 1,
            selectedText: "a",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 1,
                start: 0,
                end: 12
            )!
        )
    
        AccessibilityTextElement.globalColumnNumber = 1
    
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 0)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
    }

    func test_that_when_current_line_column_is_equal_to_previous_line_length_the_caret_ends_up_at_the_right_previous_line_end_limit() {
        let text = """
weird bug when
current line column
is equal
to previ ous line length
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 68,
            caretLocation: 51,
            selectedLength: 1,
            selectedText: "i",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 68,
                number: 6,
                start: 44,
                end: 57
            )!
        )
        
        AccessibilityTextElement.globalColumnNumber = 8

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 42)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
    }

    func test_that_if_we_are_on_the_last_line_and_it_is_just_a_linefeed_we_can_still_go_up_and_follow_the_globalColumnNumber() {
        let text = """
fucking hell
with the last line
empty

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 38,
            caretLocation: 38,
            selectedLength: 0,
            selectedText: "",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 38,
                number: 5,
                start: 38,
                end: 38
            )!
        )
                
        AccessibilityTextElement.globalColumnNumber = 3
    
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 34)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
    }
    
    func test_that_if_the_ATE_globalColumnNumber_is_nil_k_goes_to_the_end_limit_of_the_previous_line() {
        let text = """
and also to the end of the next next line!
coz used $ to go end of line📏️
globalColumnNumber is nil
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 100,
            caretLocation: 99,
            selectedLength: 1,
            selectedText: "l",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 100,
                number: 10,
                start: 97,
                end: 100
            )!
        )
        
        AccessibilityTextElement.globalColumnNumber = nil

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 71)
        XCTAssertEqual(returnedElement?.selectedLength, 3)
        
        let secondPass = applyMoveBeingTested(on: returnedElement)
                
        XCTAssertEqual(secondPass?.caretLocation, 41)
        XCTAssertEqual(secondPass?.selectedLength, 1)
    }
    
}


// emojis
// see j for blah blah
extension ASUT_NM_k_Tests {}
