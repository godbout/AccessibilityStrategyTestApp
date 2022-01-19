@testable import AccessibilityStrategy
import XCTest


// yes, `innerParagraph` cannot be from `beginningOfParagraph` to `endOfParagraph`.
// this is because in normal setting a blank line is not a paragraph boundary, but for
// innerParagraph it is. so it needs its own computation.
class FT_innerParagraph_NormalSetting_Tests: XCTestCase {}


// surrounded by Empty Lines
// these tests contain Blanks
extension FT_innerParagraph_NormalSetting_Tests {
    
    func test_that_for_a_single_line_it_returns_the_whole_line() {
        let text = "   so for innerParagraph blank lines are a boundary. it's an exception."
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 71) 
    }
    
    func test_that_for_a_single_line_after_an_EmptyLine_it_returns_the_correct_range() {
        let text = """

    so for innerParagraph blank lines are a boundary. it's an exception.
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 1)
        XCTAssertEqual(innerParagraphRange.count, 72) 
    }
    
    func test_that_for_a_single_line_after_two_EmptyLines_it_returns_the_correct_range() {
        let text = """


so for innerParagraph blank lines are a boundary. it's an exception.
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 2)
        XCTAssertEqual(innerParagraphRange.count, 68) 
    }
    
    func test_that_for_a_single_line_before_an_EmptyLine_it_returns_the_correct_range() {
        let text = """
  so for innerParagraph blank lines are a boundary. it's an exception.

"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 71) 
    }
    
    func test_that_for_a_single_line_before_two_EmptyLines_it_returns_the_correct_range() {
        let text = """
so for innerParagraph blank lines are a boundary. it's an exception.


"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 69) 
    }
    
    func test_that_for_a_single_line_after_and_before_EmptyLines_it_returns_the_correct_range() {
        let text = """

      so for innerParagraph blank lines are a boundary. it's an exception.

"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 1)
        XCTAssertEqual(innerParagraphRange.count, 75) 
    }
    
    func test_that_for_a_single_line_surrounded_by_other_lines_it_returns_the_correct_range() {
        let text = """
some fucking lines


 so for innerParagraph blank lines are a boundary. it's an exception.

some more
hehe

"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 49)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 21)
        XCTAssertEqual(innerParagraphRange.count, 70) 
    }
    
    func test_that_for_multiple_lines_without_any_Empty_or_Blank_Lines_above_and_below_it_returns_the_whole_text() {
        let text = """
 this text
is a whole
  paragraph in
   itself
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 46) 
    }
    
    func test_that_for_multiple_lines_before_one_EmptyLine_it_returns_the_correct_range() {
        let text = """

 this text
is a whole
paragraph in
   itself
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 1)
        XCTAssertEqual(innerParagraphRange.count, 44) 
    }
    
    func test_that_for_multiple_lines_before_two_EmptyLines_it_returns_the_correct_range() {
        let text = """


this text
is a whole
paragraph in
   itself
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 2)
        XCTAssertEqual(innerParagraphRange.count, 43) 
    }
    
    func test_that_for_a_multiple_lines_before_one_EmptyLine_it_returns_the_correct_range() {
        let text = """
this text
is a whole
paragraph in
   itself

"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 44) 
    }
    
    func test_that_for_a_multiple_lines_before_two_EmptyLines_it_returns_the_correct_range() {
        let text = """
this text
is a whole
paragraph in
   itself


"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 44) 
    }
    
    func test_that_for_a_multiple_lines_after_and_before_EmptyLines_it_returns_the_correct_range() {
        let text = """


this text
is a whole
paragraph in
   itself

"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 2)
        XCTAssertEqual(innerParagraphRange.count, 44) 
    }
    
    
    func test_that_for_multilines_surrounded_by_other_lines_it_returns_the_correct_range() {
        let text = """
some fucking lines


 this text
 is a whole
paragraph in
   itself

some more
hehe

"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 47)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 21)
        XCTAssertEqual(innerParagraphRange.count, 46) 
    }
    
}


// surrounded by Blank Lines
// these tests contain Blank Lines. (duh.)
extension FT_innerParagraph_NormalSetting_Tests {
    
    func test_that_for_a_single_line_after_an_BlankLine_it_returns_the_correct_range() {
        let text = """
               
 so for innerParagraph blank lines are a boundary. it's an exception.
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 28)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 16)
        XCTAssertEqual(innerParagraphRange.count, 69) 
    }
    
    func test_that_for_a_single_line_after_two_BlankLines_it_returns_the_correct_range() {
        let text = """
         
                     
 so for innerParagraph blank lines are a boundary. it's an exception.
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 70)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 32)
        XCTAssertEqual(innerParagraphRange.count, 69) 
    }
    
    func test_that_for_a_single_line_before_an_BlankLine_it_returns_the_correct_range() {
        let text = """
  so for innerParagraph blank lines are a boundary. it's an exception.
            
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 71) 
    }
    
    func test_that_for_a_single_line_before_two_BlankLines_it_returns_the_correct_range() {
        let text = """
so for innerParagraph blank lines are a boundary. it's an exception.
             
              
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 69) 
    }
    
    func test_that_for_a_single_line_after_and_before_BlankLines_it_returns_the_correct_range() {
        let text = """
            
  so for innerParagraph blank lines are a boundary. it's an exception.
         
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 17)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 13)
        XCTAssertEqual(innerParagraphRange.count, 71) 
    }
    
    func test_that_for_a_single_line_surrounded_by_other_BlankLines_it_returns_the_correct_range() {
        let text = """
some fucking lines
                      

so for innerParagraph blank lines are a boundary. it's an exception.
             
some more
hehe

"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 50)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 43)
        XCTAssertEqual(innerParagraphRange.count, 69) 
    }
    
    func test_that_for_multiple_lines_before_one_BlankLine_it_returns_the_correct_range() {
        let text = """
          
    this text
is a whole
paragraph in
   itself
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 38)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 11)
        XCTAssertEqual(innerParagraphRange.count, 47) 
    }
    
    func test_that_for_multiple_lines_before_two_BlankLines_it_returns_the_correct_range() {
        let text = """

          
this text
is a whole
paragraph in
   itself
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 32)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 12)
        XCTAssertEqual(innerParagraphRange.count, 43) 
    }
    
    func test_that_for_a_multiple_lines_before_one_BlankLine_it_returns_the_correct_range() {
        let text = """
this text
is a whole
paragraph in
   itself
              
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 44) 
    }
    
    func test_that_for_a_multiple_lines_before_two_BlankLines_it_returns_the_correct_range() {
        let text = """
this text
is a whole
paragraph in
   itself
              
      
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 44) 
    }
    
    func test_that_for_a_multiple_lines_after_and_before_BlankLines_it_returns_the_correct_range() {
        let text = """
          

   this text
is a whole
 paragraph in
   itself
     
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 33)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 12)
        XCTAssertEqual(innerParagraphRange.count, 48) 
    }
    
    
    func test_that_for_multilines_surrounded_by_other_BlankLines_it_returns_the_correct_range() {
        let text = """
some fucking lines
           

this text
is a whole
paragraph in
   itself

some more
hehe
       
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 47)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 32)
        XCTAssertEqual(innerParagraphRange.count, 44) 
    }
    
}


// mix of Empty and Blank Lines
// happens that a mix of them still doesn't work sometimes.
// regexes are hard. here will probably have all the bugs we've encountered
// while using.
// these tests contain Blank Lines.
extension FT_innerParagraph_NormalSetting_Tests {

    func test_that_a_mix_of_EmptyLines_and_BlankLines_above_a_text_returns_the_correct_range() {
        let text = """
  some fucking lines
       

       
  some more
hehe
       
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 49)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 38)
        XCTAssertEqual(innerParagraphRange.count, 17) 
    }

    // there is a space at the end of the second line (which is why the regex failed)
    func test_that_if_a_line_ends_with_blanks_it_returns_the_correct_range() {
        let text = """
    XCTAssertEqual(innerParagraphRange.lowerBound, 0)
    XCTAssertEqual(innerParagraphRange.count, 3)  
}
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 105)

        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 106)
    }
    
    func test_that_if_a_whole_text_end_with_blanks_it_returns_the_correct_range() {
        let text = """
       OMFG regex                      
"""

        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 17)

        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 39)
    }

}
