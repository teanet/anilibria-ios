//
//  FavoriteViewModel.swift
//  Anilibria
//
//  Created by Ivan Morozov on 22.11.2024.
//  Copyright © 2024 Иван Морозов. All rights reserved.
//

import Combine
import Foundation

final class FavoriteViewModel: SeriesViewModelProtocol {
    private let limit: Int = 25
    private var nextPage: Int = 1
    private var pageSubscriber: AnyCancellable?
    private let service: FavoriteService

    let items = CurrentValueSubject<[Series], Never>([])
    private var currentItems: [Series] {
        items.value
    }

    var router: FavoriteRoutable?
    var filter: SeriesFilter = SeriesFilter()

    var select: ((Series) -> Void)?
    var delete: ((Series) -> Void)?

    private(set) lazy var pagination = PaginationViewModel { [weak self] completion in
        self?.loadPage(completion: completion)
    }

    init(service: FavoriteService) {
        self.service = service
    }

    func load(activity: ActivityDisposable?) {
        nextPage = 1
        pagination.isReady.send(false)
        pageSubscriber = service.fetchSeries(limit: limit, page: nextPage, filter: filter)
            .sink(onNext: { [weak self] items in
                self?.nextPage += 1
                self?.items.send(items)
                self?.pagination.isReady.send(true)
                activity?.dispose()
            }, onError: { [weak self] error in
                self?.router?.show(error: error)
                activity?.dispose()
            })
    }

    func remove(series: Series) {
        var newItems = currentItems
        newItems.removeAll(where: { $0.id == series.id })
        items.send(newItems)
    }

    func append(series: Series) {
        var newItems = currentItems
        newItems.insert(series, at: 0)
        items.send(newItems)
    }

    private func loadPage(completion: @escaping Action<Bool>) {
        pageSubscriber = service.fetchSeries(limit: limit, page: nextPage, filter: filter)
            .sink(onNext: { [weak self] items in
                self?.nextPage += 1
                if var currentItems = self?.currentItems {
                    currentItems.append(contentsOf: items)
                    self?.items.send(currentItems)
                }
                completion(items.isEmpty)
            }, onError: { [weak self] error in
                self?.router?.show(error: error)
                completion(false)
            })
    }
}
