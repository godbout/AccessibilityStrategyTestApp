@testable import AccessibilityStrategy
import XCTest


// TODO: should we keep those UT here for motions that use ScreenLines?
// forgot if we define them all in UT and then explain that we forward them to UI
// or if we don't bother writing them in UT first?
// moved to UI coz ScreenLine
// even if not ultra necessary coz the move is not
// using count so we could pass CurrentScreenLine but still.
// now all ScreenLine moves are in UI for consistency and safety.
class ASUT_NM_gCaret_Tests: ASUT_NM_BaseTests {}
