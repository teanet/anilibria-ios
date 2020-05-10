import UIKit

final class SearchAssembly {
    class func createModule(parent: Router? = nil) -> SearchViewController {
        let module = SearchViewController()
        let router = SearchRouter(view: module, parent: parent)
        module.handler = MainAppCoordinator.shared.container.resolve()
        module.handler.bind(view: module, router: router)
        return module
    }
}

// MARK: - Route

protocol SearchRoute {
    func openSearchScreen()
}

extension SearchRoute where Self: RouterProtocol {
    func openSearchScreen() {
        let module = SearchAssembly.createModule(parent: self)
        module.modalTransitionStyle = .crossDissolve
        ModalRouter(target: module, parent: nil).move()
    }
}
