@testable import AccessibilityStrategy
import XCTest


// tests for when the caretLocation is on an empty line. need different Regex
class FT_beginningOfSentenceForward_OnEmptyOrBlankLines_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Int {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.beginningOfSentenceForward(startingAt: caretLocation)
    }
    
}


// on Empty Lines
// these tests contain Blanks
extension FT_beginningOfSentenceForward_OnEmptyOrBlankLines_Tests {
    
    func test_that_if_the_text_is_empty_then_it_returns_0() {
        let text = ""
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 0)
    }
    
    func test_that_if_the_caret_is_on_the_last_EmptyLine_then_it_does_not_move() {
        let text = """
this move doesn't bip
but of course at the last empty line
it will not move

"""
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 76)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 76)
    }
       
    func test_that_it_does_not_get_stuck_in_the_middle_of_multiple_emptyLines() {
        let text = """
so it's not gonna skip lines but stop
at paragraph boundaries





can check the impl of that
"""
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 62)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 67)
    }
    
    func test_that_if_the_caret_is_on_an_emptyLine_and_the_text_ends_by_multiple_emptyLines_then_it_goes_to_the_end() {
        let text = """
plenty of empty lines
below







"""
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 29)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 34)
    }
    
}


// on Blank Lines
// these tests contain Blanks
extension FT_beginningOfSentenceForward_OnEmptyOrBlankLines_Tests {
    
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
