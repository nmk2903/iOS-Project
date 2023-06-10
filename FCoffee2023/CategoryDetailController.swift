//
//  CategoryDetailController.swift
//  FCoffee2023
//
//  Created by Koii on 5/31/23.
//  Copyright © 2023 Nguyen Le Tam. All rights reserved.
//

import UIKit

class CategoryDetailController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var edtCategoryName: UITextField!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    var category:Category?
    enum NavigationType{
        case newCategory
        case editCategory
    }
    var navigationType: NavigationType = .newCategory
    override func viewDidLoad() {
        super.viewDidLoad()
        if let category = category{
            edtCategoryName.text = category.getName()
            navigationItem.title = category.getName()
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        switch navigationType {
        case .newCategory:
            dismiss(animated: true, completion: nil)
        case .editCategory:
        if let navi = navigationController{
            navi.popViewController(animated: true)
            }
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let btnSender = sender as? UIBarButtonItem{
            if btnSender === btnSave{
                let name = edtCategoryName.text ?? ""
                let id = category?.getId() ?? 1
                category = Category(id: id, name: name)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        edtCategoryName.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        navigationItem.title =  edtCategoryName.text
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        btnSave.isEnabled = false
    }
}
