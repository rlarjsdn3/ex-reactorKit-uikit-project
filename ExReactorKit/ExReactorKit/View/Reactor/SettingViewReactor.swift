//
//  SettingsViewReactor.swift
//  ExReactorKit
//
//  Created by 김건우 on 3/17/24.
//

import UIKit

import ReactorKit
import RxSwift

final class SettingViewReactor: Reactor {
    // MARK: - Action
    enum Action {
        case didTapButton
    }
    
    // MARK: - Mutation
    enum Mutation {
        case setBackgroundColor(UIColor?)
    }
    
    // MARK: - State
    struct State {
        var backgroundColor: UIColor?
    }
    
    // MARK: - Properties
    var initialState: State
    var provider: ServiceProviderProtocol
    
    let colors: [UIColor] = [.systemRed, .systemOrange, .systemYellow, .systemTeal, .systemGreen]
    
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
    
    // MARK: - Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapButton:
            let color = colors.randomElement()
            provider.settings.setBackgroundColor(color) // ⭐️
            return Observable<Mutation>.just(.setBackgroundColor(color))
        }
    }
    
    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setBackgroundColor(color):
            newState.backgroundColor = color
        }
        return newState
    }
}
