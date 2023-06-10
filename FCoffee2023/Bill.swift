//
//  Bill.swift
//  FCoffee2023
//
//  Created by Koii on 5/31/23.
//  Copyright © 2023 Nguyen Le Tam. All rights reserved.
//

import Foundation

class Bill{
    private var id:Int
    private var tableId: Int
    private var dateCheckout:String
    private var totalPrice:Int
    private var status:Int
    
    init(id:Int, tableId:Int, dateCheckout:String, totalPrice:Int, status:Int) {
        self.id = id
        self.tableId = tableId
        self.dateCheckout = dateCheckout
        self.totalPrice = totalPrice
        self.status = status
    }
    init(id:Int){
        self.id = id
        self.tableId  =  0
        self.dateCheckout = ""
        self.totalPrice = 0
        self.status = 0
    }
    
    // Getter for id
    func getId() -> Int {
        return id
    }
    
    // Getter for tableId
    func getTableId() -> Int {
        return tableId
    }
    
    // Getter for dateCheckout
    func getDateCheckout() -> String {
        return dateCheckout
    }
    
    // Getter for totalPrice
    func getTotalPrice() -> Int {
        return totalPrice
    }
    
    // Getter for status
    func getStatus() -> Int {
        return status
    }
}
