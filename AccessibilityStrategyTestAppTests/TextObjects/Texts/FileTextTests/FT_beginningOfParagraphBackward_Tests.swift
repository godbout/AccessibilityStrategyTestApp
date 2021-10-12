@testable import AccessibilityStrategy
import XCTest


class FT_beginningOfParagraphBackward_Tests: XCTestCase {}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension FT_beginningOfParagraphBackward_Tests {
    
    func test_that_if_the_text_is_empty_then_it_returns_0() {
        let text = ""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfParagraphBackwardLocation = fileText.beginningOfParagraphBackward(startingAt: 0)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 0)
    }
    
    func test_that_if_the_caret_is_after_the_last_character_on_an_empty_line_then_it_still_goes_to_the_beginning_of_the_paragraph() {
        let text = """
a couple of


lines but not
coke haha but
with linefeed

"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
       	let beginningOfParagraphBackwardLocation = fileText.beginningOfParagraphBackward(startingAt: 56)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 13)
    }
    
}


// Both
extension FT_beginningOfParagraphBackward_Tests {
    
    func test_that_if_the_text_does_not_have_linefeed_then_it_stops_at_the_beginning_of_the_text() {
        let text = "like a TextField really"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfParagraphBackwardLocation = fileText.beginningOfParagraphBackward(startingAt: 19)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 0)
    }
    
}

// TextFields
extension FT_beginningOfParagraphBackward_Tests {
    
    func test_that_it_can_go_to_the_beginning_of_the_current_paragraph() {
        let text = """
some poetry
that is beautiful

and some more blah blah
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfParagraphBackwardLocation = fileText.beginningOfParagraphBackward(startingAt: 42)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 30)
    }
    
    func test_that_if_the_caret_is_already_on_an_empty_line_it_skips_all_the_consecutive_empty_lines() {
        let text = """
other hello

hello



some more
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfParagraphBackwardLocation = fileText.beginningOfParagraphBackward(startingAt: 21)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 12)
    }
    
    func test_that_if_it_does_not_find_an_empty_line_it_stops_at_the_beginning_of_the_text() {
        let text = """
this
text
does not have
an empty line!
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfParagraphBackwardLocation = fileText.beginningOfParagraphBackward(startingAt: 23)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 0)
    }
    
    func test_that_it_does_not_crash_if_the_location_is_on_the_first_line_which_is_a_linefeed() {
        let text = """

hehe first line
is a linefeed
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfParagraphBackwardLocation = fileText.beginningOfParagraphBackward(startingAt: 0)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 0)
    }
    
    func test_that_it_does_not_crash_if_the_location_is_at_the_end_of_the_text() {
        let text = """
yes this can happen when the

caret is after the last character
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfParagraphBackwardLocation = fileText.beginningOfParagraphBackward(startingAt: 63)
        
		XCTAssertEqual(beginningOfParagraphBackwardLocation, 29)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FT_beginningOfParagraphBackward_Tests {
    
    func test_that_it_handles_emojis() {
        let text = """
yes 🐰️🐰️🐰️🐰️ this can happen🐰️🐰️ when the



🐰️🐰️car🐰️et is after the last character🐰️🐰️🐰️
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let beginningOfParagraphBackwardLocation = fileText.beginningOfParagraphBackward(startingAt: 96)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 50)
    }
    
}
