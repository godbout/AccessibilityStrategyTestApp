@testable import AccessibilityStrategy
import XCTest


class FT_beginningOfSentenceBackward_OnBlankLines_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Int {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.beginningOfSentenceBackward(startingAt: caretLocation)
    }
    
}


// TextViews
// surrounded by BlankLines
extension FT_beginningOfSentenceBackward_OnBlankLines_Tests {
    
    func test_that_if_the_caret_is_on_the_last_BlankLine_it_goes_to_the_beginning_of_the_sentence() {
        let text = """
this move doesn't bip
but of course at the last empty line
it will. not move
        
"""
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 83)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 68)
    }
    
    func test_that_it_does_not_get_stuck_in_the_middle_of_multiple_BlankLines() {
        let text = """
so it's not gonna skip lines but stop
at paragraph boundaries
    
       
      
    
       
can check the impl of that
"""
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 62)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 0)
    }
    
    func test_that_if_the_caret_is_on_a_BlankLine_and_the_text_starts_by_multiple_BlankLines_then_it_goes_to_the_start() {
        let text = """
      
           
          
           
           
plenty of blank lines
above
"""
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 0)
    }
    
    func test_that_it_does_not_skip_the_beginning_of_the_sentence_above_even_with_BlankLines() {
        let text = """
another bug

   of course
 hehe
       
       
      
this is some more text
"""
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 42)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 16)
    }
    
}


// bugs found
extension FT_beginningOfSentenceBackward_OnBlankLines_Tests {

    func test_that_if_the_caret_is_on_a_BlankLine_it_stops_on_the_previous_EmptyLine_which_is_actually_a_paragraph_boundary() {
        let text = """
so below there's some empty lines
and some blank lines aftewards!


           
         
hehe
"""
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 84)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 67)
    }
    
}
