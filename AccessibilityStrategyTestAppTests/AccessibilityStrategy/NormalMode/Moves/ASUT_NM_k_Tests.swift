import XCTest
import AccessibilityStrategy


// see j for blah blah
class ASUT_NM_k_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.k(times: count, on: element) 
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
            fullyVisibleArea: 0..<110,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 110,
                number: 2,
                start: 49,
                end: 110
            )!
        )
        
        AccessibilityTextElement.fileLineColumnNumber = 42
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 41)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
     
}


// count
extension ASUT_NM_k_Tests {
    
    func test_that_it_implements_the_count_system() {
        let text = """
ok so this is j which means it's gonna work with file lines and not screen lines
which means we better have long lines here
else it's gonna sc😂️ew up the tests etc etc etc etc 
etc etc etc etc etc etc etc etc etc etc etc etc
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 225,
            caretLocation: 190,
            selectedLength: 1,
            selectedText: "n",
            fullyVisibleArea: 0..<225,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 225,
                number: 4,
                start: 124,
                end: 178
            )!
        )
        
        AccessibilityTextElement.fileLineColumnNumber = 13
                
        let returnedElement = applyMoveBeingTested(times: 2, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 93)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_count_is_too_high_it_ends_up_on_the_first_line() {
        let text = """
ok so this is j which means it's gonna work with file lines and not screen lines
which means we better have long lines here
else it's gonna sc😂️ew up the tests etc etc etc etc 
etc etc etc etc etc etc etc etc etc etc etc etc
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 225,
            caretLocation: 78,
            selectedLength: 1,
            selectedText: "e",
            fullyVisibleArea: 0..<225,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 225,
                number: 2,
                start: 60,
                end: 81
            )!
        )
        
        AccessibilityTextElement.fileLineColumnNumber = 13
                
        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 12)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// TextFields
// see j for blah blah


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
            fullyVisibleArea: 0..<61,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 61,
                number: 7,
                start: 55,
                end: 61
            )!
        )
        
        AccessibilityTextElement.fileLineColumnNumber = 13

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 39)
        XCTAssertEqual(returnedElement.selectedLength, 1)
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
            fullyVisibleArea: 0..<74,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 74,
                number: 8,
                start: 67,
                end: 74
            )!
        )
        
        AccessibilityTextElement.fileLineColumnNumber = 31

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 39)
        XCTAssertEqual(returnedElement.selectedLength, 1)
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
            fullyVisibleArea: 0..<44,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 1,
                start: 0,
                end: 12
            )!
        )
    
        AccessibilityTextElement.fileLineColumnNumber = 1
    
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 1)
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
            fullyVisibleArea: 0..<68,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 68,
                number: 6,
                start: 44,
                end: 57
            )!
        )
        
        AccessibilityTextElement.fileLineColumnNumber = 8

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 42)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }

    func test_that_if_we_are_on_the_last_line_and_it_is_just_a_linefeed_we_can_still_go_up_and_follow_the_fileLineColumnNumber() {
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
            fullyVisibleArea: 0..<38,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 38,
                number: 5,
                start: 38,
                end: 38
            )!
        )
                
        AccessibilityTextElement.fileLineColumnNumber = 3
    
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 34)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }
    
    func test_that_if_the_ATE_fileLineColumnNumber_is_nil_k_goes_to_the_end_limit_of_the_previous_line() {
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
            fullyVisibleArea: 0..<100,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 100,
                number: 10,
                start: 97,
                end: 100
            )!
        )
        
        AccessibilityTextElement.fileLineColumnNumber = nil

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 71)
        XCTAssertEqual(returnedElement.selectedLength, 3)
    }
    
}


// emojis
// see j for blah blah
extension ASUT_NM_k_Tests {}
