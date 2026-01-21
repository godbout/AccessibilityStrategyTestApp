@testable import AccessibilityStrategy
import XCTest


class FT_endOfParagraphForward_NormalSetting_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Int {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.endOfParagraphForward(startingAt: caretLocation)
    }
    
}


// TextFields and TextViews
extension FT_endOfParagraphForward_NormalSetting_Tests {
    
    func test_that_if_there_is_no_Newline_at_all_then_it_stops_before_the_last_character() {
        let text = "like a TextField really"

        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 2)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 22)
    }
    
}


// TextViews
// basic
extension FT_endOfParagraphForward_NormalSetting_Tests {
    
    func test_that_if_there_is_no_EmptyLine_at_all_then_it_stops_before_the_last_character() {
        let text = """
so here we have
a bunch of lines one after
the other but no EmptyLine!
"""
        
        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 14)

        XCTAssertEqual(endOfParagraphForwardLocation, 69)
    }
    
}


// TextViews
// surrounded by EmptyLines
extension FT_endOfParagraphForward_NormalSetting_Tests {
    
    func test_that_it_stops_at_the_EmptyLine_just_below_the_text_if_there_is_only_one_EmptyLine() {
        let text = """
some poetry
that is beautiful

and some more blah blah
"""
        
        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 6)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 30)
    }
    
    func test_that_it_stops_at_the_EmptyLine_just_below_the_text_if_there_are_several_consecutive_EmptyLines() {
        let text = """
some poetry
that is beautiful




and some more blah blah
"""
        
        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 6)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 30)
    }
    
    func test_that_it_stops_at_the_first_end_of_paragraph_found_and_not_at_others_down_the_text() {
        let text = """
some poetry
that is beautiful


and some more blah blah


some more paragraphs!
"""
        
        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 6)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 30)
    }
    
}


// TextViews
// surrounded by BlankLines
extension FT_endOfParagraphForward_NormalSetting_Tests {
    
    func test_that_it_skips_BlankLines() {
        let text = """
below is a blank line
          
 below is an empty line

   for example it
   it should go to the empty line
   no the lines above
"""
        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 17)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 57)
    }
    
    func test_that_it_skips_multiple_BlankLines() {
        let text = """
  it.    shoud
   
  
   
     
  go up. directly

hehe
""" 
        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 7)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 50)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FT_endOfParagraphForward_NormalSetting_Tests {
    
    func test_that_it_handles_emojis() {
        let text = """
yes 🐰️🐰️🐰️🐰️ this can happen🐰️🐰️ when the



🐰️🐰️car🐰️et is after the last character🐰️🐰️🐰️
"""
        
        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 13)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 48)
    }
    
}
