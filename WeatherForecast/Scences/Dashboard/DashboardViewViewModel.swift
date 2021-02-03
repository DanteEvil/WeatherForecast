//
//  DashboardViewViewModel.swift
//  WeatherForecast
//
//  Created by Truong Le on 2/2/21.
//

import Foundation
import RxSwift
import RxSwiftExt
import RxCocoa

class DashboardViewViewModel {    
    let searchTextSubject = BehaviorSubject<String?>(value: nil)
    
    private let disposeBag = DisposeBag()
    private let searchResultSubject = PublishSubject<SearchResult>()
    private var webServices: WeatherWebservices!
    
    init(webServices: WeatherWebservices) {
        self.webServices = webServices
    }
    
    func fetchWeatherForeCastOf(city: String) -> Single<SearchResult> {
        return Single.create {[weak self] single in
            if let strongSelf = self {
                strongSelf.webServices.fetchWeatherForeCastOf(city: city) { result in
                    switch result {
                    case .success(let weather):
                        single(.success(SearchResult(list: weather?.list ?? [], error: nil)))
                    case .failure(let error):
                        single(.success(SearchResult(list: [], error: error)))
                    }
                }
            } else {
                single(.success(SearchResult(list: [], error: nil)))
            }
            return Disposables.create {}
        }
    }
    
    func layout(view: DashboardViewController) {
        view.errorWrapper.isHidden = true
        view.searchFieldWrapper.layer.cornerRadius = 6
        view.searchFieldWrapper.clipsToBounds = true
        view.searchTableView.tableFooterView = UIView()
    }
    
    func setupBinding(view: DashboardViewController) {
        view.searchTextField.rx.text.bind(to: searchTextSubject).disposed(by: disposeBag)
        searchTextSubject
            .distinctUntilChanged()
            .throttle(.milliseconds(500),
                      scheduler: MainScheduler.instance)
            .flatMapLatest {[weak self] (searchText) -> Observable<SearchResult> in
                guard let strongSelf = self, let unwrapText = searchText, unwrapText.count >= 3 else {
                    return Observable.create { observer in
                        observer.on(.next(SearchResult(list: [], error: nil)))
                        observer.on(.completed)
                        return Disposables.create {}
                    }
                }
                return strongSelf.fetchWeatherForeCastOf(city: unwrapText).asObservable()
            }.bind(to: searchResultSubject)
            .disposed(by: disposeBag)
        
        // Layout result list
        searchResultObservable().subscribe(onNext: {[weak blockView = view] result in
            blockView?.reloadData(result)
        }).disposed(by: disposeBag)
        
        // Layout error message
        searchErrorObservable().unwrap().map {$0.localizedDescription}.bind(to: view.errorLabel.rx.text).disposed(by: disposeBag)
        
        // Toggle Result/Error
        let hasError = hasErrorObservable()
        hasError.map {!$0}.bind(to: view.errorWrapper.rx.isHidden).disposed(by: disposeBag)
        hasError.bind(to: view.searchTableView.rx.isHidden).disposed(by: disposeBag)
    }
}

// MARK: Subscriptions
extension DashboardViewViewModel {
    func searchResultObservable() -> Observable<[WeatherByDay]> {
        return searchResultSubject.map {$0.list}.asObservable()
    }
    
    func searchErrorObservable() -> Observable<Error?> {
        return searchResultSubject.map {$0.error}.asObservable()
    }
    
    func hasErrorObservable() -> Observable<Bool> {
        return searchErrorObservable().map {$0 != nil}
    }
}
