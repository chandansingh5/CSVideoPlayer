//
//  CommonMethods.swift
//  DemoPlayer
//
//  Created by Chandan Singh on 10/11/16.
//  Copyright © 2016 Chandan Singh. All rights reserved.
//

import Foundation


class CommonMethods {
    
    class func separatedByString(seprateStr:String ,fulname:String) -> (String,String){
        let fullNameArr : [String] = fulname.componentsSeparatedByString(seprateStr)
        guard fullNameArr.count > 0 else {
            return("","")
        }
        let firstName : String = fullNameArr[0]
        let lastName : String = fullNameArr[1]
        return (firstName,lastName)
    }
}