@testable import AccessibilityStrategy
import XCTest


// see innerParagraph NormalSetting for blah blah
class FT_innerParagraph_OnEmptyLines_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Range<Int> {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.innerParagraph(startingAt: caretLocation)
    }
    
}


// TextFields and TextViews
extension FT_innerParagraph_OnEmptyLines_Tests {
    
    func test_that_for_an_EmptyLine_it_returns_the_correct_range() {
        let text = ""
        
        let innerParagraphRange = applyFuncBeingTested(on: text, startingAt: 17)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 0) 
    }
    
}


// TextViews
// surrounded by EmptyLines
extension FT_innerParagraph_OnEmptyLines_Tests {
    
    func test_that_for_a_single_EmptyLine_before_some_text_it_returns_the_correct_range() {
        let text = """

  so for innerParagraph blank lines are a boundary. it's an exception.
"""
        
        let innerParagraphRange = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 1) 
    }
    
    func test_that_for_two_EmptyLines_before_some_text_it_returns_the_correct_range() {
        let text = """


  so for innerParagraph blank lines are a boundary. it's an exception.
"""
        
        let innerParagraphRange = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 2) 
    }
    
    func test_that_for_a_single_EmptyLine_after_some_text_it_returns_the_correct_range() {
        let text = """
so for innerParagraph blank lines are a boundary. it's an exception.   

"""
        
        let innerParagraphRange = applyFuncBeingTested(on: text, startingAt: 72)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 72)
        XCTAssertEqual(innerParagraphRange.count, 0) 
    }
    
    func test_that_for_two_EmptyLines_after_some_text_it_returns_the_correct_range() {
        let text = """
so for innerParagraph blank lines are a boundary. it's an exception.


"""
        
        let innerParagraphRange = applyFuncBeingTested(on: text, startingAt: 69)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 69)
        XCTAssertEqual(innerParagraphRange.count, 1) 
    }
    
    func test_that_for_a_single_EmptyLine_surrounded_by_some_text_it_returns_the_correct_range() {
        let text = """
so for innerParagraph blank lines are a boundary. it's an exception.  

  so for innerParagraph blank lines are a boundary. it's an exception.
"""
        
        let innerParagraphRange = applyFuncBeingTested(on: text, startingAt: 71)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 71)
        XCTAssertEqual(innerParagraphRange.count, 1) 
    }
    
    func test_that_for_a_single_EmptyLine_surrounded_by_some_other_EmptyLines_it_returns_the_correct_range() {
        let text = """
some fucking lines


some more  

 hehe


"""
        
        let innerParagraphRange = applyFuncBeingTested(on: text, startingAt: 33)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 33)
        XCTAssertEqual(innerParagraphRange.count, 1) 
    }
    
    func test_that_for_multiple_EmptyLines_not_surrounded_by_text_returns_the_correct_range() {
        let text = """




"""
        
        let innerParagraphRange = applyFuncBeingTested(on: text, startingAt: 1)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 3) 
    }
    
    func test_that_for_multiple_EmptyLines_before_some_text_it_returns_the_correct_range() {
        let text = """



       this text
is a whole
paragraph in
   itself
"""
        
        let innerParagraphRange = applyFuncBeingTested(on: text, startingAt: 2)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 3) 
    }
    
    func test_that_for_a_multiple_EmptyLines_after_some_text_it_returns_the_correct_range() {
        let text = """
this text
is a whole
paragraph in
   itself 



"""
        
        let innerParagraphRange = applyFuncBeingTested(on: text, startingAt: 45)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 45)
        XCTAssertEqual(innerParagraphRange.count, 2) 
    }
    
    func test_that_for_a_multiple_EmptyLines_between_some_text_it_returns_the_correct_range() {
        let text = """
this text
is a whole 



  paragraph in
   itself
"""
        
        let innerParagraphRange = applyFuncBeingTested(on: text, startingAt: 23)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 22)
        XCTAssertEqual(innerParagraphRange.count, 3) 
    }
    
}
