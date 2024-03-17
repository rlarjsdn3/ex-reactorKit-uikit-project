//
//  SettingsViewController.swift
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

final class SettingViewController: UIViewController, View {

    // MARK: - Typealias
    typealias Reactor = SettingViewReactor
    
    // MARK: - Views
    var button: UIButton = UIButton(configuration: .borderedProminent())
    
    // MARK: - Properties
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Intializer
    convenience init(reactor: SettingViewReactor) {
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
    func bind(reactor: SettingViewReactor) {
        button.rx.tap
            .map { Reactor.Action.didTapButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.backgroundColor }
            .distinctUntilChanged()
            .bind(to: view.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Attributes
    func setupUI() {
        view.addSubview(button)
    }
    
    func setupAutoLayout() {
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func setupAttributes() {
        button.do {
            $0.setTitle("색상 바꾸기", for: .normal)
        }
    }
}
