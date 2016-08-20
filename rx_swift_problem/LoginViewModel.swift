//
//  LoginModel.swift
//  NetworkExample
//
//  Created by Gianmaria Dal Maistro on 01/08/16.
//  Copyright © 2016 Whiteworld. All rights reserved.
//

import Foundation
import Moya
import Mapper
import Moya_ModelMapper
import RxOptional
import RxSwift
import RxCocoa

class LoginViewModel
{
    var provider : RxMoyaProvider<APIProvider>
    let userNameDriver : Driver<String>
    let passwordDriver : Driver<String>

    init(provider: RxMoyaProvider<APIProvider>, userName: Driver<String>, password: Driver<String>)
    {
        self.provider = provider
        self.userNameDriver = userName
        self.passwordDriver = password
        setup()
    }
    
    var credentials : Driver<(String, String)> {
        return Driver.combineLatest(userNameDriver.distinctUntilChanged(), passwordDriver.distinctUntilChanged()) { usr, pwd in
            return (usr, pwd)
        }
    }
    
    var usrValid : Driver<Bool> {
        get {
            return userNameDriver
                .throttle(0.5)
                .filterEmpty()
                .distinctUntilChanged()
                .map { ($0.rangeOfString("@") != nil) || ($0.utf8.count == 0) }
        }
    }
    
    var pwdValid : Driver<Bool> {
        get {
            return passwordDriver
            .throttle(0.5)
            .filterEmpty()
            .distinctUntilChanged()
            .map { ($0.utf8.count > 5) || ($0.utf8.count == 0) }
        }
    }

    var usernameBorderColor : Observable<UIColor>!
    var passwordBorderColor : Observable<UIColor>!

    var credentialValid : Driver<Bool> {
        return Driver.combineLatest(usrValid, pwdValid) { usr, pwd in
            return (usr && pwd)
        }
    }
    
    func setup()
    {
        usernameBorderColor = usrValid.asObservable()
                                .map{valid in
                                    return valid ? UIColor.clearColor() : UIColor.redColor()
                                }
        passwordBorderColor = pwdValid.asObservable()
                                .map{valid in
                                    return valid ? UIColor.clearColor() : UIColor.redColor()
        }
    }
    
    func login() -> Observable<Login?>
    {
        return credentials.asObservable()
            .observeOn(MainScheduler.instance)
            .debug()
            .flatMapLatest { [unowned self] credential -> Observable<Login?> in
                return self.makeLoginRequest(user: credential.0, password: credential.1)
            }
    }
    
    func makeLoginRequest(user user: String, password: String) -> Observable<Login?>
    {
        var resultLogin : Login
        if user == "test" && password == "123"
        {
            resultLogin = Login(result: 1, message: "OK")
        }
        else
        {
            resultLogin = Login(result: 0, message: "KO")
        }
        
        return Observable.create { [weak self] observer in
                observer.onNext(resultLogin)
                observer.onCompleted()
            
                return AnonymousDisposable {

                }
        }
    }
}