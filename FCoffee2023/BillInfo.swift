//
//  BillInfo.swift
//  FCoffee2023
//
//  Created by Koii on 5/31/23.
//  Copyright © 2023 Nguyen Le Tam. All rights reserved.
//

import Foundation

class BillInfo{
    private var id:Int
    private var mealId:Int
    private var count:Int
    private var billId:Int
    
    init(id: Int, mealId: Int, count: Int, billId: Int) {
        self.id = id
        self.mealId = mealId
        self.count = count
        self.billId = billId
    }
    
    func getId() -> Int {
        return id
    }
    
    func getMealId() -> Int {
        return mealId
    }
    
    func getCount() -> Int {
        return count
    }
    
    func getBillId() -> Int {
        return billId
    }
}
