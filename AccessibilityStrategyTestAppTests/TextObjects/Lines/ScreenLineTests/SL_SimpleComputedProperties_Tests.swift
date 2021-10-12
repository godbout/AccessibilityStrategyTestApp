@testable import AccessibilityStrategy
import XCTest


class SL_SimpleComputerProperties_Tests: XCTestCase {}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension SL_SimpleComputerProperties_Tests {
    
    func test_that_if_the_text_is_empty_the_computed_properties_are_corret() {
        let text = ""
        
        let screenLine = ScreenLine(fullTextValue: text, fullTextLength: text.utf16.count, number: 1, start: 0, end: 0)

        XCTAssertEqual(screenLine?.start, 0)
        XCTAssertEqual(screenLine?.end, 0)
        XCTAssertEqual(screenLine?.value, "")
        XCTAssertEqual(screenLine?.endLimit, 0)
        XCTAssertEqual(screenLine?.firstNonBlankLimit, 0)
    }
    
    func test_that_if_the_caret_is_at_the_end_of_the_text_on_its_own_empty_line_the_computed_properties_are_correct() {
        let text = """
caret is on its
own empty 🌬️
line

"""
       let screenLine = ScreenLine(fullTextValue: text, fullTextLength: text.utf16.count, number: 5, start: 35, end: 35)
        
        XCTAssertEqual(screenLine?.start, 35)
        XCTAssertEqual(screenLine?.end, 35)
        XCTAssertEqual(screenLine?.value, "")
        XCTAssertEqual(screenLine?.endLimit, 35)
        XCTAssertEqual(screenLine?.firstNonBlankLimit, 35)
    }
    
}


// other cases
extension SL_SimpleComputerProperties_Tests {
    
    func test_that_for_a_screen_line_that_ends_with_a_linefeed_the_computed_properties_are_correct() {
        let text = """
now i'm a line 📏️📏️📏️ with 📏️
a linefeed 🤱️
"""
        let screenLine = ScreenLine(fullTextValue: text, fullTextLength: text.utf16.count, number: 2, start: 21, end: 34)

        XCTAssertEqual(screenLine?.start, 21)
        XCTAssertEqual(screenLine?.end, 34)
        XCTAssertEqual(screenLine?.value, "📏️ with 📏️\n")
        XCTAssertEqual(screenLine?.endLimit, 30)
        XCTAssertEqual(screenLine?.firstNonBlankLimit, 21)
    }

    func test_that_for_a_screen_line_that_does_not_end_with_a_linefeed_the_computed_properties_are_correct() {
        let text = """
here we go baby 👶️👶️👶️
fucking 🔥️🔥️🔥️ hell
"""        
        let screenLine = ScreenLine(fullTextValue: text, fullTextLength: text.utf16.count, number: 3, start: 26, end: 44)
        
        XCTAssertEqual(screenLine?.start, 26)
        XCTAssertEqual(screenLine?.end, 44)
        XCTAssertEqual(screenLine?.value, "fucking 🔥️🔥️🔥️ ")
        XCTAssertEqual(screenLine?.endLimit, 43)
        XCTAssertEqual(screenLine?.firstNonBlankLimit, 26)
    }
    
    func test_that_for_an_empty_line_that_ends_with_a_linefeed_the_computed_properties_are_correct() {
        let text = """
the next line 📏️ will be empty

and there's that one 🤌🏼️ line after
"""       
        let screenLine = ScreenLine(fullTextValue: text, fullTextLength: text.utf16.count, number: 3, start: 32, end: 33)
        
        XCTAssertEqual(screenLine?.start, 32)
        XCTAssertEqual(screenLine?.end, 33)
        XCTAssertEqual(screenLine?.value, "\n")
        XCTAssertEqual(screenLine?.endLimit, 32)
        XCTAssertEqual(screenLine?.firstNonBlankLimit, 32)
    }
    
}
