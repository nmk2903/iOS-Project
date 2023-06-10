//
//  Category.swift
//  FCoffee2023
//
//  Created by Koii on 5/31/23.
//  Copyright © 2023 Nguyen Le Tam. All rights reserved.
//

import Foundation

class Category{
    private var id:Int
    private var name:String
    
    init?(id:Int, name:String){
        self.id = id
        self.name = name
    }
    
    public func getId()->Int{
        return id
    }
    
    public func getName()->String{
    return name
    }
}
