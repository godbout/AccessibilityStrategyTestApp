@testable import AccessibilityStrategy
import XCTest


// yes, `innerParagraph` cannot be from `beginningOfParagraph` to `endOfParagraph`.
// this is because in normal setting a blank line is not a paragraph boundary, but for
// innerParagraph it is. so it needs its own computation.
class FT_innerParagraph_Tests: XCTestCase {}


// Normal Setting
extension FT_innerParagraph_Tests {
    
    func test_that_for_a_single_line_it_returns_the_whole_line() {
        let text = "so for innerParagraph blank lines are a boundary. it's an exception."
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 68) 
    }
    
    func test_that_for_a_single_line_after_an_EmptyLine_it_returns_the_correct_range() {
        let text = """

so for innerParagraph blank lines are a boundary. it's an exception.
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 1)
        XCTAssertEqual(innerParagraphRange.count, 68) 
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
        XCTAssertEqual(innerParagraphRange.count, 69) 
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
        XCTAssertEqual(innerParagraphRange.count, 69) 
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
        XCTAssertEqual(innerParagraphRange.count, 69) 
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
        XCTAssertEqual(innerParagraphRange.count, 43) 
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
        XCTAssertEqual(innerParagraphRange.count, 43) 
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
        XCTAssertEqual(innerParagraphRange.count, 44) 
    }
    
}

// caret on Empty or Blank Line


// TextFields with caret on an Empty or Blank Line
extension FT_innerParagraph_Tests {
    
    func test_that_if_the_line_is_empty_it_returns_a_range_of_0_to_0() {
        let text = ""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 0)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 0)
    }
    
    func test_that_if_the_line_is_blank_it_returns_a_range_from_the_beginning_to_the_end_of_the_line() {
        let text = "                                 "
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 15)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 33)
    }
    
}


// TextFields with caret on a Non Empty or Blank Line
extension FT_innerParagraph_Tests {

    func test_that_if_there_is_no_blank_or_empty_line_before_and_after_the_caretLocation_then_the_innerParagraph_is_the_whole_content() {
        
    }

}


// TextViews with caret on an Empty or Blank Line
extension FT_innerParagraph_Tests {
    
    func test_that_it_works_if_there_is_only_a_single_Empty_Line_because_it_used_to_fail() {
        let text = """
this is something

and some more
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 18)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 18)
        XCTAssertEqual(innerParagraphRange.count, 1) 
        
    }
    
    func test_that_if_there_is_no_Non_Empty_Line_before_the_caretLocation_and_also_none_after_then_the_innerParagraph_is_the_whole_text() {
        let text = """




"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 1)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 3) 
    }
    
    func test_that_if_there_is_no_Non_Empty_Line_before_the_caretLocation_but_there_is_one_after_then_the_innerParagraph_is_from_the_beginning_of_the_text_to_the_beginning_of_the_Non_Empty_Line() {
        let text = """


hey there's a line here!
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 0)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 2) 
    }
    
    func test_that_if_there_is_a_Non_Empty_Line_before_the_caretLocation_but_not_after_then_the_innerParagraph_is_from_the_end_of_the_previous_Non_Empty_Line_to_the_end_of_the_text() {
        let text = """
hey there's a line here!





"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 27)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 25)
        XCTAssertEqual(innerParagraphRange.count, 4) 
    }
    
    func test_that_if_there_is_a_Non_Empty_Line_before_the_caretLocation_and_also_one_after_then_the_innerParagraph_is_from_the_end_of_the_previous_Non_Empty_Line_to_the_beginning_of_the_next_Non_Empty_Line() {
        let text = """
hehe
well done





my friend
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 18)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 15)
        XCTAssertEqual(innerParagraphRange.count, 5) 
    }
    
    // this test contains Blank Lines
    func test_that_it_works_if_there_is_only_a_single_Blank_Line_because_it_used_to_fail() {
        let text = """
this is something
         
and some more
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 18)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 18)
        XCTAssertEqual(innerParagraphRange.count, 10) 
        
    }

    
    // this test contains Blank Lines
    func test_that_if_there_is_no_Non_Blank_Line_before_the_caretLocation_and_also_none_after_then_the_innerParagraph_is_the_whole_text() {
        let text = """

          
        

"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 5)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 21) 
    }
    
    // this test contains Blank Lines
    func test_that_if_there_is_no_Non_Blank_Line_before_the_caretLocation_but_there_is_one_after_then_the_innerParagraph_is_from_the_beginning_of_the_text_to_the_beginning_of_the_Non_Blank_Line() {
        let text = """
                    
                
hey there's a line here!
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 3)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 38) 
    }
    
    // this test contains Blank Lines
    func test_that_if_there_is_a_Non_Blank_Line_before_the_caretLocation_but_not_after_then_the_innerParagraph_is_from_the_end_of_the_previous_Non_Blank_Line_to_the_end_of_the_text() {
        let text = """
hey there's a line here!

               

             
           
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 42)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 25)
        XCTAssertEqual(innerParagraphRange.count, 43) 
    }
    
    // this test contains Blank Lines
    func test_that_if_there_is_a_Non_Blank_Line_before_the_caretLocation_and_also_one_after_then_the_innerParagraph_is_from_the_end_of_the_previous_Non_Blank_Line_to_the_beginning_of_the_next_Non_Blank_Line() {
        let text = """
hehe
well done


            
             

my friend
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 16)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 15)
        XCTAssertEqual(innerParagraphRange.count, 30) 
    }
    
}


// TextViews with caret on a Non Empty or Blank Line
extension FT_innerParagraph_Tests {
    
    func test_that_if_there_are_no_Empty_Line_before_and_after_the_caretLocation_then_the_innerParagraph_is_the_whole_text() {
        let text = """
this text
is a whole
paragraph in
   itself
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 43) 
    }
    
    func test_that_if_there_is_an_Empty_Line_before_the_caretLocation_but_none_after_then_the_innerParagraph_is_from_the_end_of_the_Empty_Line_to_the_end_of_the_text() {
        let text = """
hehe

well done
my friend
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 6)
        XCTAssertEqual(innerParagraphRange.count, 19) 
    }
    
    func test_that_if_there_is_an_Empty_Line_after_the_caretLocation_but_none_before_then_the_innerParagraph_is_from_the_beginning_of_the_text_to_the_beginning_of_the_Empty_Line() {
        let text = """
hehe
well done

my friend
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 15) 
    }
    
    func test_that_if_there_is_an_Empty_Line_before_the_caretLocation_and_also_an_Empty_Line_after_the_caretLocation_then_the_innerParagraph_is_from_the_end_of_the_previous_Empty_Line_to_the_beginning_of_the_next_Empty_Line() {
        let text = """
hehe
well done

my friend
you are good

ok enough
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 22)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 16)
        XCTAssertEqual(innerParagraphRange.count, 23) 
    }
        
    // this test contains blank lines
    func test_that_if_there_is_a_Blank_Line_before_the_caretLocation_but_none_after_then_the_innerParagraph_is_from_the_end_of_the_Blank_Line_to_the_end_of_the_text() {
        let text = """
hehe
    
well done
my friend
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 13)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 10)
        XCTAssertEqual(innerParagraphRange.count, 19) 
    }
    
    // this test contains blank lines
    func test_that_if_there_is_a_Blank_Line_after_the_caretLocation_but_none_before_then_the_innerParagraph_is_from_the_beginning_of_the_text_to_the_beginning_of_the_Blank_Line() {
        let text = """
hehe
well done
     
my friend
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 15) 
    }
    
    // this test contains blank lines
    func test_that_if_there_is_a_Blank_Line_before_the_caretLocation_and_also_a_Blank_Line_after_the_caretLocation_then_the_innerParagraph_is_from_the_end_of_the_previous_Blank_Line_to_the_beginning_of_the_next_Blank_Line() {
        let text = """
hehe
well done
       
my friend
you are good
     
ok enough
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 29)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 23)
        XCTAssertEqual(innerParagraphRange.count, 23) 
    }

}
