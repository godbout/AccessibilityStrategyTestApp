import XCTest
import AccessibilityStrategy


// most of the tests are done here in UT, but we have to provide the fileLineColumnNumber
// we have one test in UI that calls the move several time to make sure that the fileLineColumnNumber
// is updated properly and that ultimately it works.
// coz else, those tests will pass whether the move is using ScreenLines or FileLines LMAO
class ASUT_NM_j_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.j(times: count, on: element) 
    }
    
}


// line
extension ASUT_NM_j_Tests {
    
    func test_conspicuously_that_it_works_with_FileLines() {
        let text = """
this move works with FileLiens, not ScreenLines.
it eats them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 110,
            caretLocation: 13,
            selectedLength: 1,
            selectedText: "k",
            fullyVisibleArea: 0..<110,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 110,
                number: 2,
                start: 10,
                end: 21
            )!
        )
        
        AccessibilityTextElement.fileLineColumnNumber = 14
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 62)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
     
}


// count
extension ASUT_NM_j_Tests {
    
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
        
        AccessibilityTextElement.fileLineColumnNumber = 19
                
        let returnedElement = applyMoveBeingTested(times: 2, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 142)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_count_is_too_high_it_ends_up_on_the_last_line() {
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
        
        AccessibilityTextElement.fileLineColumnNumber = 19
                
        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 196)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}


// TextFields
// Alfred style stuff is handled and tested in kVE now


// TextViews
extension ASUT_NM_j_Tests {

    func test_that_in_normal_setting_j_goes_to_the_next_line_at_the_same_column() {
        let text = """
let the fun begin
with the new jk that
works on FileLines rather
than ScreenLines
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 81,
            caretLocation: 31,
            selectedLength: 1,
            selectedText: "j",
            fullyVisibleArea: 0..<81,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 81,
                number: 4,
                start: 31,
                end: 39
            )!
        )
        
        AccessibilityTextElement.fileLineColumnNumber = 14
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 52)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }

    func test_that_if_the_next_line_is_shorter_j_goes_to_the_end_of_line_limit_of_that_next_line() {
        let text = """
a line
but this one is much longer
and this one shorter
let's see
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 65,
            caretLocation: 31,
            selectedLength: 1,
            selectedText: "g",
            fullyVisibleArea: 0..<65,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 65,
                number: 4,
                start: 28,
                end: 35
            )!
        )
        
        AccessibilityTextElement.fileLineColumnNumber = 25

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 54)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }

    func test_that_when_at_the_last_line_j_does_nothing() {
        let text = """
at the last line j should shut
up and do absolutely
nothing else AR💣️H
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 71,
            caretLocation: 67,
            selectedLength: 3,
            selectedText: "💣️",
            fullyVisibleArea: 0..<71,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 71,
                number: 7,
                start: 65,
                end: 71
            )!
        )
        
        AccessibilityTextElement.fileLineColumnNumber = 16

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 67)
        XCTAssertEqual(returnedElement.selectedLength, 3)
    }
    
    func test_that_when_the_current_line_column_is_equal_to_the_next_line_length_and_that_this_line_is_not_the_last_one_the_caret_gets_at_the_correct_end_limit_of_the_next_line() {
        let text = """
tryig somethi hehe wrap
some more hehe wrap
again hehe wrap
hehe hehe
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 69,
            caretLocation: 38,
            selectedLength: 1,
            selectedText: " ",
            fullyVisibleArea: 0..<69,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 69,
                number: 5,
                start: 34,
                end: 44
            )!
        )
        
        AccessibilityTextElement.fileLineColumnNumber = 15
               
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 58)
        XCTAssertEqual(returnedElement.selectedLength, 1)
    }

    func test_that_if_the_last_line_is_only_a_linefeed_character_j_can_still_go_there_and_the_fileLineColumnNumber_is_not_overriden() {
        let text = """
another fucking
edge case

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 26,
            caretLocation: 19,
            selectedLength: 1,
            selectedText: "e",
            fullyVisibleArea: 0..<26,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 26,
                number: 3,
                start: 16,
                end: 26
            )!
        )
        
        let fileLineColumnNumber = AccessibilityTextElement.fileLineColumnNumber
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 26)
        XCTAssertEqual(returnedElement.selectedLength, 0)
        XCTAssertEqual(fileLineColumnNumber, AccessibilityTextElement.fileLineColumnNumber)
    }
    
    func test_that_if_the_ATE_fileLineColumnNumber_is_nil_j_goes_to_the_end_limit_of_the_next_line() {
        let text = """
globalColumnNumber is nil
coz used $ to go end of line📏️
and also to the end of the next next line!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 100,
            caretLocation: 24,
            selectedLength: 1,
            selectedText: "l",
            fullyVisibleArea: 0..<100,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 100,
                number: 3,
                start: 22,
                end: 26
            )!
        )
        
        AccessibilityTextElement.fileLineColumnNumber = nil

        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 54)
        XCTAssertEqual(returnedElement.selectedLength, 3)
    }
    
}


// emojis
// unfortunately for now we not gonna test for j and k because i don't know how to handle
// with the fileLineColumnNumber
extension ASUT_NM_j_Tests {}
