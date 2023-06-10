//
//  AddMealToTableViewController.swift
//  FCoffee2023
//
//  Created by Koii on 6/1/23.
//  Copyright © 2023 Nguyen Le Tam. All rights reserved.
//

import UIKit

class AddMealToTableViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private var mealList = [Meal]()
    private var categoryList = [Category]()
    private var dao:DatabaseLayer!
    @IBOutlet weak var categoryPicker: UIPickerView!
    var table:Table?
    var billDetail:BillDetail?
    var meal:Meal?
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        tableView.dataSource = self // Gán dataSource cho UITableView
        tableView.delegate = self // Gán delegate cho UITableView
        dao = DatabaseLayer()
        dao.getAllCategories(categories: &categoryList)
        // Do any additional setup after loading the view.
        dao.getMealsByCategoryId(categoryId: categoryList[0].getId(), meals: &mealList)
        tableView.reloadData()
        
    }
    
    //UIPicker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Lấy tiêu đề cho hàng được hiển thị trong UIPickerView
        return categoryList[row].getName()
    }
    
    //tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mealList.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Xử lý sự kiện khi người dùng chọn một hàng trong UIPickerView
        // categoryList[row].getName()
        mealList.removeAll()
        dao.getMealsByCategoryId(categoryId: categoryList[row].getId(), meals: &mealList)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = "mealOfTableViewCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? MealOfTableViewCell {
            //Lay du lieu de do vao table view
            let meal = mealList[indexPath.row]
            cell.lblMealName.text = meal.getName()
            cell.lblMealPrice.text = String(meal.getPrice())
            cell.imgMeal.image = meal.getImg()
            
            return cell
        }
        //Khong tao duoc cell => bao loi
        fatalError("Khong the tao doi tuong cell")
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Xử lý sự kiện khi click vào cell tại indexPath
        let selectedCell = tableView.cellForRow(at: indexPath) as? MealOfTableViewCell
        meal = mealList[indexPath.row]
        // Thực hiện các thao tác mong muốn
        let name = selectedCell?.lblMealName.text ?? ""
        let priceString = selectedCell?.lblMealPrice.text ?? "0"
        let price = Double(priceString) ?? 0.0
        let img = selectedCell?.imgMeal.image
        billDetail = BillDetail(name: name, img: img, count: 1, price: price)
       
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let btnSender = sender as? UIBarButtonItem{
            if btnSender === btnSave{
                
            }
        }
    }
    

}
