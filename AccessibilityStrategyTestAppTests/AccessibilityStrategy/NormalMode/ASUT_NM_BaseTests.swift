@testable import AccessibilityStrategy
import XCTest

class ASNM_BaseTests: XCTestCase {
    
    var textEngine = TextEngine()
    var asNormalMode: AccessibilityStrategyNormalMode!
    
    
    override func setUp() {
        super.setUp()
           
        // TODO: check if it's needed in setUp or could be set above
        asNormalMode = AccessibilityStrategyNormalMode()
    }    
    
}
