

import UIKit

extension Scene {
  
  func viewController() -> UIViewController {
    
    
    switch self {
      
    case .home(let viewModel):
      
     let vc = HomeViewController(viewModel: viewModel)
     let nc = UINavigationController(rootViewController: vc)
      return nc
      
    case .details(let viewModel):
      
      let vc = DetailsViewController(viewModel: viewModel)
      return vc
    }
    
  }
}
