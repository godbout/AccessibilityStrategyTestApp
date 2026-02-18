@testable import AccessibilityStrategy
import XCTest


class FT_aSentence_OnEmptyLines_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Range<Int> {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.aSentence(startingAt: caretLocation)
    }
    
}


// TextFields and TextViews
extension FT_aSentence_OnEmptyLines_Tests {
    
    func test_that_for_an_EmptyLine_it_returns_the_correct_range() {
        let text = ""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 0) 
    }
    
}


extension FT_aSentence_OnEmptyLines_Tests {
    
    // TODO: currently this crash is circumvented by testing onEmptyLineOrBlank
    // see innerSentence EL for blah blah
    func test_that_it_does_not_crash() {
        let text = """
this is
some text and it crashes
on last EL.

"""
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 45)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 43)
        XCTAssertEqual(aSentenceRange.count, 2) 
    }

}


// TODO: this is an EL test!
//    func test_that_if_the_caret_is_on_the_first_line_of_the_text_that_is_an_EmptyLine_then_it_returns_from_the_beginning_of_the_text_to_the_end_of_the_second_line_not_including_the_trailing_newline() {
//        let text = """
//
//this is a line.
//then one more.
//and another one.
//"""
//        
//        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 0)
//        
//        XCTAssertEqual(aSentenceRange.lowerBound, 0)
//        XCTAssertEqual(aSentenceRange.count, 16) 
//    }
    
