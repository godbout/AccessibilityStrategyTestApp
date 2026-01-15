@testable import AccessibilityStrategy
import XCTest


// here only the simple cp are tested. the more complicated ones, or the funcs are tested
// on their own.
class FL_SimpleComputedProperties_Tests: XCTestCase {}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension FL_SimpleComputedProperties_Tests {
    
    func test_that_if_the_text_is_empty_the_computed_properties_are_corret() throws {
        let text = ""
        
        let fileLine = FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 0)
                
        XCTAssertEqual(fileLine?.number, 1)
        XCTAssertEqual(fileLine?.start, 0)
        XCTAssertEqual(fileLine?.end, 0)
        XCTAssertEqual(fileLine?.value, "")
        XCTAssertEqual(fileLine?.endLimit, 0)
        XCTAssertEqual(fileLine?.length, 0)
        XCTAssertEqual(fileLine?.lengthWithoutLinefeed, 0)
        XCTAssertEqual(fileLine?.isTheFirstLine, true)
        XCTAssertEqual(fileLine?.isNotTheFirstLine, false)
        XCTAssertEqual(fileLine?.isTheLastLine, true)
        XCTAssertEqual(fileLine?.isNotTheLastLine, false)
    }

    func test_that_if_the_caret_is_at_the_end_of_the_text_on_its_own_empty_line_the_computed_properties_are_correct() throws {
        let text = """
caret is on its
own empty 🌬️
line

"""
        let fileLine = FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 35)

        XCTAssertEqual(fileLine?.number, 4)
        XCTAssertEqual(fileLine?.start, 35)
        XCTAssertEqual(fileLine?.end, 35)
        XCTAssertEqual(fileLine?.value, "")
        XCTAssertEqual(fileLine?.endLimit, 35)
        XCTAssertEqual(fileLine?.length, 0)
        XCTAssertEqual(fileLine?.lengthWithoutLinefeed, 0)
        XCTAssertEqual(fileLine?.isTheFirstLine, false)
        XCTAssertEqual(fileLine?.isNotTheFirstLine, true)
        XCTAssertEqual(fileLine?.isTheLastLine, true)
        XCTAssertEqual(fileLine?.isNotTheLastLine, false)
    }

}


// other cases
extension FL_SimpleComputedProperties_Tests {
    
    func test_that_if_the_caretLocation_is_negative_the_init_fails() {
        let text = "hehe failable initializer hehe"
        
        XCTAssertNil(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: -69)
        )        
    }
    
    func test_that_if_the_caretLocation_is_incorrect_the_init_fails() {
        let text = "hehe failable initializer hehe"
        
        XCTAssertNil(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 6969)
        )        
    }

    func test_that_for_a_file_line_that_ends_with_a_linefeed_the_computed_properties_are_correct() throws {
        let text = """
now i'm a line 📏️📏️📏️ with 📏️
a linefeed 🤱️
"""
        let fileLine = FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 27)

        XCTAssertEqual(fileLine?.number, 1)
        XCTAssertEqual(fileLine?.start, 0)
        XCTAssertEqual(fileLine?.end, 34)
        XCTAssertEqual(fileLine?.value, "now i'm a line 📏️📏️📏️ with 📏️\n")
        XCTAssertEqual(fileLine?.endLimit, 30)
        XCTAssertEqual(fileLine?.length, 34)
        XCTAssertEqual(fileLine?.lengthWithoutLinefeed, 33)
        XCTAssertEqual(fileLine?.isTheFirstLine, true)
        XCTAssertEqual(fileLine?.isNotTheFirstLine, false)
        XCTAssertEqual(fileLine?.isTheLastLine, false)
        XCTAssertEqual(fileLine?.isNotTheLastLine, true)
    }

    func test_that_for_a_file_line_that_does_not_end_with_a_linefeed_the_computed_properties_are_correct() throws {
        let text = """
here we go baby 👶️👶️👶️
fucking 🔥️🔥️🔥️ hell
"""
        let fileLine = FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 29)
    
        XCTAssertEqual(fileLine?.number, 2)
        XCTAssertEqual(fileLine?.start, 26)
        XCTAssertEqual(fileLine?.end, 48)
        XCTAssertEqual(fileLine?.value, "fucking 🔥️🔥️🔥️ hell")
        XCTAssertEqual(fileLine?.endLimit, 47)
        XCTAssertEqual(fileLine?.length, 22)
        XCTAssertEqual(fileLine?.lengthWithoutLinefeed, 22)
        XCTAssertEqual(fileLine?.isTheFirstLine, false)
        XCTAssertEqual(fileLine?.isNotTheFirstLine, true)
        XCTAssertEqual(fileLine?.isTheLastLine, true)
        XCTAssertEqual(fileLine?.isNotTheLastLine, false)
    }

    // it may look like it's missing a case where an empty line does not end with a linefeed
    // but this is already tested in the last of The 3 Cases. hehe.
    func test_that_for_an_empty_line_that_ends_with_a_linefeed_the_computed_properties_are_correct() throws {
        let text = """
the next line 📏️ will be empty

and there's that one 🤌🏼️ line after
"""
        let fileLine = FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 32)

        XCTAssertEqual(fileLine?.number, 2)
        XCTAssertEqual(fileLine?.start, 32)
        XCTAssertEqual(fileLine?.end, 33)
        XCTAssertEqual(fileLine?.value, "\n")
        XCTAssertEqual(fileLine?.endLimit, 32)
        XCTAssertEqual(fileLine?.length, 1)
        XCTAssertEqual(fileLine?.lengthWithoutLinefeed, 0)
        XCTAssertEqual(fileLine?.isTheFirstLine, false)
        XCTAssertEqual(fileLine?.isNotTheFirstLine, true)
        XCTAssertEqual(fileLine?.isTheLastLine, false)
        XCTAssertEqual(fileLine?.isNotTheLastLine, true)
    }
    
    // middle line has a lot of spaces!
    func test_that_for_a_BlankLine_that_ends_with_a_linefeed_the_computed_properties_are_correct() throws {
        let text = """
the next like appears empty but it's actually blank!!!
                  
so careful that Xcode doesn't remove the fucking blanks.
"""
        let fileLine = FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: 58)

        XCTAssertEqual(fileLine?.number, 2)
        XCTAssertEqual(fileLine?.start, 55)
        XCTAssertEqual(fileLine?.end, 74)
        XCTAssertEqual(fileLine?.value, "                  \n")
        XCTAssertEqual(fileLine?.endLimit, 72)
        XCTAssertEqual(fileLine?.length, 19)
        XCTAssertEqual(fileLine?.lengthWithoutLinefeed, 18)
        XCTAssertEqual(fileLine?.isTheFirstLine, false)
        XCTAssertEqual(fileLine?.isNotTheFirstLine, true)
        XCTAssertEqual(fileLine?.isTheLastLine, false)
        XCTAssertEqual(fileLine?.isNotTheLastLine, true)
    }

}
