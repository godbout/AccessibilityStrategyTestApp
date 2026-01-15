@testable import AccessibilityStrategy
import XCTest


class FT_beginningOfSentenceForward_OnBlankLines_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Int {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.beginningOfSentenceForward(startingAt: caretLocation)
    }
    
}


extension FT_beginningOfSentenceForward_OnBlankLines_Tests {
    
    func test_that_it_does_not_get_stuck_in_the_middle_of_multiple_BlankLines() {
        let text = """
so it's not gonna skip lines but stop
at paragraph boundaries
        
           
       
               
               
can check the impl of that
"""
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 78)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 148)
    }
    
    func test_that_if_the_caret_is_on_an_BlankLine_and_the_text_ends_by_multiple_BlankLines_then_it_goes_to_the_endLimit() {
        let text = """
plenty of empty lines
below
           
        
   
  
     
     
     
"""
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 29)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 72)
    }
    
}


// bugs found
extension FT_beginningOfSentenceForward_OnBlankLines_Tests {

    func test_that_if_the_caret_is_on_a_BlankLine_it_stops_on_the_next_EmptyLine_which_is_actually_a_paragraph_boundary() {
        let text = """
so below there's some blank lines
but also an empty line in the middle!
    
    
   
    
  

    
hehe
"""
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 79)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 94)
    }
    
}
