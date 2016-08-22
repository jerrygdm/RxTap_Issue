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
    let validatedUsername: Driver<Bool>
    let validatedPassword: Driver<Bool>
    
    // Is login button enabled
    let loginEnabled: Observable<Bool>
    
    // Has user log in
    let loggedIn: Observable<Login>
    
    var usernameBorderColor : Observable<UIColor>
    var passwordBorderColor : Observable<UIColor>

    init(input: (
        userName: Driver<String>,
        password: Driver<String>,
        loginClick: Observable<Void>
        ),
        dependency: (
        RxMoyaProvider<APIProvider>
        )
        ) {
        
        let credentials = Driver.combineLatest(input.userName, input.password) { ($0, $1) }
        
        validatedUsername = input.userName.map { $0.rangeOfString("@") != nil }
        validatedPassword = input.password.map { $0.utf8.count > 5 }
        
        usernameBorderColor = validatedUsername.asObservable()
            .map{valid in
                return valid ? UIColor.clearColor() : UIColor.redColor()
        }
        passwordBorderColor = validatedPassword.asObservable()
            .map{valid in
                return valid ? UIColor.clearColor() : UIColor.redColor()
        }
        
        loginEnabled = Observable.combineLatest(
            validatedUsername.asObservable(),
            validatedPassword.asObservable()
        )   { username, password in
            username &&
            password
            }
            .distinctUntilChanged()
            .shareReplay(1)
        
        loggedIn = input.loginClick.withLatestFrom(credentials)
            .flatMap { username, password -> Observable<Login> in
                var resultLogin : Login
                if username == "test@" && password == "123123" {
                    resultLogin = Login(result: 1, message: "OK")
                }
                else {
                    resultLogin = Login(result: 0, message: "KO")
                }
                
                return Observable.create { observer in
                    observer.onNext(resultLogin)
                    observer.onCompleted()
                    
                    return AnonymousDisposable {
                        
                    }
                }
            }
            .retry()
            .shareReplay(1)
    }
}
