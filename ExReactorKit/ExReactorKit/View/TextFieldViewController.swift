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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textfield.resignFirstResponder()
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
        
        reactor.state.compactMap { $0.lengthOfString }
            .map { "\($0)" }
            .distinctUntilChanged()
            .bind(to: lengthOfStringLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$alertMessage)
            .compactMap { $0 }
            .bind(with: self) {
                $0.showWarningAlert($1)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.backgroundColor }
            .distinctUntilChanged()
            .bind(to: view.rx.backgroundColor)
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
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
    func setupAttributes() {
        view.backgroundColor = UIColor.white
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fillProportionally
            $0.spacing = 10
        }
        
        textfield.do {
            $0.borderStyle = .bezel
        }
        textfield.becomeFirstResponder()
    }
}

// MARK: - Extensions
extension TextFieldViewController {
    func showWarningAlert(_ message: String) {
        // Clear all field and labels
        textfield.text?.removeAll()
        lengthOfStringLabel.text = "0"
        capitalizedStringLabel.text?.removeAll()
        
        // Show warning alert
        let alert = UIAlertController(
            title: "입력 오류",
            message: message,
            preferredStyle: .alert
        )
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}


