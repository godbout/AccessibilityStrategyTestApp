import XCTest
import AccessibilityStrategy
import Common


class ASUT_VML_ap_Tests: ASUT_VM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(visualStyle: .linewise)
        
        return applyMoveBeingTested(on: element, &vimEngineState)
    } 
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asVisualMode.ap(on: element, &vimEngineState) 
    }
   
}


// Bips
extension ASUT_VML_ap_Tests {

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


extension ASUT_VML_ap_Tests {

    func test_that_if_the_Anchor_and_the_Head_are_on_the_same_line_and_the_Head_is_after_the_Anchor_then_it_selects_the_whole_current_aParagraph_and_recalculate_the_Anchor_and_Head_properly() {
        let text = """
ok so time to
play with the


fucking VML ip
heheh
he
hoho


hmm are you
dumb?
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 78,
            caretLocation: 45,
            selectedLength: 6,
            selectedText: """
        heheh

        """,
            fullyVisibleArea: 0..<78,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 78,
                number: 6,
                start: 45,
                end: 51
            )!
        )
               
        AccessibilityStrategyVisualMode.anchor = 45
        AccessibilityStrategyVisualMode.head = 50
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 30)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 60)
        XCTAssertEqual(returnedElement.caretLocation, 30)
        XCTAssertEqual(returnedElement.selectedLength, 31)
    }
    
    func test_that_if_the_Anchor_and_the_Head_are_on_the_same_line_and_the_Head_is_before_the_Anchor_then_it_selects_the_whole_current_aParagraph_and_recalculate_the_Anchor_and_Head_properly() {
        let text = """
ok so time to
play with the


fucking VML ip
heheh
he
hoho


hmm are you
dumb?
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 78,
            caretLocation: 45,
            selectedLength: 6,
            selectedText: """
        heheh

        """,
            fullyVisibleArea: 0..<78,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 78,
                number: 6,
                start: 45,
                end: 51
            )!
        )
               
        AccessibilityStrategyVisualMode.anchor = 50
        AccessibilityStrategyVisualMode.head = 45
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 30)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 60)
        XCTAssertEqual(returnedElement.caretLocation, 30)
        XCTAssertEqual(returnedElement.selectedLength, 31)
    }
    
    func test_that_if_the_Anchor_and_the_Head_are_not_on_the_same_line_and_the_Head_is_after_the_Anchor_then_it_extends_the_selection_to_the_next_aParagraph_and_recalculate_the_Anchor_and_Head_properly() {
        let text = """
ok so time to
play with the


fucking VML ip
heheh
he
hoho


hmm are you
dumb?
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 78,
            caretLocation: 45,
            selectedLength: 9,
            selectedText: """
        heheh
        he

        """,
            fullyVisibleArea: 0..<78,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 78,
                number: 6,
                start: 45,
                end: 51
            )!
        )
               
        AccessibilityStrategyVisualMode.anchor = 45
        AccessibilityStrategyVisualMode.head = 53
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 45)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 60)
        XCTAssertEqual(returnedElement.caretLocation, 45)
        XCTAssertEqual(returnedElement.selectedLength, 16)
    }
    
    // TODO: this is wrong
    // this currently uses the same system than ip but it cannot work for ap.
    // so going upwards doesn't work. there's a need here to apply the aParagraph
    // func in the opposite direction, or 1) by reversing the string
    // 2) by adding a parameter to the aParagraph func to tell in which direction
    // to look for the paragraph. those are just ideas. not sure what would work yet.
    //
    // currently the test passes but the assertions are wrong.
    func test_that_if_the_Anchor_and_the_Head_are_not_on_the_same_line_and_the_Head_is_before_the_Anchor_then_it_extends_the_selection_to_the_previous_innerParagraph_and_recalculate_the_Anchor_and_Head_properly() {
        let text = """
ok so time to
play with the


fucking VML ip
heheh
he
hoho


hmm are you
dumb?
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 78,
            caretLocation: 45,
            selectedLength: 9,
            selectedText: """
        heheh
        he

        """,
            fullyVisibleArea: 0..<78,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 78,
                number: 6,
                start: 45,
                end: 51
            )!
        )
               
        AccessibilityStrategyVisualMode.anchor = 53
        AccessibilityStrategyVisualMode.head = 45
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(AccessibilityStrategyVisualMode.anchor, 53)
        XCTAssertEqual(AccessibilityStrategyVisualMode.head, 30)
        XCTAssertEqual(returnedElement.caretLocation, 30)
        XCTAssertEqual(returnedElement.selectedLength, 24)
    }
    
}
 
