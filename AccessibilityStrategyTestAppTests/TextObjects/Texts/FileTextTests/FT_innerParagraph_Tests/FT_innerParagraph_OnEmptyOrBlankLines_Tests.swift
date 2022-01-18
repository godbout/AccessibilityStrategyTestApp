@testable import AccessibilityStrategy
import XCTest


// see innerParagraph NormalSetting for blah blah
class FT_innerParagraph_OnEmptyOrBlankLines_Tests: XCTestCase {}


// on Empty Lines
extension FT_innerParagraph_OnEmptyOrBlankLines_Tests {
    
    func test_that_for_an_EmptyLine_it_returns_the_correct_range() {
        let text = ""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 0)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 0) 
    }
    
    func test_that_for_a_single_EmptyLine_before_some_text_it_returns_the_correct_range() {
        let text = """

so for innerParagraph blank lines are a boundary. it's an exception.
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 0)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 1) 
    }
    
    func test_that_for_two_EmptyLines_before_some_text_it_returns_the_correct_range() {
        let text = """


so for innerParagraph blank lines are a boundary. it's an exception.
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 0)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 2) 
    }
    
    func test_that_for_a_single_EmptyLine_after_some_text_it_returns_the_correct_range() {
        let text = """
so for innerParagraph blank lines are a boundary. it's an exception.

"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 69)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 69)
        XCTAssertEqual(innerParagraphRange.count, 0) 
    }
    
    func test_that_for_two_EmptyLines_after_some_text_it_returns_the_correct_range() {
        let text = """
so for innerParagraph blank lines are a boundary. it's an exception.


"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 69)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 69)
        XCTAssertEqual(innerParagraphRange.count, 1) 
    }
    
    func test_that_for_a_single_EmptyLine_surrounded_by_some_text_it_returns_the_correct_range() {
        let text = """
so for innerParagraph blank lines are a boundary. it's an exception.

so for innerParagraph blank lines are a boundary. it's an exception.
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 69)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 69)
        XCTAssertEqual(innerParagraphRange.count, 1) 
    }
    
    func test_that_for_a_single_EmptyLine_surrounded_by_some_other_EmptyLines_it_returns_the_correct_range() {
        let text = """
some fucking lines


some more

hehe


"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 31)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 31)
        XCTAssertEqual(innerParagraphRange.count, 1) 
    }
    
    func test_that_for_multiple_EmptyLines_not_surrounded_by_text_returns_the_correct_range() {
        let text = """




"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 1)
        
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
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 2)
        
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
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 44)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 44)
        XCTAssertEqual(innerParagraphRange.count, 2) 
    }
    
    func test_that_for_a_multiple_EmptyLines_between_some_text_it_returns_the_correct_range() {
        let text = """
this text
is a whole



paragraph in
   itself
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 22)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 21)
        XCTAssertEqual(innerParagraphRange.count, 3) 
    }
    
}


// on Blank Lines
// these tests contain Blank Lines.
extension FT_innerParagraph_OnEmptyOrBlankLines_Tests {
    
    func test_that_for_an_BlankLine_it_returns_the_correct_range() {
        let text = "                      "
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 0)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 22) 
    }
    
    func test_that_for_a_single_BlankLine_before_some_text_it_returns_the_correct_range() {
        let text = """
                    
so for innerParagraph blank lines are a boundary. it's an exception.
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 5)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 21) 
    }
    
    func test_that_for_two_BlankLines_before_some_text_it_returns_the_correct_range() {
        let text = """

                      
so for innerParagraph blank lines are a boundary. it's an exception.
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 12)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 24) 
    }
    
    func test_that_for_a_single_BlankLine_after_some_text_it_returns_the_correct_range() {
        let text = """
so for innerParagraph blank lines are a boundary. it's an exception.
                    
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 81)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 69)
        XCTAssertEqual(innerParagraphRange.count, 20) 
    }
    
    func test_that_for_two_BlankLines_after_some_text_it_returns_the_correct_range() {
        let text = """
so for innerParagraph blank lines are a boundary. it's an exception.
                       
          
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 69)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 69)
        XCTAssertEqual(innerParagraphRange.count, 34) 
    }
    
    func test_that_for_a_single_BlankLine_surrounded_by_some_text_it_returns_the_correct_range() {
        let text = """
so for innerParagraph blank lines are a boundary. it's an exception.
                     
so for innerParagraph blank lines are a boundary. it's an exception.
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 78)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 69)
        XCTAssertEqual(innerParagraphRange.count, 22) 
    }
    
    func test_that_for_a_single_BlankLine_surrounded_by_some_other_BlankLines_it_returns_the_correct_range() {
        let text = """
some fucking lines

         
some more
           
hehe
          

"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 45)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 40)
        XCTAssertEqual(innerParagraphRange.count, 12) 
    }
    
    func test_that_for_multiple_BlankLines_not_surrounded_by_text_returns_the_correct_range() {
        let text = """
               
                 
        
                   
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 1)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 62) 
    }
    
    func test_that_for_multiple_BlankLines_before_some_text_it_returns_the_correct_range() {
        let text = """
     

              
this text
is a whole
paragraph in
   itself
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 4)
        
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
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 48)
        
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
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 33)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 21)
        XCTAssertEqual(innerParagraphRange.count, 25) 
    }
    
}
