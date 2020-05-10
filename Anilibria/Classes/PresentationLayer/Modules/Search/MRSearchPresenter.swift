import DITranquillity
import RxSwift
import UIKit

final class SearchPart: DIPart {
    static func load(container: DIContainer) {
        container.register(SearchPresenter.init)
            .as(SearchEventHandler.self)
            .lifetime(.objectGraph)
    }
}

// MARK: - Presenter

final class SearchPresenter {
    private weak var view: SearchViewBehavior!
    private var router: SearchRoutable!

    private let feedService: FeedService
    private var bag: DisposeBag!
    private var currentQuery: String = ""

    init(feedService: FeedService) {
        self.feedService = feedService
    }
}

extension SearchPresenter: Loggable {
    var defaultLoggingTag: LogTag {
        return .presenter
    }
}

extension SearchPresenter: SearchEventHandler {
    func bind(view: SearchViewBehavior, router: SearchRoutable) {
        self.view = view
        self.router = router
    }

    func search(query: String) {
        self.currentQuery = query
        self.bag = DisposeBag()
        self.feedService.search(query: query)
            .subscribe(onSuccess: { [weak self] items in
                self?.handle(items)
            }, onError: { [weak self] error in
                self?.log(.error, error.message)
            })
            .disposed(by: self.bag)
    }

    func select(item: SearchValue) {
        self.router.execute(SearchResultCommand(value: item))
        self.router.back()
    }

    func back() {
        self.router.back()
    }

    private func handle(_ items: [Series]) {
        var values = items.map {
            SearchItem(.series($0))
        }

        if values.isEmpty && self.currentQuery.isEmpty == false {
            if (self.router.parentRouter is CatalogRoutable) == false {
                values.append(SearchItem(.filter))
            }
            values.append(SearchItem(.google(self.currentQuery)))
        }

        self.view.set(items: values)
    }
}

public struct SearchResultCommand: RouteCommand {
    let value: SearchValue
}
