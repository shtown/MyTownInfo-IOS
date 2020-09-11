//
//  Facility.swift
//  YouthServices
//
//  Created by Southampton Dev on 7/22/16.
//  Copyright © 2016 TOS. All rights reserved.
//

import UIKit

class Facility: NSObject  {
    let ID: String?
    let Title: String?
    let Desc: String?
    let URL: String?
    let Name: String?
    
    init(ID: String,
         Title: String,
         Desc: String,
         URL: String,
         Name: String

        ) {
        
        self.ID = ID
        self.Title = Title
        self.Desc = Desc
        self.URL = URL
        self.Name = Name
        super.init()
    }
    
}
