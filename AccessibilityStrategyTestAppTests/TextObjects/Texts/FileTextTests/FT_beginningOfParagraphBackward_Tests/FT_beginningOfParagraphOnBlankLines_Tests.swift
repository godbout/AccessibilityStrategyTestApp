@testable import AccessibilityStrategy
import XCTest


class FT_beginningOfParagraphBackward_OnBlankLines_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Int {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.beginningOfParagraphBackward(startingAt: caretLocation)
    }
    
}


// TextFields and TextViews
extension FT_beginningOfParagraphBackward_OnBlankLines_Tests {
    
    func test_that_if_the_text_is_just_a_BlankLine_then_it_stops_before_the_first_character() {
        let text = "       "
        
        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 0)
    }
    
}


// TextViews
// basic
extension FT_beginningOfParagraphBackward_OnBlankLines_Tests {
    
    func test_that_it_does_not_get_stuck_at_a_NonEmptyLine() {
        let text = """
an EL below!

so here's some text
and more
           
and now the BL above!
"""
        
        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 65)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 13)
    }
    
    func test_that_it_does_not_get_stuck_at_multiple_NonEmptyLines() {
        let text = """
so here's some text
and more

and now the next NonEmptyLines
and now the next NonEmptyLines
and now the next NonEmptyLines
         
           
last line hehe
"""
        
        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 134)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 29)
    }
    
}


// TextViews
// surrounded by EmptyLines
extension FT_beginningOfParagraphBackward_OnBlankLines_Tests {
    
    func test_that_if_the_caret_is_on_a_BlankLine_it_stops_on_the_previous_EmptyLine() {
        let text = """
so below there's some blank lines
but also an empty line in the middle!
  

    
hehe
"""
        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 78)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 75)
    }
    
    func test_that_if_the_caret_is_on_a_BlankLine_it_stops_on_the_previous_EmptyLine_even_if_there_are_multiple_previous_consecutive_ones() {
        let text = """
so below there's some blank lines
but also an empty line in the middle!
  



    
hehe
"""
        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 80)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 77)
    }
    
}


// TextViews
// surrounded by BlankLines
extension FT_beginningOfParagraphBackward_OnBlankLines_Tests {
    
    func test_that_it_does_not_get_stuck_in_the_middle_of_multiple_BlankLines() {
        let text = """
so it's not gonna skip lines but stop
at paragraph boundaries
        
           
       
               
               
can check the impl of that
"""
        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 95)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 0)
    }
    
    func test_that_it_does_not_get_stuck_in_the_middle_of_multiple_BlankLines_and_stops_at_the_first_EmptyLine_found() {
        let text = """
so it's not gonna skip lines but stop
at paragraph boundaries
        

           
       
               
               
can check the impl of that
"""
        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 114)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 71)
    }

    func test_that_if_the_caret_is_on_an_BlankLine_and_the_text_starts_by_multiple_BlankLines_then_it_goes_to_the_beginning() {
        let text = """
           
        
   
  
     
     
     
plenty of blank lines
above
"""
        let endOfParagraphForwardLocation = applyFuncBeingTested(on: text, startingAt: 61)
        
        XCTAssertEqual(endOfParagraphForwardLocation, 0)
    }

}
