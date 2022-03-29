@testable import AccessibilityStrategy
import XCTest
import Common


class ASUT_NM_N__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int? = 1, lastSearchCommand: LastSearchCommand, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.N(times: count, lastSearchCommand: lastSearchCommand, on: element)
    }
    
}


extension ASUT_NM_N__Tests {
    
    func test_that_if_lastSearchCommand_is_interrogationMark_it_simply_forwards_parameters_to_the_slash_move() {
        let text = "we gonna use the same sentence ☁️☁️☁️ to do the tests on the lastSearchCommand parameter"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 88,
            caretLocation: 3,
            selectedLength: 1,
            selectedText: "t",
            fullyVisibleArea: 0..<88,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 88,
                number: 1,
                start: 0,
                end: 88
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 3, lastSearchCommand: LastSearchCommand(motion: .interrogationMark, searchString: "the"), on: element)

        XCTAssertEqual(returnedElement.caretLocation, 57)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_lastSearchCommand_is_slash_it_simply_forwards_parameters_to_the_interrogationMark_move() {
        let text = "we gonna use the same sentence ☁️☁️☁️ to do the tests on the lastSearchCommand parameter"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 88,
            caretLocation: 86,
            selectedLength: 1,
            selectedText: "t",
            fullyVisibleArea: 0..<88,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 88,
                number: 1,
                start: 0,
                end: 88
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 2, lastSearchCommand: LastSearchCommand(motion: .slash, searchString: "the"), on: element)

        XCTAssertEqual(returnedElement.caretLocation, 44)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
        
}
