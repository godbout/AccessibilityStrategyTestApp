@testable import AccessibilityStrategy
import XCTest


// see innerParagraph (yes inner) NormalSetting for blah blah
class FT_aParagraph_OnEmptyOrBlankLines_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Range<Int>? {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.aParagraph(startingAt: caretLocation)
    }
    
}


// on Empty Lines
// these tests contain Blanks
extension FT_aParagraph_OnEmptyOrBlankLines_Tests {
    
    func test_that_for_an_EmptyLine_it_returns_nil() {
        let text = ""
        
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertNil(aParagraphRange)
    }
    
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
    
    // TODO: that should return nil? huh. probably better check all the other tests
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
    
    func test_that_for_a_multiple_EmptyLines_after_some_text_it_returns_nil() {
        let text = """
this text
is a whole
paragraph in
   itself 



"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 45)
        
        XCTAssertNil(aParagraphRange)
    }
    
    func test_that_for_a_multiple_EmptyLines_between_some_text_it_returns_the_correct_range() {
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


// on Blank Lines
// these tests contain Blank Lines.
extension FT_aParagraph_OnEmptyOrBlankLines_Tests {

    func test_that_for_an_BlankLine_it_returns_nil() {
        let text = "                      "
        
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertNil(aParagraphRange)
    }
    
    func test_that_for_a_single_BlankLine_before_some_text_it_returns_the_correct_range() {
        let text = """
                    
  so for innerParagraph blank lines are a boundary. it's an exception.
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 5)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 91) 
    }
        
    func test_that_for_two_BlankLines_before_some_text_it_returns_the_correct_range() {
        let text = """

                      
              so for innerParagraph blank lines are a boundary. it's an exception.
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 12)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 106) 
    }
        
    func test_that_for_a_single_BlankLine_after_some_text_it_returns_nil() {
        let text = """
so for innerParagraph blank lines are a boundary. it's an exception.   
                    
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 81)
        
        XCTAssertNil(aParagraphRange)
    }
    
    func test_that_for_two_BlankLines_after_some_text_it_returns_nil() {
        let text = """
so for innerParagraph blank lines are a boundary. it's an exception.
                       
          
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 69)
        
        XCTAssertNil(aParagraphRange)
    }
    
    func test_that_for_a_single_BlankLine_surrounded_by_some_text_it_returns_the_correct_range() {
        let text = """
so for innerParagraph blank lines are a boundary. it's an exception.  
                     
  so for innerParagraph blank lines are a boundary. it's an exception.
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 78)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 71)
        XCTAssertEqual(aParagraphRange?.count, 92) 
    }
        
    func test_that_for_a_single_BlankLine_surrounded_by_some_other_BlankLines_it_returns_the_correct_range() {
        let text = """
some fucking lines

         
some more  
           
hehe
          

"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 45)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 42)
        XCTAssertEqual(aParagraphRange?.count, 17) 
    }
    
    func test_that_for_multiple_BlankLines_not_surrounded_by_text_returns_nil() {
        let text = """
               
                
        
                   
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 1)
        
        XCTAssertNil(aParagraphRange)
    }
    
    func test_that_for_multiple_BlankLines_before_some_text_it_returns_the_correct_range() {
        let text = """
     

              
     this text
is a whole
paragraph in
   itself
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 4)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 70) 
    }
    
    func test_that_for_a_multiple_BlankLines_after_some_text_it_returns_nil() {
        let text = """
this text
is a whole
paragraph in
   itself
             
      

"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 48)
        
        XCTAssertNil(aParagraphRange)
    }
    
    func test_that_for_a_multiple_BlankLines_between_some_text_it_returns_the_correct_range() {
        let text = """
this text
is a whole   
         
    
         
  paragraph in
   itself
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 33)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 24)
        XCTAssertEqual(aParagraphRange?.count, 49) 
    }

}


// mix of Empty and Blank Lines
// see innerParagraph NormalSetting for more blah blah.
extension FT_aParagraph_OnEmptyOrBlankLines_Tests {
    
    func test_that_if_the_first_line_contains_Blanks_it_returns_nil() {
        let text = """
         

                
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 18)
        
        XCTAssertNil(aParagraphRange)
    }
   
}
