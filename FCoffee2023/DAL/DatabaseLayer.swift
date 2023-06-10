//
//  DatabaseLayer.swift
//  FoodManagement
//
//  Created by Koii on 5/26/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import Foundation
import UIKit
import os.log

class DatabaseLayer{
    //MARK: Database's Properties
    private let DB_NAME = "FCOFFEE.sqlite"
    private var DB_PATH:String? = nil
    private var database:FMDatabase? = nil
    
    //MARK: Tables's Properties
    //1. Table meals
    private let MEAL_TABLE_NAME = "meals"
    private let MEAL_ID = "_id"
    private let MEAL_NAME = "name"
    private let MEAL_CATEGORY_ID = "category_id"
    private let MEAL_IMAGE = "image"
    private let MEAL_PRICE = "price"
    
    //2. Table table
    private let TABLE_TABLE_NAME = "tables"
    private let TABLE_ID = "_id"
    private let TABLE_NAME = "name"
    private let TABLE_STATUS = "status"
    private let TABLE_ORDERED_TIME = "orderedTime"
    
    
    //3. Table category
    private let CATEGORY_TABLE_NAME = "categories"
    private let CATEGORY_ID = "_id"
    private let CATEGORY_NAME = "name"
    
    //4. Table bill
    private let BILL_TABLE_NAME = "bills"
    private let BILL_ID = "_id"
    private let BILL_TABLE_ID = "tableId"
    private let BILL_DATE_CHECKOUT = "dateCheckout"
    private let BILL_TOTAL_PRICE = "totalPrice"
    private let BILL_STATUS = "status"
    
    //5. Table bill info
    private let BILL_INFO_TABLE_NAME = "billInfo"
    private let BILL_INFO_ID = "_id"
    private let BILL_INFO_MEAL_ID = "mealId"
    private let BILL_INFO_COUNT = "count"
    private let BILL_INFO_BILL_ID = "billId"
    
    //6. Table nhap hang
    private let NHAPHANG_TABLE_NAME = "nhapHang"
    private let NHAPHANG_ID = "_id"
    private let NHAPHANG_TENHANG = "tenHang"
    private let NHAPHANG_GIA = "gia"
    
    //MARK: CONSTRUCTOR
    init(){
//                let fileManager = FileManager.default
//                do {
//                    let fileURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//                        .appendingPathComponent("FCOFFEE.sqlite")
//                    try fileManager.removeItem(at: fileURL)
//                    print("Xóa cơ sở dữ liệu thành công.")
//                } catch {
//                    print("Không thể xóa cơ sở dữ liệu: \(error.localizedDescription)")
//                }
//                Lay duong dan cua cac thu muc trong ung dung iOS
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        
        //Khoi tao cho DB_PATH
        DB_PATH = directories[0] + "/" + DB_NAME
        
        //Khoi tao doi tuong database
        database = FMDatabase(path: DB_PATH)
        //Kiem tra su thanh cong khi khoi tao database
        if database != nil{
            os_log("Khoi tao co so du lieu thanh cong!")
            let _ = tablesCreation()
        }else {
            os_log("Khong the khoi tao co so du lieu!")
        }
        displayAllData()
//        print(getBillUncheck(tableId: 1)!)
//        test()
    }
    
    func displayAllData() {
        if open() {
            // Lấy dữ liệu từ bảng Meals
            let mealsSql = "SELECT * FROM \(MEAL_TABLE_NAME)"
            if let mealsResultSet = database?.executeQuery(mealsSql, withArgumentsIn: []) {
                print("###MEALS###")
                while mealsResultSet.next() {
                    let mealId = mealsResultSet.int(forColumn: MEAL_ID)
                    let mealName = mealsResultSet.string(forColumn: MEAL_NAME)
                    let mealCategoryId = mealsResultSet.int(forColumn: MEAL_CATEGORY_ID)
                    let mealImage = mealsResultSet.string(forColumn: MEAL_IMAGE)
                    let mealPrice = mealsResultSet.double(forColumn: MEAL_PRICE)
                    
                    print("Meal ID: \(mealId), Meal Name: \(mealName ?? ""), Category ID: \(mealCategoryId), Meal Price: \(mealPrice)")
                }
                mealsResultSet.close()
            } else {
                os_log("Error executing query for Meals table")
            }
            
            // Lấy dữ liệu từ bảng Tables
            let tablesSql = "SELECT * FROM \(TABLE_TABLE_NAME)"
            if let tablesResultSet = database?.executeQuery(tablesSql, withArgumentsIn: []) {
                print("###TABLES###")
                while tablesResultSet.next() {
                    let tableId = tablesResultSet.int(forColumn: TABLE_ID)
                    let tableName = tablesResultSet.string(forColumn: TABLE_NAME)
                    let tableStatus = tablesResultSet.string(forColumn: TABLE_STATUS)
                    let tableOrderedTime = tablesResultSet.string(forColumn: TABLE_ORDERED_TIME)
                    
                    print("Table ID: \(tableId), Table Name: \(tableName ?? ""), Table Status: \(tableStatus ?? ""), Table Ordered Time: \(tableOrderedTime ?? "")")
                }
                tablesResultSet.close()
            } else {
                os_log("Error executing query for Tables table")
            }
            
            // Lấy dữ liệu từ bảng Categories
            let categoriesSql = "SELECT * FROM \(CATEGORY_TABLE_NAME)"
            if let categoriesResultSet = database?.executeQuery(categoriesSql, withArgumentsIn: []) {
                                print("###CATEGORIES###")
                while categoriesResultSet.next() {
                    let categoryId = categoriesResultSet.int(forColumn: CATEGORY_ID)
                    let categoryName = categoriesResultSet.string(forColumn: CATEGORY_NAME)
                    
                    print("Category ID: \(categoryId), Category Name: \(categoryName ?? "")")
                }
                categoriesResultSet.close()
            } else {
                os_log("Error executing query for Categories table")
            }
            
            // Lấy dữ liệu từ bảng Bills
            let billsSql = "SELECT * FROM \(BILL_TABLE_NAME)"
            if let billsResultSet = database?.executeQuery(billsSql, withArgumentsIn: []) {
                                print("###BILLS###")
                while billsResultSet.next() {
                    let billId = billsResultSet.int(forColumn: BILL_ID)
                    let tableId = billsResultSet.int(forColumn: BILL_TABLE_ID)
                    let dateCheckout = billsResultSet.string(forColumn: BILL_DATE_CHECKOUT)
                    let totalPrice = billsResultSet.double(forColumn: BILL_TOTAL_PRICE)
                    let status = billsResultSet.int(forColumn: BILL_STATUS)
                    
                    print("Bill ID: \(billId), Table ID: \(tableId), Date Checkout: \(dateCheckout ?? ""), Total Price: \(totalPrice), Status: \(status)")
                }
                billsResultSet.close()
            } else {
                os_log("Error executing query for Bills table")
            }
            
            // Lấy dữ liệu từ bảng BillInfo
            let billInfoSql = "SELECT * FROM \(BILL_INFO_TABLE_NAME)"
            if let billInfoResultSet = database?.executeQuery(billInfoSql, withArgumentsIn: []) {
                                print("###BILLINFO###")
                while billInfoResultSet.next() {
                    let billInfoId = billInfoResultSet.int(forColumn: BILL_INFO_ID)
                    let mealId = billInfoResultSet.int(forColumn: BILL_INFO_MEAL_ID)
                    let count = billInfoResultSet.int(forColumn: BILL_INFO_COUNT)
                    let billId = billInfoResultSet.int(forColumn: BILL_INFO_BILL_ID)
                    
                    print("Bill Info ID: \(billInfoId), Meal ID: \(mealId), Count: \(count), Bill ID: \(billId)")
                }
                billInfoResultSet.close()
            } else {
                os_log("Error executing query for BillInfo table")
            }
            
            // Tiếp tục lấy dữ liệu từ các bảng khác
            
            let _ = close()
        }
    }

    func test(){
        if open(){
            //Xay dung cau lenh sql
            let sql = "SELECT \(BILL_TABLE_ID) FROM \(BILL_TABLE_NAME) WHERE \(BILL_TABLE_ID) = 1 AND STATUS = 0"
            //Thuc thi cau lenh sql
            
            //Goi lenh thuc thi
            if let resultSet = database?.executeQuery(sql, withArgumentsIn: []) {
                if resultSet.next() {
                    let billTableId = resultSet.int(forColumnIndex: 0)
                    print("Bill Table ID: \(billTableId)")                }
                
                resultSet.close()
            } else {
                os_log("Lỗi truy vấn")
            }
        }
        let _ = close()
    }
    
    /////////////////////////////////////////////////////////////
    //MARK: Dinh nghia cac ham Primitives
    /////////////////////////////////////////////////////////////
    
    //1.Kiem tra su ton tai cua database
    private func isDatabaseExist()->Bool{
        return (database != nil)
    }
    
    //2.Mo database
    private func open()->Bool{
        var ok = false
        if isDatabaseExist(){
            if database!.open(){
                ok = true
                os_log("Mo co so du lieu thanh cong!")
            }else {
                os_log("Khong the mo co so du lieu!")
            }
        }
        return ok
    }
    
    //3. Dong database
    private func close()->Bool{
        var ok = false
        if isDatabaseExist(){
            if database!.close(){
                ok = true
                os_log("Dong co so du lieu thanh cong!")
            }else {
                os_log("Khong the dong co so du lieu!")
            }
        }
        return ok
    }
    //4. Tao cac bang co so du lieu
    private func tablesCreation() -> Bool {
        var ok = false
        
        if open() {
            // Tạo bảng Meals
            let sqlMeal = """
            CREATE TABLE \(MEAL_TABLE_NAME) (
            \(MEAL_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
            \(MEAL_NAME) TEXT,
            \(MEAL_CATEGORY_ID) INTEGER,
            \(MEAL_IMAGE) TEXT,
            \(MEAL_PRICE) REAL
            );
            """
            
            if database!.executeStatements(sqlMeal) {
                os_log("Tạo bảng Meals thành công!")
            } else {
                os_log("Không thể tạo bảng Meals!")
            }
            
            // Tạo bảng Tables
            let sqlTable = """
            CREATE TABLE \(TABLE_TABLE_NAME) (
            \(TABLE_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
            \(TABLE_NAME) TEXT,
            \(TABLE_STATUS) TEXT DEFAULT "empty",
            \(TABLE_ORDERED_TIME) TEXT NULL
            );
            """
            
            if database!.executeStatements(sqlTable){
                os_log("Tạo bảng Tables thành công!")
            } else {
                os_log("Không thể tạo bảng Tables!")
            }
            
            // Tạo bảng Categories
            let sqlCategory = """
            CREATE TABLE \(CATEGORY_TABLE_NAME) (
            \(CATEGORY_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
            \(CATEGORY_NAME) TEXT
            );
            """
            
            if database!.executeStatements(sqlCategory){
                os_log("Tạo bảng Categories thành công!")
            } else {
                os_log("Không thể tạo bảng Categories!")
            }
            
            // Tạo bảng Bills
            let sqlBill = """
            CREATE TABLE \(BILL_TABLE_NAME) (
            \(BILL_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
            \(BILL_TABLE_ID) INTEGER,
            \(BILL_DATE_CHECKOUT) TEXT NULL,
            \(BILL_TOTAL_PRICE) INTEGER NULL,
            \(BILL_STATUS) INTEGER DEFAULT 0
            );
            """
            
            if database!.executeStatements(sqlBill){
                os_log("Tạo bảng Bills thành công!")
            } else {
                os_log("Không thể tạo bảng Bills!")
            }
            
            // Tạo bảng BillInfo
            let sqlBillInfo = """
            CREATE TABLE \(BILL_INFO_TABLE_NAME) (
            \(BILL_INFO_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
            \(BILL_INFO_MEAL_ID) INTEGER,
            \(BILL_INFO_COUNT) INTEGER,
            \(BILL_INFO_BILL_ID) INTEGER
            );
            """
            
            if database!.executeStatements(sqlBillInfo){
                os_log("Tạo bảng BillInfo thành công!")
            } else {
                os_log("Không thể tạo bảng BillInfo!")
            }
            
            //Tao bang NhapHang
            let sqlNhapHang = """
            CREATE TABLE \(NHAPHANG_TABLE_NAME) (
            \(NHAPHANG_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
            \(NHAPHANG_TENHANG) TEXT,
            \(NHAPHANG_GIA) INTEGER
            );
            """
            
            if database!.executeStatements(sqlNhapHang) {
                os_log("Tạo bảng Nhập hàng thành công!")
                return true
            } else {
                os_log("Không thể tạo bảng Nhập hàng!")
                return false
            }
            
            ok = true
            let _ = close()
        }
        
        return ok
    }
    
    /////////////////////////////////////////////////////////////
    //MARK: Dinh nghia cac ham APIs
    /////////////////////////////////////////////////////////////
    //CATEGORY
    //Ghi category vao database
    public func insertCategory(category: Category)->Bool{
        var ok = false
        if open(){
            //Xay dung cau lenh sql
            let sql = "INSERT INTO \(CATEGORY_TABLE_NAME) (\(CATEGORY_NAME)) VALUES (?)"
            //Thuc thi cau lenh sql
            
            //Goi lenh thuc thi
            if database!.executeUpdate(sql, withArgumentsIn: [category.getName()]) {
                ok = true
                os_log("Bien category duoc ghi thanh cong vao database")
            }else{
                os_log("Khong the ghi category vao database")
            }
        }
        let _ = close()
        return ok
    }
    
    //Xoa category
    public func deleteCategory(categoryId: Int) -> Bool {
        var ok = false
        
        if open() {
            // Xây dựng câu lệnh SQL
            let sql = "DELETE FROM \(CATEGORY_TABLE_NAME) WHERE \(CATEGORY_ID) = ?"
            
            // Thực thi câu lệnh SQL để xóa dữ liệu từ database
            if database!.executeUpdate(sql, withArgumentsIn: [categoryId]) {
                ok = true
                os_log("Xóa dữ liệu từ bảng Categories thành công")
            } else {
                os_log("Không thể xóa dữ liệu từ bảng Categories")
            }
            
            let _ = close()
        }
        
        return ok
    }
    
    //Doc toan bo category tu co so du lieu ve cateogryList cua tableview
    public func getAllCategories(categories: inout [Category]){
        if open(){
            var result:FMResultSet?
            //Xay dung cau lenh sql
            let sql = "SELECT * FROM \(CATEGORY_TABLE_NAME) ORDER BY \(CATEGORY_ID) DESC"
            //Bat exception
            do{
                //Thuc thi cau lenh sql
                result = try database!.executeQuery(sql, values: nil)
            }
            catch{
                os_log("Khong the doc meals tu database")
            }
            
            //Xu ly du lieu doc ve
            if let result = result {
                while result.next(){
                    let id = result.int(forColumn: CATEGORY_ID)
                    let name = result.string(forColumn: CATEGORY_NAME) ?? ""
                    if let category = Category(id: Int(id), name: name){
                        categories.append(category)
                    }
                }
            }
            let _ = close()
        }
    }
    //Update category
    public func updateCategory(category: Category) -> Bool {
        var ok = false
        
        if open() {
            let sql = "UPDATE \(CATEGORY_TABLE_NAME) SET \(CATEGORY_NAME) = ? WHERE \(CATEGORY_ID) = ?"
            
            if database!.executeUpdate(sql, withArgumentsIn: [category.getName(), category.getId()]) {
                ok = true
                os_log("Cập nhật danh mục vào cơ sở dữ liệu thành công")
            } else {
                os_log("Không thể cập nhật danh mục vào cơ sở dữ liệu")
            }
            
            let _ = close()
        }
        
        return ok
    }
    
    //MEAL
    //Ghi bien meal vao database
    public func insertMeal(meal: Meal)->Bool{
        var ok = false
        if open(){
            //Xay dung cau lenh sql
            let sql = "INSERT INTO \(MEAL_TABLE_NAME) (\(MEAL_NAME), \(MEAL_CATEGORY_ID), \(MEAL_IMAGE), \(MEAL_PRICE)) VALUES (?, ?, ?, ?)"
            //Thuc thi cau lenh sql
            //B1: Chuyen anh thanh chuoi
            var strImage = ""
            if let image = meal.getImg(){
                //B1.1: Chuyen anh thanh NSData
                let dataImage = image.pngData()! as NSData
                //B1.2 Chuyen NSDAta ve String
                strImage = dataImage.base64EncodedString(options: .lineLength64Characters)
            }
            //B2: Goi lenh thuc thi sql de ghi meal vao database
            if database!.executeUpdate(sql, withArgumentsIn: [meal.getName(), meal.getCategoryId(), strImage, meal.getPrice()]) {
                ok = true
                os_log("Bien meal duoc ghi thanh cong vao database")
            }else{
                os_log("Khong the ghi meal vao database")
            }
        }
        let _ = close()
        return ok
    }
    
    //Cap nhat meal
    public func updateMeal(meal: Meal) -> Bool {
        var ok = false
        if open() {
            // Xây dựng câu lệnh SQL
            let sql = "UPDATE \(MEAL_TABLE_NAME) SET \(MEAL_NAME) = ?, \(MEAL_CATEGORY_ID) = ?, \(MEAL_IMAGE) = ?, \(MEAL_PRICE) = ? WHERE \(MEAL_ID) = ?"
            
            // Bước 1: Chuyển ảnh thành chuỗi nếu có
            var strImage = ""
            if let image = meal.getImg() {
                let dataImage = image.pngData()! as NSData
                strImage = dataImage.base64EncodedString(options: .lineLength64Characters)
            }
            
            // Bước 2: Gọi lệnh thực thi SQL để cập nhật meal trong database
            if database!.executeUpdate(sql, withArgumentsIn: [meal.getName(), meal.getCategoryId(), strImage, meal.getPrice(), meal.getId()]) {
                ok = true
                os_log("Meal được cập nhật thành công trong database")
            } else {
                os_log("Không thể cập nhật meal trong database")
            }
        }
        let _ = close()
        return ok
    }

    
    //Doc toan bo meal tu co so du lieu ve meallist cua tableview
    public func getAllMeals(meals: inout [Meal]){
        if open(){
            var result:FMResultSet?
            //Xay dung cau lenh sql
            let sql = "SELECT * FROM \(MEAL_TABLE_NAME) ORDER BY \(MEAL_ID) DESC"
            //Bat exception
            do{
                //Thuc thi cau lenh sql
                result = try database!.executeQuery(sql, values: nil)
            }
            catch{
                os_log("Khong the doc meals tu database")
            }
            
            //Xu ly du lieu doc ve
            if let result = result {
                while result.next(){
                    let id = result.int(forColumn: MEAL_ID)
                    let name = result.string(forColumn: MEAL_NAME) ?? ""
                    let categoryId = result.int(forColumn: MEAL_CATEGORY_ID)
                    let price = result.int(forColumn: MEAL_PRICE)
                    var image:UIImage? = nil
                    let strImage = result.string(forColumn: MEAL_IMAGE) ?? ""
                    if !strImage.isEmpty {
                        //B1. Chuyen string thanh data
                        let dataImage = Data(base64Encoded: strImage, options: .ignoreUnknownCharacters)
                        //B2. Chuyen thanh UIImage
                        image = UIImage(data: dataImage!)
                    }
                    
                    //Tao bien meal tu du lieu doc ve
                    if let meal = Meal(id: Int(id), name: name, img: image, categoryId: Int(categoryId), price: Int(price)){
                        meals.append(meal)
                    }
                }
            }
            let _ = close()
        }
    }
    
    //Delete meal
    public func deleteMeal(mealId: Int) -> Bool {
        var ok = false
        
        if open() {
            // Xây dựng câu lệnh SQL
            let sql = "DELETE FROM \(MEAL_TABLE_NAME) WHERE \(MEAL_ID) = ?"
            
            // Thực thi câu lệnh SQL để xóa dữ liệu từ database
            if database!.executeUpdate(sql, withArgumentsIn: [mealId]) {
                ok = true
                os_log("Xóa dữ liệu từ bảng Meals thành công")
            } else {
                os_log("Không thể xóa dữ liệu từ bảng Meals")
            }
            
            let _ = close()
        }
        
        return ok
    }

    
    //Lay meal dua tren category_id
    public func getMealsByCategoryId(categoryId: Int, meals: inout [Meal]) {
        if open() {
            var result: FMResultSet?
            
            // Xây dựng câu lệnh SQL
            let sql = "SELECT * FROM \(MEAL_TABLE_NAME) WHERE \(MEAL_CATEGORY_ID) = ?"
            
            // Thực thi câu lệnh SQL và bắt exception
            do {
                result = try database!.executeQuery(sql, values: [categoryId])
            } catch {
                os_log("Không thể đọc món ăn từ cơ sở dữ liệu")
            }
            
            // Xử lý dữ liệu đọc về
            if let result = result {
                while result.next() {
                    let id = result.int(forColumn: MEAL_ID)
                    let name = result.string(forColumn: MEAL_NAME) ?? ""
                    let categoryId = result.int(forColumn: MEAL_CATEGORY_ID)
                    let price = result.int(forColumn: MEAL_PRICE)
                    var image:UIImage? = nil
                    let strImage = result.string(forColumn: MEAL_IMAGE) ?? ""
                    if !strImage.isEmpty {
                        //B1. Chuyen string thanh data
                        let dataImage = Data(base64Encoded: strImage, options: .ignoreUnknownCharacters)
                        //B2. Chuyen thanh UIImage
                        image = UIImage(data: dataImage!)
                    }
                    
                    if let meal = Meal(id: Int(id), name: name, img: image, categoryId: Int(categoryId), price: Int(price)){
                        meals.append(meal)
                    }
                }
            }
            
            let _ = close()
        }
    }
    
    
    //BILL
    //Ghi bill vao database
    public func insertBill(tableId: Int) -> Bool {
        var ok = false
        
        if open() {
            // Build the SQL statement
            let sql = "INSERT INTO \(BILL_TABLE_NAME) (\(BILL_TABLE_ID)) VALUES (?)"
            
            // Execute the SQL statement to insert the bill into the database
            if database!.executeUpdate(sql, withArgumentsIn: [tableId]) {
                ok = true
                os_log("Inserted bill into the database")
            } else {
                os_log("Failed to insert bill into the database")
            }
            
            let _ = close()
        }
        
        return ok
    }
		
//    public func insertBill(bill: Bill)->Bool{
//        var ok = false
//
//        if open() {
//            // Xây dựng câu lệnh SQL
//            let sql = "INSERT INTO \(BILL_TABLE_NAME) (\(BILL_TABLE_ID), \(BILL_DATE_CHECKOUT), \(BILL_TOTAL_PRICE), \(BILL_STATUS)) VALUES (?, ?, ?, ?)"
//
//            // Thực thi câu lệnh SQL để ghi dữ liệu vào database
//            if database!.executeUpdate(sql, withArgumentsIn: [bill.getTableId(), bill.getDateCheckout(), bill.getTotalPrice(), bill.getStatus()]) {
//                ok = true
//                os_log("Ghi dữ liệu vào bảng Bills thành công")
//            } else {
//                os_log("Không thể ghi dữ liệu vào bảng Bills")
//            }
//
//            let _ = close()
//        }
//
//        return ok
//    }
    
    //Doc toan bo bill tu co so du lieu
    public func getAllBills(bills: inout [Bill]) {
        if open() {
            var result: FMResultSet?
            
            // Xây dựng câu lệnh SQL
            let sql = "SELECT * FROM \(BILL_TABLE_NAME) ORDER BY \(BILL_ID) DESC"
            
            // Thực thi câu lệnh SQL và bắt exception
            do {
                result = try database!.executeQuery(sql, values: nil)
            } catch {
                os_log("Không thể đọc hóa đơn từ cơ sở dữ liệu")
            }
            
            // Xử lý dữ liệu đọc về
            if let result = result {
                while result.next() {
                    let id = result.int(forColumn: BILL_ID)
                    let tableId = result.int(forColumn: BILL_TABLE_ID)
                    let dateCheckout = result.string(forColumn: BILL_DATE_CHECKOUT) ?? ""
                    let totalPrice = result.int(forColumn: BILL_TOTAL_PRICE)
                    
                    let bill = Bill(id: Int(id), tableId: Int(tableId), dateCheckout: dateCheckout, totalPrice: Int(totalPrice), status: 0)
                    bills.append(bill)
                }
            }
            let _ = close()
        }
    }
    
    //BILL INFO
    //THEM BILLINFO
//    func insertBillInfo(billId: Int, beverageId: Int, count: Int) {
//
//        if open(){
//            let sqlCheckExists = """
//    SELECT \(BILL_INFO_BILL_ID), \(BILL_INFO_COUNT)
//    FROM \(BILL_INFO_ID)
//    WHERE \(BILL_INFO_BILL_ID) = ? AND \(BILL_INFO_MEAL_ID) = ?
//    """
//
//            let resultSet = database?.executeUpdate(sqlCheckExists, withArgumentsIn: [billId, beverageId])
//            var isExists = false
//            var beverageCount = 0
//
//
//            if let resultSet = resultSet, resultSet.next() {
//                isExists = true
//                beverageCount = resultSet.int(forColumn: "Count")
//            }
//
//            resultSet.close()
//
//            // Thực hiện các thao tác tương ứng
//            if isExists {
//                let newCount = beverageCount + count
//
//                if newCount > 0 {
//                    let sqlUpdate = """
//            UPDATE BillInfo
//            SET Count = ?
//            WHERE BillId = ? AND BeverageId = ?
//            """
//
//                    let success = database.executeUpdate(sqlUpdate, withArgumentsIn: [newCount, billId, beverageId])
//                    if success {
//                        print("Cập nhật BillInfo thành công")
//                    } else {
//                        print("Không thể cập nhật BillInfo")
//                    }
//                } else {
//                    let sqlDelete = """
//            DELETE FROM BillInfo
//            WHERE BillId = ? AND BeverageId = ?
//            """
//
//                    let success = database.executeUpdate(sqlDelete, withArgumentsIn: [billId, beverageId])
//                    if success {
//                        print("Xóa BillInfo thành công")
//                    } else {
//                        print("Không thể xóa BillInfo")
//                    }
//                }
//            } else {
//                let sqlInsert = """
//        INSERT INTO BillInfo (BillId, BeverageId, Count)
//        VALUES (?, ?, ?)
//        """
//
//                let success = database.executeUpdate(sqlInsert, withArgumentsIn: [billId, beverageId, count])
//                if success {
//                    print("Thêm BillInfo thành công")
//                } else {
//                    print("Không thể thêm BillInfo")
//                }
//            }
//
//        }
//        // Kiểm tra xem BillInfo đã tồn tại trong bảng
//    }
//    //tao proc
//    func createStoredProcedure() {
//        if open() {
//            let sql = """
//            CREATE PROCEDURE InsertBillInfo
//            @BillId INT,
//            @BeverageId INT,
//            @Count INT
//            AS
//            BEGIN
//            DECLARE @IsExitsBillInfor INT;
//            DECLARE @BeverageCount INT = 1;
//
//            SELECT @IsExitsBillInfor = \(BILL_INFO_TABLE_NAME).\(BILL_INFO_BILL_ID), @BeverageCount = \(BILL_INFO_TABLE_NAME).\(BILL_INFO_COUNT)
//            FROM \(BILL_INFO_TABLE_NAME)
//            WHERE \(BILL_INFO_BILL_ID) = @BillId AND \(BILL_INFO_MEAL_ID) = @BeverageId;
//
//            IF (@IsExitsBillInfor > 0)
//            BEGIN
//            DECLARE @NewCount INT = @BeverageCount + @Count;
//            IF (@NewCount > 0)
//            BEGIN
//            UPDATE \(BILL_INFO_TABLE_NAME) SET \(BILL_INFO_COUNT) = @BeverageCount + @Count WHERE \(BILL_INFO_BILL_ID) = @BillId AND \(BILL_INFO_MEAL_ID) = @BeverageId;
//            END
//            END
//            ELSE
//            BEGIN
//            INSERT INTO \(BILL_INFO_TABLE_NAME) (\(BILL_INFO_BILL_ID), \(BILL_INFO_MEAL_ID), \(BILL_INFO_COUNT)) VALUES (@BillId, @BeverageId, @Count);
//            END
//            END
//            """
//
//            if let success = database?.executeStatements(sql), success {
//                print("Stored procedure created successfully.")
//            } else {
//                print("Failed to create stored procedure.")
//            }
//
//            close()
//        }
//    }
//
//    func executeInsertBillInfo(billId: Int, beverageId: Int, count: Int) {
//        // Kết nối và thực thi Stored Procedure
//        // Ví dụ: sử dụng thư viện FMDB
//        if open() {
//            let sql = "EXEC InsertBillInfo @BillId = ?, @BeverageId = ?, @Count = ?"
//
//            // Truyền tham số vào Stored Procedure
//            // Ví dụ: sử dụng thư viện FMDB
//            let success = database?.executeUpdate(sql, withArgumentsIn: [billId, beverageId, count])
//
//            if success == true {
//                // Thực thi Stored Procedure thành công
//                print("Them thanh cong")
//            } else {
//                // Thực thi Stored Procedure thất bại
//                print("Them that bai")
//            }
//
//            close()
//        }
//    }



//    func insertBillInfo(billId: Int, beverageId: Int, count: Int) {
//        if open() {
//            let sql = """
//            DECLARE @IsExitsBillInfor INT;
//            DECLARE @BeverageCount INT = 1;
//
//            SELECT @IsExitsBillInfor = \(BILL_INFO_TABLE_NAME).\(BILL_INFO_BILL_ID), @BeverageCount = \(BILL_INFO_TABLE_NAME).\(BILL_INFO_COUNT)
//            FROM \(BILL_INFO_TABLE_NAME)
//            WHERE \(BILL_INFO_BILL_ID) = ? AND \(BILL_INFO_MEAL_ID) = ?;
//
//            IF (@IsExitsBillInfor > 0)
//            BEGIN
//            DECLARE @NewCount INT = @BeverageCount + ?;
//            IF (@NewCount > 0)
//            UPDATE \(BILL_INFO_TABLE_NAME) SET \(BILL_INFO_COUNT) = @BeverageCount + ? WHERE \(BILL_INFO_BILL_ID) = ? AND \(BILL_INFO_MEAL_ID)  = ?;
//
//            END
//            ELSE
//            INSERT INTO \(BILL_INFO_TABLE_NAME) (\(BILL_INFO_BILL_ID), \(BILL_INFO_MEAL_ID) , \(BILL_INFO_COUNT)) VALUES (?, ?, ?);
//            """
//
//            let params: [Any] = [billId, beverageId, count, count, billId, beverageId, billId, beverageId, billId, beverageId, count]
//            let success = database?.executeStatements(sql, withArgumentsIn: params)
//
//            if success {
//                os_log("Insert BillInfo successfully.")
//            } else {
//                os_log("Error inserting BillInfo.")
//            }
//
//            let _ = close()
//        }
//    }
    public func insertBillInfo(billInfo: BillInfo) -> Bool {
        var ok = false

        if open() {

            let sql = "INSERT INTO \(BILL_INFO_TABLE_NAME) (\(BILL_INFO_MEAL_ID), \(BILL_INFO_COUNT), \(BILL_INFO_BILL_ID)) VALUES (?, ?, ?)"


            if database?.executeUpdate(sql, withArgumentsIn: [billInfo.getMealId(), billInfo.getCount(), billInfo.getBillId()]) == true {
                ok = true
                os_log("Them bill info vao csdl thanh cong")
            } else {
                os_log("Them bill info vao csdl that bai")
            }

            let _ = close()
        }

        return ok
    }
    
    //

    
    //Lay bill chua thanh toan dua tren table id
    public func getBillUncheck(tableId: Int) -> Int? {
        var billTableId: Int?
        
        if open() {
            // Build the SQL statement
            let sql = "SELECT \(BILL_TABLE_ID) FROM \(BILL_TABLE_NAME) WHERE \(BILL_TABLE_ID) = ? AND \(BILL_STATUS) = 0"
            
            // Execute the SQL statement to retrieve the bill from the database
            if let resultSet = database?.executeQuery(sql, withArgumentsIn: [tableId]) {
                if resultSet.next() {
                    // Extract the bill information from the result set
                    billTableId = Int(resultSet.int(forColumn: BILL_TABLE_ID))
                    // Create a new Bill object with the retrieved information
//                    bill = Bill(id: Int(billId), tableId: Int(billTableId), dateCheckout: dateCheckout ?? "02/06", totalPrice: Int(totalPrice), status: status!)
                }
                resultSet.close()
            } else {
                os_log("Failed to retrieve bill from the database")
            }
            
            let _ = close()
        }
        if billTableId == nil{
            return -1
        }
        return billTableId
    }

    func getMaxBillId() -> Int? {
        var maxBillId: Int?
        
        if open() {
            let sql = "SELECT MAX(\(BILL_ID)) AS maxBillId FROM \(BILL_TABLE_NAME)"
            
            if let resultSet = database?.executeQuery(sql, withArgumentsIn: []) {
                if resultSet.next() {
                    maxBillId = Int(resultSet.int(forColumn: "maxBillId"))
                }
                
                resultSet.close()
            } else {
                os_log("Lỗi truy vấn")
            }
            
            let _ = close()
        }
        
        return maxBillId
    }

    
    //Lay san pham tren ban chua thanh toan
    func getMealsFromTableId(forTableId tableId: Int, billDetailList: inout [BillDetail]){
        
        if open() {
            let sql = "SELECT be.name, bi.count, be.price, be.price * bi.count as TotalPrice, be.image " +
                "FROM \(BILL_TABLE_NAME) AS b, \(BILL_INFO_TABLE_NAME) AS bi, \(MEAL_TABLE_NAME) AS be " +
                "WHERE b.\(BILL_ID) = bi.\(BILL_INFO_BILL_ID) " +
                "AND bi.\(BILL_INFO_MEAL_ID) = be.\(MEAL_ID) " +
                "AND b.\(BILL_STATUS) = 0 " +
            "AND b.\(BILL_TABLE_ID) = ?"
            
            do {
                let result = try database!.executeQuery(sql, values: [tableId])
                
                while result.next() {
                    let name = result.string(forColumn: MEAL_NAME) ?? ""
                    let count = result.int(forColumn: BILL_INFO_COUNT)
                    let price = result.double(forColumn: MEAL_PRICE)
                    var image:UIImage? = nil
                    let strImage = result.string(forColumn: MEAL_IMAGE) ?? ""
                    if !strImage.isEmpty {
                        //B1. Chuyen string thanh data
                        let dataImage = Data(base64Encoded: strImage, options: .ignoreUnknownCharacters)
                        //B2. Chuyen thanh UIImage
                        image = UIImage(data: dataImage!)
                    }
                    let billDetail = BillDetail(name: name, img: image, count: Int(count), price: price)
                    billDetailList.append(billDetail)
                }
            } catch {
                os_log("Không thể đọc thông tin hóa đơn từ cơ sở dữ liệu")
            }
            
            let _ = close()
        }
    }
    
    //Ghi du lieu table vao co so du lieu
    public func insertTable(table: Table) -> Bool {
        var ok = false
        
        if open() {
            // Xây dựng câu lệnh SQL
            let sql = "INSERT INTO \(TABLE_TABLE_NAME) (\(TABLE_NAME), \(TABLE_STATUS), \(TABLE_ORDERED_TIME)) VALUES (?, ?, ?)"
            
            // Thực thi câu lệnh SQL để ghi dữ liệu vào database
            if database!.executeUpdate(sql, withArgumentsIn: [table.getName(), table.getCurrentStatus(), table.getOrderedTime()]) {
                ok = true
                os_log("Ghi dữ liệu vào bảng Tables thành công")
            } else {
                os_log("Không thể ghi dữ liệu vào bảng Tables")
            }
            
            let _ = close()
        }
        
        return ok
    }
    //Update Table
    public func updateTable(table: Table) -> Bool {
        var ok = false
        
        if open() {
            // Xây dựng câu lệnh SQL
            let sql = "UPDATE \(TABLE_TABLE_NAME) SET \(TABLE_NAME) = ?, \(TABLE_STATUS) = ?, \(TABLE_ORDERED_TIME) = ? WHERE \(TABLE_ID) = ?"
            
            // Thực thi câu lệnh SQL để cập nhật dữ liệu trong bảng
            if database!.executeUpdate(sql, withArgumentsIn: [table.getName(), table.getCurrentStatus(), table.getOrderedTime(), table.getId()]) {
                ok = true
                os_log("Cập nhật dữ liệu trong bảng Tables thành công")
            } else {
                os_log("Không thể cập nhật dữ liệu trong bảng Tables")
            }
            
            let _ = close()
        }
        
        return ok
    }

    //Delete Table
    public func deleteTable(tableID: Int) -> Bool {
        var ok = false
        
        if open() {
            // Xây dựng câu lệnh SQL
            let sql = "DELETE FROM \(TABLE_TABLE_NAME) WHERE \(TABLE_ID) = ?"
            
            // Thực thi câu lệnh SQL để xóa dữ liệu từ bảng
            if database!.executeUpdate(sql, withArgumentsIn: [tableID]) {
                ok = true
                os_log("Xóa dữ liệu từ bảng Tables thành công")
            } else {
                os_log("Không thể xóa dữ liệu từ bảng Tables")
            }
            
            let _ = close()
        }
        
        return ok
    }

    
    //Doc toan bo bang table tu co so du lieu
    public func getAllTables(tables: inout [Table]) {
        if open() {
            var result: FMResultSet?
            
            // Xây dựng câu lệnh SQL
            let sql = "SELECT * FROM \(TABLE_TABLE_NAME) ORDER BY \(TABLE_ID) DESC"
            
            // Thực thi câu lệnh SQL và bắt exception
            do {
                result = try database!.executeQuery(sql, values: nil)
            } catch {
                os_log("Không thể đọc danh sách bàn từ cơ sở dữ liệu")
            }
            
            // Xử lý dữ liệu đọc về
            if let result = result {
                while result.next() {
                    let id = result.int(forColumn: TABLE_ID)
                    let status = result.string(forColumn: TABLE_STATUS) ?? ""
                    let orderedTime = result.string(forColumn: TABLE_ORDERED_TIME) ?? ""
                    let name = result.string(forColumn: TABLE_NAME) ?? ""
                    
                    let table = Table(id: Int(id), name: name, status: status, orderedTime: orderedTime)
                    tables.append(table)
                }
            }
            let _ = close()
        }
    }
    
    public func checkout(tableId: Int) -> Bool {
        var success = false
        
        if open() {
            // Xây dựng câu lệnh SQL
            let sql = "UPDATE \(BILL_TABLE_NAME) SET \(BILL_STATUS) = 1 WHERE \(BILL_TABLE_ID) = ?"
            
            // Thực thi câu lệnh SQL để cập nhật trạng thái trong bảng bill
            if database?.executeUpdate(sql, withArgumentsIn: [tableId]) ?? false {
                success = true
                os_log("Cập nhật trạng thái thành công trong bảng bill")
            } else {
                os_log("Không thể cập nhật trạng thái trong bảng bill")
            }
            
            close()
        }
        
        return success
    }
}
