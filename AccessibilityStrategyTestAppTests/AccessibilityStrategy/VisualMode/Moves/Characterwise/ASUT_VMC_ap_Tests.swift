import AccessibilityStrategy
import XCTest
import Common


// see VMC ip for blah blah
class ASUT_VMC_ap_Tests: ASUT_VM_BaseTests {

    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(visualStyle: .characterwise)
        
        return applyMoveBeingTested(on: element, &vimEngineState)
    } 
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asVisualMode.ap(on: element, &vimEngineState) 
    }
    
}


// Bips
extension ASUT_VMC_ap_Tests {

    func test_that_if_there_is_no_aParagraph_found_it_Bips() {
        let text = """
like this will Bip



"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 21,
            caretLocation: 20,
            selectedLength: 1,
            selectedText: """


        """,
            fullyVisibleArea: 0..<21,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 21,
                number: 3,
                start: 20,
                end: 21
            )!
        )
        
        AccessibilityStrategyVisualMode.anchor = 20
        AccessibilityStrategyVisualMode.head = 20
        
        var vimEngineState = VimEngineState(lastMoveBipped: false)
        let returnedElement = applyMoveBeingTested(on: element, &vimEngineState)
        
        
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 20)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 20)
        XCTAssertEqual(returnedElement.caretLocation, 20)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
        
        XCTAssertEqual(vimEngineState.lastMoveBipped, true)
    }
    
    func test_that_if_there_is_a_aParagraph_found_it_does_not_Bip() {
        let text = """
this will not



Bip
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 20,
            caretLocation: 15,
            selectedLength: 1,
            selectedText: """
        
        
        """,
            fullyVisibleArea: 0..<20,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 20,
                number: 3,
                start: 15,
                end: 16
            )!
        )
               
        AccessibilityStrategyVisualMode.anchor = 15
        AccessibilityStrategyVisualMode.head = 15
        
        var vimEngineState = VimEngineState(lastMoveBipped: false)
        let returnedElement = applyMoveBeingTested(on: element, &vimEngineState)
        
        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 14)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 19)
        XCTAssertEqual(returnedElement.caretLocation, 14)
        XCTAssertEqual(returnedElement.selectedLength, 6)
        
        XCTAssertEqual(vimEngineState.lastMoveBipped, false)
    }
    
}


extension ASUT_VMC_ap_Tests {

    func test_that_if_the_Head_is_after_the_Anchor_then_the_move_selects_the_whole_aParagraph_counting_from_the_Head_and_recalculate_the_Anchor_and_Head_properly() {
        let text = """
so we are in VMC
and some stuff

is selected over maybe
those two lines
and when we do ip

it's gonna select the whole
innerParagraph
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 133,
            caretLocation: 58,
            selectedLength: 19,
            selectedText: """
        ose two lines
        and w
        """,
            fullyVisibleArea: 0..<133,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 133,
                number: 5,
                start: 56,
                end: 72
            )!
        )
               
        AccessibilityStrategyVisualMode.anchor = 58
        AccessibilityStrategyVisualMode.head = 76
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 33)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 90)
        XCTAssertEqual(returnedElement.caretLocation, 33)
        XCTAssertEqual(returnedElement.selectedLength, 58)
    }
    
    func test_that_if_the_Head_is_before_the_Anchor_then_the_move_selects_the_whole_aParagraph_counting_from_the_Head_and_recalculate_the_Anchor_and_Head_properly() {
        let text = """
so we are in VMC
and some stuff

is selected over maybe
those two lines
and when we do ip

it's gonna select the whole
innerParagraph
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 133,
            caretLocation: 58,
            selectedLength: 19,
            selectedText: """
        ose two lines
        and w
        """,
            fullyVisibleArea: 0..<133,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 133,
                number: 5,
                start: 56,
                end: 72
            )!
        )
               
        AccessibilityStrategyVisualMode.anchor = 76
        AccessibilityStrategyVisualMode.head = 58
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 33)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 90)
        XCTAssertEqual(returnedElement.caretLocation, 33)
        XCTAssertEqual(returnedElement.selectedLength, 58)
    }
    
    func test_that_if_the_Head_and_the_Anchor_are_equal_then_the_move_selects_the_whole_aParagraph_counting_from_the_Head_and_recalculate_the_Anchor_and_Head_properly() {
        let text = """
so we are in VMC
and some stuff

is selected over maybe
those two lines
and when we do ip

it's gonna select the whole
innerParagraph
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 133,
            caretLocation: 100,
            selectedLength: 1,
            selectedText: """
        a
        """,
            fullyVisibleArea: 0..<133,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 133,
                number: 8,
                start: 91,
                end: 119
            )!
        )
               
        AccessibilityStrategyVisualMode.anchor = 100
        AccessibilityStrategyVisualMode.head = 100
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 90)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 132)
        XCTAssertEqual(returnedElement.caretLocation, 90)
        XCTAssertEqual(returnedElement.selectedLength, 43)
    }
    
}
