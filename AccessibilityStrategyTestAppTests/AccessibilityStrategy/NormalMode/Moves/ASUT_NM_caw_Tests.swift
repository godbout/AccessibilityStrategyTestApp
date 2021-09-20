// TODO
//@testable import AccessibilityStrategy
//import XCTest
//
//
//// see ciw for blah blah
//class ASUT_NM_caw_Tests: ASNM_BaseTests {
//    
//    private func applyMove(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
//        return asNormalMode.caw(on: element) 
//    }
//    
//}
//
//
//// Both
//extension ASUT_NM_caw_Tests {
//    
//    func test_that_it_deletes_a_word_and_its_trailing_spaces_when_appropriate() {
//        let text = "a sentence with a word   or more..."
//        let element = AccessibilityTextElement(
//            role: .textField,
//            value: text,
//            length: 34,
//            caretLocation: 19,
//            selectedLength: 1,
//            selectedText: "o",
//            currentLine: AccessibilityTextElementLine(
//                fullValue: text,
//                number: 1,
//                start: 0,
//                end: 34
//            )
//        )
//        
//        let returnedElement = applyMove(on: element)
//        
//        XCTAssertEqual(returnedElement?.caretLocation, 18)
//        XCTAssertEqual(returnedElement?.selectedLength, 7)
//        XCTAssertEqual(returnedElement?.selectedText, "")     
//        
//    }
//    
//    func test_that_it_deletes_a_word_and_its_leading_spaces_when_appropriate() {
//        let text = "a sentence with a     word, or more..."
//        let element = AccessibilityTextElement(
//            role: .textField,
//            value: text,
//            length: 34,
//            caretLocation: 19,
//            selectedLength: 1,
//            selectedText: "o",
//            currentLine: AccessibilityTextElementLine(
//                fullValue: text,
//                number: 1,
//                start: 0,
//                end: 34
//            )
//        )
//        
//        let returnedElement = applyMove(on: element)
//        
//        XCTAssertEqual(returnedElement?.caretLocation, 17)
//        XCTAssertEqual(returnedElement?.selectedLength, 9)
//        XCTAssertEqual(returnedElement?.selectedText, "")     
//    }
//    
//}
//
//
//// TextViews
//extension ASUT_NM_caw_Tests {
//    
//    func test_that_it_stops_at_linefeeds_going_backward() {
//        let text = """
//can't go from
//one line to
//another
//"""   
//        let element = AccessibilityTextElement(
//            role: .textArea,
//            value: text,
//            length: 33,
//            caretLocation: 29,
//            selectedLength: 1,
//            selectedText: "t",
//            currentLine: AccessibilityTextElementLine(
//                fullValue: text,
//                number: 3,
//                start: 26,
//                end: 33
//            )
//        )
//        
//        let returnedElement = applyMove(on: element)
//        
//        XCTAssertEqual(returnedElement?.caretLocation, 26)
//        XCTAssertEqual(returnedElement?.selectedLength, 7)
//        XCTAssertEqual(returnedElement?.selectedText, "")     
//    }
//    
//    func test_that_it_stops_at_linefeeds_going_forward() {
//        let text = """
//can't go from
//one line to
//another
//"""   
//        let element = AccessibilityTextElement(
//            role: .textArea,
//            value: text,
//            length: 33,
//            caretLocation: 11,
//            selectedLength: 1,
//            selectedText: "o",
//            currentLine: AccessibilityTextElementLine(
//                fullValue: text,
//                number: 1,
//                start: 0,
//                end: 14
//            )
//        )
//        
//        let returnedElement = applyMove(on: element)
//        
//        XCTAssertEqual(returnedElement?.caretLocation, 8)
//        XCTAssertEqual(returnedElement?.selectedLength, 5)
//        XCTAssertEqual(returnedElement?.selectedText, "")     
//    }
//    
//}
//
//
//// emojis
//extension ASUT_NM_caw_Tests {
//    
//    func test_that_it_handles_emojis() {
//        let text = """
//need to deal with
//those faces 🥺️☹️😂️
//"""
//        let element = AccessibilityTextElement(
//            role: .textArea,
//            value: text,
//            length: 38,
//            caretLocation: 33,
//            selectedLength: 2,
//            selectedText: "☹️",
//            currentLine: AccessibilityTextElementLine(
//                fullValue: text,
//                number: 2,
//                start: 18,
//                end: 38
//            )
//        )
//        
//        let returnedElement = applyMove(on: element)
//        
//        XCTAssertEqual(returnedElement?.caretLocation, 29)
//        XCTAssertEqual(returnedElement?.selectedLength, 9)
//        XCTAssertEqual(returnedElement?.selectedText, "")
//    }
//    
//    func test_that_it_does_suck_emojis_when_needed() {        
//        let text = "gonna suck 🦆️   me   "
//        let element = AccessibilityTextElement(
//            role: .textArea,
//            value: text,
//            length: 22,
//            caretLocation: 10,
//            selectedLength: 1,
//            selectedText: " ",
//            currentLine: AccessibilityTextElementLine(
//                fullValue: text,
//                number: 1,
//                start: 0,
//                end: 22
//            )
//        )
//        
//        let returnedElement = applyMove(on: element)
//        
//        XCTAssertEqual(returnedElement?.caretLocation, 10)
//        XCTAssertEqual(returnedElement?.selectedLength, 4)
//        XCTAssertEqual(returnedElement?.selectedText, "")
//    }
//    
//}
