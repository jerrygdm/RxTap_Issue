//
//  Login.swift
//  rx_swift_problem
//
//  Created by Gianmaria Dal Maistro on 20/08/16.
//  Copyright © 2016 Whiteworld. All rights reserved.
//

import Foundation
import Mapper

struct Login
{
    var result : Int
    var message : String
    
    init(result : Int, message : String)
    {
        self.result = result
        self.message = message
    }
}