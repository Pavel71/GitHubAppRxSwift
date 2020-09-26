

import UIKit

enum SceneTransitionType {
  // you can extend this to add animated transition types,
  // interactive transitions and even child view controllers!

  case root       // make view controller the root view controller
  case push       // push view controller to navigation stack
  case modal(UIModalPresentationStyle)      // present view controller modally
}
