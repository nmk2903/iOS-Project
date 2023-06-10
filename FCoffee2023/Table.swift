//
//  Table.swift
//  FCoffee
//
//  Created by Koii on 5/14/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import Foundation

class Table{
    private var id:Int
    private var name:String
    private var status:String
    private var orderedTime:String?
    
    init(id: Int, name:String, status: String, orderedTime: String?) {
        self.id = id
        self.name = name
        self.status = status
        self.orderedTime = orderedTime
    }
    
    public func getId()->Int{
        return id
    }
    
    
    public func getName()->String{
        return name
    }
    
    public func getOrderedTime()->String{
        return orderedTime!
    }
    
    public func getCurrentStatus()->String{
        return status
    }
    
    public func checkAvailableTime()->Bool{
        guard let timeString = orderedTime else {
            // Nếu orderedTime là nil, return false
            return false
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm" // Định dạng của chuỗi thời gian đầu vào
        
        // Lấy thời gian hiện tại
        let currentDate = Date()
        
        // Chuyển đổi chuỗi thời gian đầu vào thành đối tượng Date
        guard let inputTime = dateFormatter.date(from: timeString) else {
            // Nếu quá trình chuyển đổi thất bại, return false
            return false
        }
        
        // Tính toán khoảng thời gian giữa thời gian đầu vào và thời gian hiện tại
        let timeInterval = inputTime.timeIntervalSince(currentDate)
        let minutesDifference = Int(timeInterval / 60)
        
        // Kiểm tra nếu khoảng thời gian lớn hơn 15 phút thì return false
        if minutesDifference > 15 {
            return false
        }
        
        return true
    }
}
