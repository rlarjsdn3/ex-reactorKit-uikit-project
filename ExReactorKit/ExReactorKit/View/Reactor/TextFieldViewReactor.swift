//
//  TextFieldViewReactor.swift
//  ExReactorKit
//
//  Created by 김건우 on 3/17/24.
//

import UIKit

import ReactorKit
import RxSwift

final class TextFieldViewReactor: Reactor {
    // MARK: - Action
    enum Action {
        case inputField(String)
        case didTapSettingButton
    }
    
    // MARK: - Mutation
    enum Mutation {
        case setBackgroundColor(UIColor?)
        
        case setCapitalizedString(String)
        case setLengthOfString(Int)
        
        case showAlertMessage(String)
        case pushSettingViewController(UIViewController?)
    }
    
    // MARK: - State
    struct State {
        var backgroundColor: UIColor?
        
        var lengthOfString: Int?
        var capitalizedString: String?
        
        @Pulse var alertMessage: String?
        @Pulse var settingViewController: UIViewController?
    }
    
    // MARK: - Properties
    var initialState: State
    var provider: ServiceProviderProtocol
    
    // MARK: - Intializer
    init(
        backgroundColor color: UIColor? = nil,
        service provider: ServiceProviderProtocol
    ) {
        self.initialState = State(
            backgroundColor: color
        )
        self.provider = provider
    }
    
    // MARK: - Transform
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.settings.event
            .flatMap { event in
                switch event {
                case let .setBackgroundColor(color):
                    return Observable<Mutation>.just(.setBackgroundColor(color))
                }
            }
        
        return Observable<Mutation>.merge(mutation, eventMutation)
    }
    
    // MARK: - Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .inputField(input):
            if input.isNumber {
                return Observable<Mutation>.just(.showAlertMessage("소문자를 입력할 수 없습니다."))
            } else {
                let lengthOfString = input.count
                let capitalizedString = input.uppercased()
                return Observable<Mutation>.concat(
                    Observable.just(.setCapitalizedString(capitalizedString)),
                    Observable.just(.setLengthOfString(lengthOfString))
                )
            }
        case .didTapSettingButton:
            let reactor = SettingViewReactor(
                backgroundColor: currentState.backgroundColor,
                service: provider
            )
            let viewController = SettingViewController(reactor: reactor)
            return Observable<Mutation>.just(.pushSettingViewController(viewController))
        }
    }
    
    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setBackgroundColor(color):
            newState.backgroundColor = color
        case let .setCapitalizedString(string):
            newState.capitalizedString = string
        case let .setLengthOfString(length):
            newState.lengthOfString = length
        case let .showAlertMessage(message):
            newState.alertMessage = message
        case let .pushSettingViewController(vc):
            newState.settingViewController = vc
        }
        return newState
    }
}

extension String {
    var isNumber: Bool {
        return self.range(
            of: ".*[0-9]+.*",
            options: .regularExpression) != nil
    }
}
