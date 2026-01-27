@testable import AccessibilityStrategy
import XCTest


// see innerParagraph NormalSetting for blah blah
class FT_innerParagraph_OnBlankLines_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Range<Int> {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.innerParagraph(startingAt: caretLocation)
    }
    
}


extension FT_innerParagraph_OnBlankLines_Tests {
    
    func test_that_for_an_BlankLine_it_returns_the_correct_range() {
        let text = "                      "
        
        let innerParagraphRange = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 22) 
    }
    
    func test_that_for_a_single_BlankLine_before_some_text_it_returns_the_correct_range() {
        let text = """
                    
  so for innerParagraph blank lines are a boundary. it's an exception.
"""
        
        let innerParagraphRange = applyFuncBeingTested(on: text, startingAt: 5)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 21) 
    }
    
    func test_that_for_two_BlankLines_before_some_text_it_returns_the_correct_range() {
        let text = """

                      
              so for innerParagraph blank lines are a boundary. it's an exception.
"""
        
        let innerParagraphRange = applyFuncBeingTested(on: text, startingAt: 12)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 24) 
    }
    
    func test_that_for_a_single_BlankLine_after_some_text_it_returns_the_correct_range() {
        let text = """
so for innerParagraph blank lines are a boundary. it's an exception.   
                    
"""
        
        let innerParagraphRange = applyFuncBeingTested(on: text, startingAt: 81)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 72)
        XCTAssertEqual(innerParagraphRange.count, 20) 
    }
    
    func test_that_for_two_BlankLines_after_some_text_it_returns_the_correct_range() {
        let text = """
so for innerParagraph blank lines are a boundary. it's an exception.
                       
          
"""
        
        let innerParagraphRange = applyFuncBeingTested(on: text, startingAt: 69)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 69)
        XCTAssertEqual(innerParagraphRange.count, 34) 
    }
    
    func test_that_for_a_single_BlankLine_surrounded_by_some_text_it_returns_the_correct_range() {
        let text = """
so for innerParagraph blank lines are a boundary. it's an exception.  
                     
  so for innerParagraph blank lines are a boundary. it's an exception.
"""
        
        let innerParagraphRange = applyFuncBeingTested(on: text, startingAt: 78)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 71)
        XCTAssertEqual(innerParagraphRange.count, 22) 
    }
    
    func test_that_for_a_single_BlankLine_surrounded_by_some_other_BlankLines_it_returns_the_correct_range() {
        let text = """
some fucking lines

         
some more  
           
hehe
          

"""
        
        let innerParagraphRange = applyFuncBeingTested(on: text, startingAt: 45)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 42)
        XCTAssertEqual(innerParagraphRange.count, 12) 
    }
    
    func test_that_for_multiple_BlankLines_not_surrounded_by_text_returns_the_correct_range() {
        let text = """
               
                
        
                   
"""
        
        let innerParagraphRange = applyFuncBeingTested(on: text, startingAt: 1)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 61) 
    }
    
    func test_that_for_multiple_BlankLines_before_some_text_it_returns_the_correct_range() {
        let text = """
     

              
     this text
is a whole
paragraph in
   itself
"""
        
        let innerParagraphRange = applyFuncBeingTested(on: text, startingAt: 4)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 22) 
    }
    
    func test_that_for_a_multiple_BlankLines_after_some_text_it_returns_the_correct_range() {
        let text = """
this text
is a whole
paragraph in
   itself
             
      

"""
        
        let innerParagraphRange = applyFuncBeingTested(on: text, startingAt: 48)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 44)
        XCTAssertEqual(innerParagraphRange.count, 21) 
    }
    
    func test_that_for_a_multiple_BlankLines_between_some_text_it_returns_the_correct_range() {
        let text = """
this text
is a whole   
         
    
         
  paragraph in
   itself
"""
        
        let innerParagraphRange = applyFuncBeingTested(on: text, startingAt: 33)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 24)
        XCTAssertEqual(innerParagraphRange.count, 25) 
    }
    
}


// mix of Empty and Blank Lines
// see innerParagraph NormalSetting for more blah blah.
extension FT_innerParagraph_OnBlankLines_Tests {

    func test_that_if_the_first_line_contains_Blanks_it_returns_the_correct_range() {
        let text = """
         

                
"""
        
        let innerParagraphRange = applyFuncBeingTested(on: text, startingAt: 18)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 27) 
    }
   
}
