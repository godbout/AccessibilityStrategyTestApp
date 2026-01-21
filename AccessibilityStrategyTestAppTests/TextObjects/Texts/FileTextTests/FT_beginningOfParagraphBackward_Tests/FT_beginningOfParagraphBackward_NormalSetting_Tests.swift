@testable import AccessibilityStrategy
import XCTest


class FT_beginningOfParagraphBackward_NormalSetting_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Int {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.beginningOfParagraphBackward(startingAt: caretLocation)
    }

}


// TextFields and TextViews
extension FT_beginningOfParagraphBackward_NormalSetting_Tests {
    
    func test_that_if_there_is_no_Newline_at_all_then_it_stops_before_the_first_character() {
        let text = "like a TextField really"
        
        let beginningOfParagraphBackwardLocation = applyFuncBeingTested(on: text, startingAt: 19)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 0)
    }
    
}


// TextViews
// basic
extension FT_beginningOfParagraphBackward_NormalSetting_Tests {
    
    func test_that_if_there_is_no_EmptyLine_at_all_then_it_stops_before_the_first_character() {
        let text = """
so here we have
a bunch of lines one after
the other but no EmptyLine!
"""
        
        let beginningOfParagraphBackwardLocation = applyFuncBeingTested(on: text, startingAt: 14)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 0)
    }
    
}


// TextViews
// surrounded by EmptyLines
extension FT_beginningOfParagraphBackward_NormalSetting_Tests {

    func test_that_it_stops_at_the_EmptyLine_just_above_the_text_if_there_is_only_one_EmptyLine() {
        let text = """
some poetry
that is beautiful

and some more blah blah
"""
        
        let beginningOfParagraphBackwardLocation = applyFuncBeingTested(on: text, startingAt: 42)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 30)
    }
    
    func test_that_it_stops_at_the_EmptyLine_just_below_the_text_if_there_are_several_consecutive_EmptyLines() {
        let text = """
some poetry
that is beautiful




and some more blah blah
"""
        
        let beginningOfParagraphBackwardLocation = applyFuncBeingTested(on: text, startingAt: 46)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 33)
    }
    
    func test_that_it_stops_at_the_first_beginning_of_paragraph_found_and_not_at_others_up_the_text() {
        let text = """
some poetry
that is beautiful


and some more blah blah


some more paragraphs!
"""
        
        let beginningOfParagraphBackwardLocation = applyFuncBeingTested(on: text, startingAt: 66)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 57)
    }
    
    func test_that_it_does_not_crash_if_the_location_is_at_the_end_of_the_text() {
        let text = """
yes this can happen when the

caret is after the last character
"""
        
        let beginningOfParagraphBackwardLocation = applyFuncBeingTested(on: text, startingAt: 63)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 29)
    }
    
}


// TextViews
// surrounded by BlankLines
extension FT_beginningOfParagraphBackward_NormalSetting_Tests {
    
    func test_that_it_skips_BlankLines() {
        let text = """
below is a empty line

 below is an blank line
         
   for example it
   it should go to the empty line
   no the lines above
"""
        
        let beginningOfParagraphBackwardLocation = applyFuncBeingTested(on: text, startingAt: 85)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 22)
    }
    
    func test_that_it_skips_multiple_BlankLines() {
        let text = """
first line and below EL

  that's funky
   
  
   
     
  go up. directly
"""
        
        let beginningOfParagraphBackwardLocation = applyFuncBeingTested(on: text, startingAt: 68)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 24)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FT_beginningOfParagraphBackward_NormalSetting_Tests {
    
    func test_that_it_handles_emojis() {
        let text = """
yes 🐰️🐰️🐰️🐰️ this can happen🐰️🐰️ when the



🐰️🐰️car🐰️et is after the last character🐰️🐰️🐰️
"""
        
        let beginningOfParagraphBackwardLocation = applyFuncBeingTested(on: text, startingAt: 96)
        
        XCTAssertEqual(beginningOfParagraphBackwardLocation, 50)
    }
    
}
