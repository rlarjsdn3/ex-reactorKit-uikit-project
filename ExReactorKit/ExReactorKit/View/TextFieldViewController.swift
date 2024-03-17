//
//  ViewController.swift
//  ExReactorKit
//
//  Created by 김건우 on 3/17/24.
//

import UIKit

import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa

final class TextFieldViewController: UIViewController, View {

    // MARK: - Typealias
    typealias Reactor = TextFieldViewReactor
    
    // MARK: - Views
    var textfield: UITextField = UITextField()
    var capitalizedStringLabel: UILabel = UILabel()
    var lengthOfStringLabel: UILabel = UILabel()
    
    var stackView: UIStackView = UIStackView()
    
    // MARK: - Properties
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Intializer
    convenience init(reactor: TextFieldViewReactor) {
        self.init()
        self.reactor = reactor
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    // MARK: - Reactor
    func bind(reactor: TextFieldViewReactor) {
        textfield.rx.text.orEmpty
            .map { Reactor.Action.inputField($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.capitalizedString }
            .distinctUntilChanged()
            .bind(to: capitalizedStringLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.lengthOfString }
            .compactMap { $0 }
            .map { "\($0)" }
            .distinctUntilChanged()
            .bind(to: lengthOfStringLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Attributes
    func setupUI() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(capitalizedStringLabel)
        stackView.addArrangedSubview(lengthOfStringLabel)
        stackView.addArrangedSubview(textfield)
    }
    
    func setupAutoLayout() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
    func setupAttributes() {
        view.backgroundColor = UIColor.white
        
        stackView.do { view in
            view.axis = .vertical
            view.alignment = .fill
            view.distribution = .fillProportionally
            view.spacing = 10
        }
        
        textfield.do { view in
            view.borderStyle = .bezel
        }
    }
}

