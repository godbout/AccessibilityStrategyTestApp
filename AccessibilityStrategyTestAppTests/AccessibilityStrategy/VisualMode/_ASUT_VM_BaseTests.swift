@testable import AccessibilityStrategy
import XCTest

// TODO: the class will have to be renamed
class ASVM_BaseTests: XCTestCase {
    
    let asVisualMode = AccessibilityStrategyVisualMode()
    
    func copyToClipboard(text: String) {
        return asVisualMode.copyToClipboard(text: text)
    }
    
}
