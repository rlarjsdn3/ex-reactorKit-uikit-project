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
    }
    
    // MARK: - Mutation
    enum Mutation {
        case setCapitalizedString(String)
        case setLengthOfString(Int)
    }
    
    // MARK: - State
    struct State {
        var backgroundColor: UIColor?
        
        var capitalizedString: String?
        var lengthOfString: Int?
    }
    
    // MARK: - Properties
    var initialState: State
    
    // MARK: - Intializer
    init(backgroundColor color: UIColor? = nil) {
        self.initialState = State(
            backgroundColor: color
        )
    }
    
    // MARK: - Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .inputField(input):
            let capitalizedString = input.uppercased()
            let lengthOfString = input.count
            return Observable<Mutation>.concat(
                Observable.just(.setCapitalizedString(capitalizedString)),
                Observable.just(.setLengthOfString(lengthOfString))
            )
        }
    }
    
    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setCapitalizedString(string):
            newState.capitalizedString = string
        case let .setLengthOfString(length):
            newState.lengthOfString = length
        }
        return newState
    }
}
