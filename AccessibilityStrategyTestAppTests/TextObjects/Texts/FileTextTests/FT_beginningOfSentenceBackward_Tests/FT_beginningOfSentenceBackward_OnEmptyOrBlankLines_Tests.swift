@testable import AccessibilityStrategy
import XCTest


// see Backward for blah blah
class FT_beginningOfSentenceBackward_OnEmptyOrBlankLines_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Int {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.beginningOfSentenceBackward(startingAt: caretLocation)
    }
    
}


// on Empty Lines
// these tests contain Blanks
extension FT_beginningOfSentenceBackward_OnEmptyOrBlankLines_Tests {
    
    func test_that_if_the_text_is_empty_then_it_returns_0() {
        let text = ""
        
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 0)
    }
    
    func test_that_if_the_caret_is_on_the_last_EmptyLine_it_goes_to_the_beginning_of_the_sentence() {
        let text = """
this move doesn't bip
but of course at the last empty line
it will. not move

"""
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 77)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 68)
    }
    
    func test_that_it_does_not_get_stuck_in_the_middle_of_multiple_EmptyLines() {
        let text = """
so it's not gonna skip lines but stop
at paragraph boundaries





can check the impl of that
"""
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 62)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 0)
    }
    
    func test_that_if_the_caret_is_on_an_EmptyLine_and_the_text_starts_by_multiple_EmptyLines_then_it_goes_to_the_start() {
        let text = """





plenty of empty lines
above
"""
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 0)
    }
    
    func test_that_it_does_not_skip_the_beginning_of_the_sentence_above() {
        let text = """
another bug

   of course
 hehe



this is some more text
"""
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 33)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 16)
    }
    
}


// on Blank lines
// these tests contain Blanks
extension FT_beginningOfSentenceBackward_OnEmptyOrBlankLines_Tests {
    
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


// bug found
extension FT_beginningOfSentenceBackward_OnEmptyOrBlankLines_Tests {
    
    func test_that_it_does_not_skip_EmptyLines_in_some_cases() {
        let text = """
so that's a case

where it skips

empty lines!
"""
        let beginningOfSentenceBackwardLocation = applyFuncBeingTested(on: text, startingAt: 33)
        
        XCTAssertEqual(beginningOfSentenceBackwardLocation, 18)
    }
}

// TODO: some UT func names should probably be clearer (bug found ones)
