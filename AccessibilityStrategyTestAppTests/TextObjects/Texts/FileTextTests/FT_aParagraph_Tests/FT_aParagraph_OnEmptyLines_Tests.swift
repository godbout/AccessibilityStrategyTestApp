@testable import AccessibilityStrategy
import XCTest


// see innerParagraph (yes inner) NormalSetting for blah blah
class FT_aParagraph_OnEmptyLines_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Range<Int>? {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.aParagraph(startingAt: caretLocation)
    }
    
}


// TextFields and TextViews
extension FT_aParagraph_OnEmptyLines_Tests {
    
    func test_that_for_an_EmptyLine_it_returns_nil() {
        let text = ""
        
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertNil(aParagraphRange)
    }
    
}


// TextViews
// surrounded by EmptyLines
extension FT_aParagraph_OnEmptyLines_Tests {
    
    func test_that_for_a_single_EmptyLine_before_some_text_it_returns_the_correct_range() {
        let text = """

  so for innerParagraph blank lines are a boundary. it's an exception.
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 71) 
    }
        
    func test_that_for_two_EmptyLines_before_some_text_it_returns_the_correct_range() {
        let text = """


  so for innerParagraph blank lines are a boundary. it's an exception.
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 72) 
    }
    
    func test_that_for_a_single_EmptyLine_after_some_text_it_returns_nil() {
        let text = """
so for innerParagraph blank lines are a boundary. it's an exception.   

"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 72)
        
        XCTAssertNil(aParagraphRange)
    }
        
    func test_that_for_two_EmptyLines_after_some_text_it_returns_nil() {
        let text = """
so for innerParagraph blank lines are a boundary. it's an exception.


"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 69)
        
        XCTAssertNil(aParagraphRange)
    }
        
    func test_that_for_a_single_EmptyLine_surrounded_by_some_text_it_returns_the_correct_range() {
        let text = """
so for innerParagraph blank lines are a boundary. it's an exception.  

  so for innerParagraph blank lines are a boundary. it's an exception.
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 71)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 71)
        XCTAssertEqual(aParagraphRange?.count, 71) 
    }
    
    func test_that_for_a_single_EmptyLine_surrounded_by_some_other_EmptyLines_it_returns_the_correct_range() {
        let text = """
some fucking lines


some more  

 hehe


"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 33)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 33)
        XCTAssertEqual(aParagraphRange?.count, 7) 
    }
        
    func test_that_for_multiple_EmptyLines_not_surrounded_by_text_returns_nil() {
        let text = """




"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 1)
        
        XCTAssertNil(aParagraphRange)
    }
    
    func test_that_for_multiple_EmptyLines_before_some_text_it_returns_the_correct_range() {
        let text = """



       this text
is a whole
paragraph in
   itself
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 1)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 53) 
    }
    
    func test_that_for_multiple_EmptyLines_after_some_text_it_returns_nil() {
        let text = """
this text
is a whole
paragraph in
   itself 



"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 45)
        
        XCTAssertNil(aParagraphRange)
    }
    
    func test_that_for_multiple_EmptyLines_between_some_text_it_returns_the_correct_range() {
        let text = """
this text
is a whole 



  paragraph in
   itself
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 23)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 22)
        XCTAssertEqual(aParagraphRange?.count, 27) 
    }
    
}


// bugs found
extension FT_aParagraph_OnEmptyLines_Tests {

    func test_that_if_there_are_trailing_Blanks_at_the_end_of_a_line_they_are_included_in_the_range() {
        let text = """
looks nice
a bit more


  that line has trailing blanks   

and they should be counted
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 23)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 22)
        XCTAssertEqual(aParagraphRange?.count, 37) 
    }
    
    func test_that_if_the_line_below_another_line_has_only_one_character_then_that_line_is_included_in_the_range_lol() {
        let text = """
so

like if only one letter after this sentence   
a

and it doesn't work???
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 3)
        XCTAssertEqual(aParagraphRange?.count, 50) 
        
    }

}
