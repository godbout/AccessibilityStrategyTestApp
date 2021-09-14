@testable import AccessibilityStrategy
import XCTest

class ASVM_BaseTests: XCTestCase {
    
    var asVisualMode: AccessibilityStrategyVisualMode!
    var textEngine = TextEngine()
    
    
    override func setUp() {
        super.setUp()
        
        // TODO: check if it's needed in setUp or could be set above
        asVisualMode = AccessibilityStrategyVisualMode()
    }    
    
}
