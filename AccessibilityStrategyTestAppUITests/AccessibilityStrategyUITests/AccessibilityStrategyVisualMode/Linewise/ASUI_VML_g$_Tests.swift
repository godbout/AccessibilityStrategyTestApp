import XCTest
import AccessibilityStrategy
import Common


// VML g$ calls VML $. so tests are there.
// this is because in Visual Linestyle in Vim the whole FileLines are always selected,
// not the ScreenLines. in Vim we can still move one ScreenLine at a time, but in macOS it's not
// possible (can't have the selection + an idependent caret). in Vim we can move one ScreenLine at
// a time but STILL the selection is always FileLine.
class ASUI_VML_g$_Tests: ASUI_VM_BaseTests {}
