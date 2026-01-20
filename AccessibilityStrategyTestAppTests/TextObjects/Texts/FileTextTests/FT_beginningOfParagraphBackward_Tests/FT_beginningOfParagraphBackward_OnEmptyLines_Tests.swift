@testable import AccessibilityStrategy
import XCTest


class FT_beginningOfParagraphBackward_OnEmptyLines_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Int {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.beginningOfParagraphBackward(startingAt: caretLocation)
    }

}


// TextFields and TextViews
extension FT_beginningOfParagraphBackward_OnEmptyLines_Tests {
    
    func test_that_if_the_text_is_empty_then_it_returns_0() {
        let text = ""
        
        let beginningOfParagraphBackwardLocation = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 0)
    }
    
}


// TextViews
// basic
extension FT_beginningOfParagraphBackward_OnEmptyLines_Tests {
    
    func test_that_if_the_caret_is_after_the_last_character_on_an_EmptyLine_then_it_still_goes_to_the_beginning_of_the_paragraph() {
        let text = """
a couple of


lines but not
coke haha but
with linefeed

"""
        
        let beginningOfParagraphBackwardLocation = applyFuncBeingTested(on: text, startingAt: 56)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 13)
    }
    
    func test_that_it_does_not_crash_if_the_location_is_on_the_first_line_which_is_a_linefeed() {
        let text = """

hehe first line
is a linefeed
"""
        
        let beginningOfParagraphBackwardLocation = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 0)
    }
        
    func test_that_it_does_not_get_stuck_at_a_NonEmptyLine() {
        let text = """
so here's some text
and more

and now the next NonEmptyLine

and above an EL!
"""
        
        let beginningOfParagraphBackwardLocation = applyFuncBeingTested(on: text, startingAt: 72)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 60)
    }
    
    func test_that_it_does_not_get_stuck_at_multiple_NonEmptyLines() {
        let text = """
so here's some text
and more

and now the next NonEmptyLines
and now the next NonEmptyLines
and now the next NonEmptyLines


hehe
hoho
last line hehe
"""
        
        let beginningOfParagraphBackwardLocation = applyFuncBeingTested(on: text, startingAt: 132)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 124)
    }
    
    func test_that_it_stops_at_the_first_beginning_of_paragraph_found_and_not_at_others_up_the_text() {
        let text = """
some poetry
that is beautiful


and some more blah blah

some more paragraphs!

hehe!
hoho
"""
        
        let beginningOfParagraphBackwardLocation = applyFuncBeingTested(on: text, startingAt: 79)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 56)
    }
    
}


// TextViews
// surrounded by EmptyLines
extension FT_beginningOfParagraphBackward_OnEmptyLines_Tests {
    
    func test_that_if_the_caret_is_at_the_beginning_on_an_EmptyLine_then_it_does_not_move() {
        let text = """

a couple of
lines but not
coke haha but
with linefeed
"""
        
        let beginningOfParagraphBackwardLocation = applyFuncBeingTested(on: text, startingAt: 54)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 0)
    }
        
    func test_that_if_the_caret_is_on_an_EmptyLine_and_it_is_all_EmptyLines_up_to_the_beginning_then_it_goes_to_the_beginning() {
        let text = """





a couple of
lines but not
coke haha but
with linefeed
"""
        
        let beginningOfParagraphBackwardLocation = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 0)
    }
    
    func test_that_if_the_caret_is_already_on_an_EmptyLine_it_skips_all_the_previous_consecutive_EmptyLines() {
        let text = """
other hello

hello



some more
"""
        
        let beginningOfParagraphBackwardLocation = applyFuncBeingTested(on: text, startingAt: 20)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 12)
    }
        
    func test_that_if_the_caret_is_already_on_an_EmptyLine_and_it_is_all_EmptyLines_up() {
        let text = """
other hello

hello



some more
"""
        
        let beginningOfParagraphBackwardLocation = applyFuncBeingTested(on: text, startingAt: 20)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 12)
    }
    
}


// TextViews
// surrounded by BlankLines
extension FT_beginningOfParagraphBackward_OnEmptyLines_Tests {
    
    func test_that_if_the_caret_is_already_on_an_EmptyLine_it_skips_all_the_consecutive_BlankLines() {
        let text = """
two ELs below then BLs


           
         
          

one EL above
hehe
"""

        let beginningOfParagraphBackwardLocation = applyFuncBeingTested(on: text, startingAt: 58)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 24)
    }

}
