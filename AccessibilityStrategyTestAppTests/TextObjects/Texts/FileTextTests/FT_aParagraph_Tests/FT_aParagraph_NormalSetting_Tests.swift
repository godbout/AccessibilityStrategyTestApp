@testable import AccessibilityStrategy
import XCTest


// see innerParagraph for blah blah about fucking Vim rules
class FT_aParagraph_NormalSetting_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Range<Int>? {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.aParagraph(startingAt: caretLocation)
    }
    
}


// surrounded by Empty Lines
// these tests contain Blanks
extension FT_aParagraph_NormalSetting_Tests {
    
    func test_that_for_a_single_line_it_returns_the_whole_line() {
        let text = "   so for innerParagraph blank lines are a boundary. it's an exception."
        
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 10)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 71) 
    }
        
    func test_that_for_a_single_line_after_an_EmptyLine_it_returns_the_correct_range() {
        let text = """

    so for innerParagraph blank lines are a boundary. it's an exception.
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 10)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 73) 
    }
        
    func test_that_for_a_single_line_after_two_EmptyLines_it_returns_the_correct_range() {
        let text = """


so for innerParagraph blank lines are a boundary. it's an exception.
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 10)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 70) 
    }
        
    func test_that_for_a_single_line_before_an_EmptyLine_it_returns_the_correct_range() {
        let text = """
  so for innerParagraph blank lines are a boundary. it's an exception.

"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 10)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 71) 
    }
        
    func test_that_for_a_single_line_before_two_EmptyLines_it_returns_the_correct_range() {
        let text = """
so for innerParagraph blank lines are a boundary. it's an exception.


"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 10)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 70) 
    }
       
    func test_that_for_a_single_line_after_and_before_EmptyLines_it_returns_the_correct_range() {
        let text = """

      so for innerParagraph blank lines are a boundary. it's an exception.

"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 10)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 1)
        XCTAssertEqual(aParagraphRange?.count, 75) 
    }
    
    func test_that_for_a_single_line_surrounded_by_other_lines_it_returns_the_correct_range() {
        let text = """
some fucking lines


 so for innerParagraph blank lines are a boundary. it's an exception.

some more
hehe

"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 49)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 21)
        XCTAssertEqual(aParagraphRange?.count, 71) 
    }
    
    func test_that_for_a_single_line_at_the_end_of_the_text_surrounded_by_other_lines_if_returns_the_correct_range() {
        let text = """
this is something
that is gonna



fail only with aParagraph, not with innerParagraph
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 48)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 32)
        XCTAssertEqual(aParagraphRange?.count, 53) 
    }
    
    func test_that_for_a_single_line_at_the_end_of_the_text_preceded_by_only_one_EmptyLine_if_returns_the_correct_range() {
        let text = """
this is something
that is gonna

fail only with aParagraph, not with innerParagraph
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 39)

        XCTAssertEqual(aParagraphRange?.lowerBound, 32)
        XCTAssertEqual(aParagraphRange?.count, 51)
    }

    func test_that_for_multiple_lines_without_any_Empty_or_Blank_Lines_above_and_below_it_returns_the_whole_text() {
        let text = """
 this text
is a whole
  paragraph in
   itself
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 10)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 46) 
    }
        
    func test_that_for_multiple_lines_before_one_EmptyLine_it_returns_the_correct_range() {
        let text = """

 this text
is a whole
paragraph in
   itself
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 10)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 45) 
    }
    
    func test_that_for_multiple_lines_before_two_EmptyLines_it_returns_the_correct_range() {
        let text = """


this text
is a whole
paragraph in
   itself
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 10)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 45) 
    }
    
    func test_that_for_a_multiple_lines_before_one_EmptyLine_it_returns_the_correct_range() {
        let text = """
this text
is a whole
paragraph in
   itself

"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 10)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 44) 
    }
    
    func test_that_for_a_multiple_lines_after_and_before_EmptyLines_it_returns_the_correct_range() {
        let text = """


this text
is a whole
paragraph in
   itself

"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 10)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 2)
        XCTAssertEqual(aParagraphRange?.count, 44) 
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
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 47)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 21)
        XCTAssertEqual(aParagraphRange?.count, 47) 
    }
    
    func test_that_for_a_multilines_at_the_end_of_the_text_surrounded_by_other_lines_if_returns_the_correct_range() {
        let text = """
this is something
that is gonna



fail only with aParagraph
not with innerParagraph
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 74)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 32)
        XCTAssertEqual(aParagraphRange?.count, 52) 
    } 
    
}


// surrounded by Blank Lines
// these tests contain Blank Lines. (duh.)
extension FT_aParagraph_NormalSetting_Tests {
    
    func test_that_for_a_single_line_after_an_BlankLine_it_returns_the_correct_range() {
        let text = """
               
 so for innerParagraph blank lines are a boundary. it's an exception.
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 28)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 85) 
    }
    
    func test_that_for_a_single_line_after_two_BlankLines_it_returns_the_correct_range() {
        let text = """
         
                     
 so for innerParagraph blank lines are a boundary. it's an exception.
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 70)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 101) 
    }
    
    func test_that_for_a_single_line_before_an_BlankLine_it_returns_the_correct_range() {
        let text = """
  so for innerParagraph blank lines are a boundary. it's an exception.
            
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 10)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 83) 
    }
    
    func test_that_for_a_single_line_before_two_BlankLines_it_returns_the_correct_range() {
        let text = """
so for innerParagraph blank lines are a boundary. it's an exception.
             
              
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 10)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 97) 
    }
    
    func test_that_for_a_single_line_after_and_before_BlankLines_it_returns_the_correct_range() {
        let text = """
            
  so for innerParagraph blank lines are a boundary. it's an exception.
         
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 17)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 13)
        XCTAssertEqual(aParagraphRange?.count, 80) 
    }
    
    func test_that_for_a_single_line_surrounded_by_other_BlankLines_it_returns_the_correct_range() {
        let text = """
some fucking lines
                      

so for innerParagraph blank lines are a boundary. it's an exception.
             
some more
hehe

"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 50)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 43)
        XCTAssertEqual(aParagraphRange?.count, 83) 
    }
    
    func test_that_for_a_single_line_that_ends_the_text_and_with_lines_above_it_returns_the_correct_range() {
        let text = """
hey here are
some line
          
       
      
and a last line with blanks above
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 68)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 23)
        XCTAssertEqual(aParagraphRange?.count, 59) 
    }
    
    func test_that_for_a_single_line_that_ends_the_text_and_with_only_one_line_above_it_returns_the_correct_range() {
        let text = """
hey here are
some line

and a last line with blanks above
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 51)

        XCTAssertEqual(aParagraphRange?.lowerBound, 23)
        XCTAssertEqual(aParagraphRange?.count, 34)

    }

    func test_that_for_multiple_lines_before_one_BlankLine_it_returns_the_correct_range() {
        let text = """
          
    this text
is a whole
paragraph in
   itself
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 38)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 58) 
    }
    
    func test_that_for_multiple_lines_before_two_BlankLines_it_returns_the_correct_range() {
        let text = """

          
this text
is a whole
paragraph in
   itself
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 32)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 55) 
    }
        
    func test_that_for_a_multiple_lines_before_one_BlankLine_it_returns_the_correct_range() {
        let text = """
this text
is a whole
paragraph in
   itself
              
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 10)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 58) 
    }
        
    func test_that_for_a_multiple_lines_before_two_BlankLines_it_returns_the_correct_range() {
        let text = """
this text
is a whole
paragraph in
   itself
              
      
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 10)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 65) 
    }
    
    func test_that_for_a_multiple_lines_after_and_before_BlankLines_it_returns_the_correct_range() {
        let text = """
          

   this text
is a whole
 paragraph in
   itself
     
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 33)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 12)
        XCTAssertEqual(aParagraphRange?.count, 53) 
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
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 47)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 32)
        XCTAssertEqual(aParagraphRange?.count, 45) 
    }
    
}


// mix of Empty and Blank Lines
// happens that a mix of them still doesn't work sometimes. regexes are hard.
// these tests contain Blank Lines.
extension FT_aParagraph_NormalSetting_Tests {
    
    func test_that_a_mix_of_EmptyLines_and_BlankLines_above_a_text_returns_the_correct_range() {
        let text = """
  some fucking lines
       

       
  some more
hehe
       
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 49)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 38)
        XCTAssertEqual(aParagraphRange?.count, 24) 
    }
    
    // there is a space at the end of the second line (which is why the regex failed)
    func test_that_if_a_line_ends_with_blanks_it_returns_the_correct_range() {
        let text = """
    XCTAssertEqual(innerParagraphRange.lowerBound, 0)
    XCTAssertEqual(innerParagraphRange.count, 3)  
}
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 105)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 106) 
    }
    
    func test_that_if_a_whole_text_end_with_blanks_it_returns_the_correct_range() {
        let text = """
       OMFG regex                      
"""
        let aParagraphRange = applyFuncBeingTested(on: text, startingAt: 17)
        
        XCTAssertEqual(aParagraphRange?.lowerBound, 0)
        XCTAssertEqual(aParagraphRange?.count, 39) 
    }
    
}
