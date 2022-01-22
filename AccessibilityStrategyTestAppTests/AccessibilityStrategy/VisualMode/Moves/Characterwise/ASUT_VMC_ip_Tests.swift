import AccessibilityStrategy
import XCTest
import Common


// TODO: this is different from iw at the first time you do ip. seems harder than iw.
class ASUT_VMC_ip_Tests: ASVM_BaseTests {

    private func applyMove(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        let state = VimEngineState(visualStyle: .characterwise)
        
        return asVisualMode.ip(on: element, state)
    }
    
}


// Both
extension ASUT_VMC_ip_Tests {}
