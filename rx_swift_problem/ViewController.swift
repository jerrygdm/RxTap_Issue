//
//  ViewController.swift
//  rx_swift_problem
//
//  Created by Gianmaria Dal Maistro on 20/08/16.
//  Copyright © 2016 Whiteworld. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

class ViewController: UIViewController
{
    @IBOutlet weak var userTextField : UITextField!
    @IBOutlet weak var pwdTextField : UITextField!
    @IBOutlet weak var loginButton : UIButton!

    var disposeBag = DisposeBag()
    
    var apiProvider = RxMoyaProvider<APIProvider>()
    
    var loginModel: LoginViewModel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = LoginViewModel(
            input: (
                userName: userTextField.rx_text.asDriver(),
                password: pwdTextField.rx_text.asDriver(),
                loginClick: loginButton.rx_tap.asObservable()
            ),
            dependency: (
                apiProvider
            )
        )
        
        viewModel.loginEnabled
            .subscribeNext { [weak self] valid  in
                self?.loginButton.enabled = valid
                self?.loginButton.alpha = valid ? 1.0 : 0.5
            }
            .addDisposableTo(self.disposeBag)

        viewModel.loggedIn
            .subscribeNext { login  in
                
                print(login.message)

                guard login.result == 1 else {
                    // Show error
                    return;
                }
                
                
                }
            .addDisposableTo(disposeBag)
        
        // Dismiss keyboard when tap on screen
        let tapBackground = UITapGestureRecognizer()
        tapBackground.cancelsTouchesInView = false
        tapBackground.rx_event
            .subscribeNext { [weak self] _ in
                self?.view.endEditing(true)
            }
            .addDisposableTo(disposeBag)
        
        view.addGestureRecognizer(tapBackground)

    }
}

