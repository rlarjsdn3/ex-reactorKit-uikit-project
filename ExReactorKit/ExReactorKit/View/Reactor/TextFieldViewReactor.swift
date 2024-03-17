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
        
        case showAlertMessage(String)
    }
    
    // MARK: - State
    struct State {
        var backgroundColor: UIColor?
        
        var lengthOfString: Int?
        var capitalizedString: String?
        
        @Pulse var alertMessage: String?
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
        case let .showAlertMessage(message):
            newState.alertMessage = message
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
