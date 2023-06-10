//
//  MealViewController.swift
//  FCoffee2023
//
//  Created by Koii on 5/31/23.
//  Copyright © 2023 Nguyen Le Tam. All rights reserved.
//

import UIKit

class MealViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    private var categoryList = [Category]()
    private var mealList = [Meal]()
    private var dao:DatabaseLayer!
    @IBOutlet weak var categoryPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems![1] = editButtonItem
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
        let reuseCell = "mealViewCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? MealViewCell {
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

    @IBAction func unWindFromMealDetailViewController(segue:UIStoryboardSegue) {
        // Lay man hinh source
        if let source = segue.source as? MealDetailViewController{
            // Lay bien meal truyen ve tu MealDetailController
            if let meal = source.meal{
                //print("Mon an moi tao la \(meal.getName())")
                switch source.navigationType{
                case .newMeal :
                    //Ghi meal vao co so du lieu
                    let _ = dao.insertMeal(meal: meal)
                    reloadDataTableView()
                    //Tinh toan vi tri insert new meal
//                    let mealIndexPath = IndexPath(row: mealList.count , section: 0)
////                    mealList += [meal]
//                    tableView.insertRows(at: [mealIndexPath], with: .none)
                case .editMeal:
                    if let selectedIndexPath = tableView.indexPathForSelectedRow{
                        dao.updateMeal(meal: meal)
                        reloadDataTableView()
//                        tableView.reloadRows(at: [selectedIndexPath], with: .none)
                    }
                }
            }
        }
    }
    //Reload data theo UIPicker sau khi chuyen man hinh
    func reloadDataTableView(){
        mealList.removeAll()
        let categoryPickerSelectedRow = categoryPicker.selectedRow(inComponent: 0)
        dao.getMealsByCategoryId(categoryId: categoryList[categoryPickerSelectedRow].getId(), meals: &mealList)
        tableView.reloadData()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? MealDetailViewController {
            if let segueName = segue.identifier{
                if segueName == "newMeal"{
                    destination.navigationType = .newMeal
                }else{
                    destination.navigationType = .editMeal
                    //Truyen meal duoc chon tu man hinh 1 sang man hinh 2
                    if let selectedIndexPath = tableView.indexPathForSelectedRow{
                        destination.meal = mealList[selectedIndexPath.row]
                    }
                }
            }
        }
    }
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //Edit
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            dao.deleteMeal(mealId: mealList[indexPath.row].getId())
            mealList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}
