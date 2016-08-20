//
//  Provider.swift
//  NetworkExample
//
//  Created by Gianmaria Dal Maistro on 01/08/16.
//  Copyright © 2016 Whiteworld. All rights reserved.
//

import Foundation
import Moya

private extension String
{
    var URLEscapedString: String
    {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
}

enum APIProvider
{
    case Login(credentials: (String, String))
}

extension APIProvider : TargetType
{
    var baseURL: NSURL { return NSURL(string: "http://test.com")! }
    
    var path: String {
        switch self {
        case .Login:
            return "/login_app"
        }
    }
    
    var method: Moya.Method
    {
        return .GET
    }
    
    var parameters: [String: AnyObject]?
    {
        switch self {
        case .Login(let credentials):
            return ["req" : "{\"username\":\"\(credentials.0)\",\"password\":\"\(credentials.1)\"}"]
        }
    }
    
    var sampleData: NSData
    {
        switch self
        {
        case .Login(_):
            return "{\"result\":1,\"message\":\"Login effettuato con successo\",\"payload\":{\"token\":\"98dd40a1c15150696c17b0000b64713c549037be\",\"association\":1}}".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
    
    var multipartBody: [MultipartFormData]?
    {
        return nil
    }
}