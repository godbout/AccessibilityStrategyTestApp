@testable import AccessibilityStrategy
import XCTest
import Common


class ASUT_NM_n_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int? = 1, lastSearchCommand: SearchCommand, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.n(times: count, lastSearchCommand: lastSearchCommand, on: element)
    }
    
}


extension ASUT_NM_n_Tests {
    
    func test_that_if_lastSearchCommand_is_interrogationMark_it_simply_forwards_parameters_to_the_interrogationMark_move() {
        let text = "we gonna use the same sentence ☁️☁️☁️ to do the tests on the lastSearchCommand parameter"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 88,
            caretLocation: 87,
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
        
        let returnedElement = applyMoveBeingTested(times: 2, lastSearchCommand: SearchCommand(motion: .interrogationMark, searchString: "on"), on: element)

        XCTAssertEqual(returnedElement.caretLocation, 4)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_lastSearchCommand_is_slash_it_simply_forwards_parameters_to_the_slash_move() {
        let text = "we gonna use the same sentence ☁️☁️☁️ to do the tests on the lastSearchCommand parameter"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 88,
            caretLocation: 4,
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
        
        let returnedElement = applyMoveBeingTested(times: nil, lastSearchCommand: SearchCommand(motion: .slash, searchString: "ame"), on: element)

        XCTAssertEqual(returnedElement.caretLocation, 18)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
        
}
