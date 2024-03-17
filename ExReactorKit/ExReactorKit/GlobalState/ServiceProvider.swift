//
//  GlobalStateProvider.swift
//  ExReactorKit
//
//  Created by 김건우 on 3/17/24.
//

import UIKit

import RxSwift

class BaseService {
    unowned let provider: ServiceProviderProtocol
    
    init(provider: ServiceProviderProtocol) {
        self.provider = provider
    }
}

enum SettingEvent {
    case setBackgroundColor(UIColor?)
}

protocol SettingServiceProtocol {
    var event: PublishSubject<SettingEvent> { get }
    
    @discardableResult
    func setBackgroundColor(_ color: UIColor?) -> Observable<UIColor?>
}

final class SettingService: BaseService, SettingServiceProtocol {
    var event: PublishSubject<SettingEvent> = PublishSubject<SettingEvent>()
    
    func setBackgroundColor(_ color: UIColor?) -> Observable<UIColor?> {
        event.onNext(.setBackgroundColor(color))
        return Observable<UIColor?>.just(color)
    }
}


protocol ServiceProviderProtocol: AnyObject {
    var settings: SettingServiceProtocol { get }
}

final class ServiceProvider: ServiceProviderProtocol {
    lazy var settings: SettingServiceProtocol = SettingService(provider: self)
}


