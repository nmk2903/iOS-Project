//
//  MealDetailViewController.swift
//  FCoffee2023
//
//  Created by Koii on 6/1/23.
//  Copyright © 2023 Nguyen Le Tam. All rights reserved.
//

import UIKit

class MealDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var dao: DatabaseLayer!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBOutlet weak var edtMealPrice: UITextField!
    @IBOutlet weak var edtMealName: UITextField!
    @IBOutlet weak var imgMeal: UIImageView!
    enum NavigationType{
        case newMeal
        case editMeal
    }
    var navigationType: NavigationType = .newMeal
    var meal:Meal?
    private var categoryId:Int = 0
    private var categoryList = [Category]()
    override func viewDidLoad() {
        super.viewDidLoad()
        dao = DatabaseLayer()
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        dao.getAllCategories(categories: &categoryList)
        //Lay du lieu Meal truyen sang tu man hinh meal table view
        if let meal = meal {
            //Do du lieu tu meal vao
            edtMealName.text = meal.getName()
            navigationItem.title = meal.getName()
            imgMeal.image = meal.getImg()
            edtMealPrice.text = String(meal.getPrice())
            categoryId = meal.getCategoryId()
            showCategoryInPickerView(categoryId: categoryId)
        }else {
            categoryId = categoryList[0].getId()
        }
        
        //uy quyen cho doi tuong
        edtMealName.delegate = self
        edtMealPrice.delegate = self
        edtMealPrice.keyboardType = .numberPad
    }
    func showCategoryInPickerView(categoryId: Int){
        if let index = categoryList.firstIndex(where: { $0.getId() == categoryId }) {
            // Lựa chọn hàng tương ứng trong UIPickerView
            categoryPicker.selectRow(index, inComponent: 0, animated: true)
            
            // Cập nhật dữ liệu trên UIPickerView
            pickerView(categoryPicker, didSelectRow: index, inComponent: 0)
        }
    }
    
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Xử lý sự kiện khi người dùng chọn một hàng trong UIPickerView
        // categoryList[row].getName()
        categoryId = categoryList[row].getId()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print("textFieldShouldReturn() called")
        //An ban phim
        edtMealPrice.resignFirstResponder()
        edtMealName.resignFirstResponder()
        return true
    }
    
    @IBAction func imageProcessing(_ sender: UITapGestureRecognizer) {
        //print("image processing")
        //An ban phim
        edtMealName.resignFirstResponder()
        edtMealPrice.resignFirstResponder()
        //Su dung doi tuong ImagePickerController de lay anh
        let imagePicker = UIImagePickerController()
        //Cau hinh cho ImagePicker
        imagePicker.sourceType = .photoLibrary
        
        //B3: Thuc hien uy quyen cho doi tuong image picker
        imagePicker.delegate = self
        
        //Hien thi man hinh ImagePicker
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //print("Image Picker Controller called")
        
        //Lay anh da chon va dua vao image view
        if let imageSelected = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imgMeal.image = imageSelected
        }
        
        //Quay ve man hinh truoc do
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        switch navigationType {
        case .newMeal:
            dismiss(animated:true, completion: nil)
        case .editMeal:
            if let navi = navigationController{
                navi.popViewController(animated: true)
            }
            // Lay doi tuong naviagtion controller de quan ly stack
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let btnSender = sender as?UIBarButtonItem{
            if btnSender === btnSave{
                //Tao mon an moi va truyen san man hinh TableViewController
                let id = meal?.getId() ?? 1
                let name = edtMealName.text ?? ""
                let price = edtMealPrice.text ?? "0"
                let imgMeal = self.imgMeal.image
                meal = Meal(id: id, name: name, img: imgMeal, categoryId: categoryId, price: Int(price)!)
            }
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
