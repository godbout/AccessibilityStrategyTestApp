@testable import AccessibilityStrategy
import XCTest


// here we gonna test all the ATE computed properties to make sure that when
// we use them later in the moves they're not full of shit :D
// currently we are grouping the tests rather than testing each computed property
// independently because they will be tested by themselves through the move tests.
// those tests are not extra necessary, but because i'm dealing with the emojis now i wanna avoid headaches
// and make sure i get correct results from those computed properties.
// currently only testing computed properties, not funcs because lazy and also might change. if the funcs fail
// for sure the moves will fail and the tests will grab
class ATE_SimpleComputedProperties_Tests: XCTestCase {}


// without emojis
// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension ATE_SimpleComputedProperties_Tests {
    
    func test_that_without_emojis_if_the_TextElement_is_empty_the_computed_properties_are_correctly_calculated() {
        let text = ""
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 0,
            caretLocation: 0,
            selectedLength: 0,
            selectedText: "",
            fullyVisibleArea: 0..<0,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 0,
                number: 1,
                start: 0,
                end: 0
            )!
        )
        
        XCTAssertEqual(element.selectionLowerBound, 0)
        XCTAssertEqual(element.selectionUpperBound, 0)
        XCTAssertEqual(element.endLimit, 0)
        XCTAssertEqual(element.characterLength, 0)
        XCTAssertEqual(element.isEmpty, true)
        XCTAssertEqual(element.isNotEmpty, false)
        XCTAssertEqual(element.caretIsAtTheBeginning, true)
        XCTAssertEqual(element.caretIsNotAtTheBeginning, false)
        XCTAssertEqual(element.caretIsAtTheEnd, true)
        XCTAssertEqual(element.caretIsNotAtTheEnd, false)
        XCTAssertEqual(element.lastCharacterIsLinefeed, false)
        XCTAssertEqual(element.lastCharacterIsNotLinefeed, true)
    }
        
    func test_that_without_emojis_if_the_caret_is_at_the_last_character_of_the_TextElement_and_on_an_empty_line_the_computed_properties_are_correctly_calculated() {
        let text = """
caret is on its
own empty
line

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 31,
            caretLocation: 31,
            selectedLength: 0,
            selectedText: "",
            fullyVisibleArea: 0..<31,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 4,
                start: 31,
                end: 31
            )!
        )
        
        XCTAssertEqual(element.selectionLowerBound, 31)
        XCTAssertEqual(element.selectionUpperBound, 31)
        XCTAssertEqual(element.endLimit, 31)
        XCTAssertEqual(element.characterLength, 0)
        XCTAssertEqual(element.isEmpty, false)
        XCTAssertEqual(element.isNotEmpty, true)
        XCTAssertEqual(element.caretIsAtTheBeginning, false)
        XCTAssertEqual(element.caretIsNotAtTheBeginning, true)
        XCTAssertEqual(element.caretIsAtTheEnd, true)
        XCTAssertEqual(element.caretIsNotAtTheEnd, false)
        XCTAssertEqual(element.lastCharacterIsLinefeed, true)
        XCTAssertEqual(element.lastCharacterIsNotLinefeed, false)
    }
            
}


// without emojis
// other cases
extension ATE_SimpleComputedProperties_Tests {
    
    func test_that_without_emojis_in_normal_setting_the_computed_properties_are_correctly_calculated() {
        let text = "hehehe motherfuckers"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 20,
            caretLocation: 8,
            selectedLength: 1,
            selectedText: "o",
            fullyVisibleArea: 0..<20,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 20,
                number: 1,
                start: 0,
                end: 20
            )!
        )
        
        XCTAssertEqual(element.selectionLowerBound, 8)
        XCTAssertEqual(element.selectionUpperBound, 9)
        XCTAssertEqual(element.endLimit, 19)
        XCTAssertEqual(element.characterLength, 1)
        XCTAssertEqual(element.isEmpty, false)
        XCTAssertEqual(element.isNotEmpty, true)
        XCTAssertEqual(element.caretIsAtTheBeginning, false)
        XCTAssertEqual(element.caretIsNotAtTheBeginning, true)
        XCTAssertEqual(element.caretIsAtTheEnd, false)
        XCTAssertEqual(element.caretIsNotAtTheEnd, true)
        XCTAssertEqual(element.lastCharacterIsLinefeed, false)
        XCTAssertEqual(element.lastCharacterIsNotLinefeed, true)
    }
    
}


// with emojis
// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension ATE_SimpleComputedProperties_Tests {
    
    // well empty but with emojis. how does that work? :D
    func test_that_with_emojis_if_the_TextElement_is_empty_the_computed_properties_are_correctly_calculated() {}
    
    func test_that_with_emojis_if_the_caret_is_at_the_last_character_of_the_TextElement_and_on_an_empty_line_the_computed_properties_are_correctly_calculated() {
        let text = """
caret is on its
own empty
line 🌻️

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 35,
            caretLocation: 35,
            selectedLength: 0,
            selectedText: "",
            fullyVisibleArea: 0..<35,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 35,
                number: 4,
                start: 35,
                end: 35
            )!
        )
        
        XCTAssertEqual(element.selectionLowerBound, 35)
        XCTAssertEqual(element.selectionUpperBound, 35)
        XCTAssertEqual(element.endLimit, 35)
        XCTAssertEqual(element.characterLength, 0)
        XCTAssertEqual(element.isEmpty, false)
        XCTAssertEqual(element.isNotEmpty, true)
        XCTAssertEqual(element.caretIsAtTheBeginning, false)
        XCTAssertEqual(element.caretIsNotAtTheBeginning, true)
        XCTAssertEqual(element.caretIsAtTheEnd, true)
        XCTAssertEqual(element.caretIsNotAtTheEnd, false)
        XCTAssertEqual(element.lastCharacterIsLinefeed, true)
        XCTAssertEqual(element.lastCharacterIsNotLinefeed, false)
    }
    
}


extension ATE_SimpleComputedProperties_Tests {
    
    func test_that_with_emojis_in_normal_setting_the_computed_properties_are_correctly_calculated() {
        let text = "hehehe mot💌️😂️🇫🇷️rfuckers"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 29,
            caretLocation: 13,
            selectedLength: 3,
            selectedText: "😂️",
            fullyVisibleArea: 0..<29,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 29,
                number: 1,
                start: 0,
                end: 29
            )!
        )
        
        XCTAssertEqual(element.selectionLowerBound, 13)
        XCTAssertEqual(element.selectionUpperBound, 16)
        XCTAssertEqual(element.endLimit, 28)
        XCTAssertEqual(element.characterLength, 3)
        XCTAssertEqual(element.isEmpty, false)
        XCTAssertEqual(element.isNotEmpty, true)
        XCTAssertEqual(element.caretIsAtTheBeginning, false)
        XCTAssertEqual(element.caretIsNotAtTheBeginning, true)
        XCTAssertEqual(element.caretIsAtTheEnd, false)
        XCTAssertEqual(element.caretIsNotAtTheEnd, true)
        XCTAssertEqual(element.lastCharacterIsLinefeed, false)
        XCTAssertEqual(element.lastCharacterIsNotLinefeed, true)
    }
    
}
