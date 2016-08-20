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

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        loginModel = LoginViewModel(provider: apiProvider, userName: userTextField.rx_text.asDriver(), password: pwdTextField.rx_text.asDriver())

        loginButton.rx_tap
            .doOn({[unowned self] _ in
                self.loginButton.enabled = false
                })
            .flatMap({[unowned self] in self.loginModel.login() })
            .subscribeNext({ [weak self] login  in
                self?.loginButton.enabled = true
                
                print(login?.message)

                guard login?.result == 1 else {
                    // Show error
                    return;
                }
                
                
                })
            .addDisposableTo(disposeBag)

    }
}

