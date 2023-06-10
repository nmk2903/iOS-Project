//
//  TableListDetailViewController.swift
//  FCoffee2023
//
//  Created by Koii on 6/1/23.
//  Copyright © 2023 Nguyen Le Tam. All rights reserved.
//

import UIKit

class TableListDetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
   
    @IBOutlet weak var edtTableName: UITextField!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    enum NavigationType{
        case newTable
        case editTable
    }
    var navigationType: NavigationType = .newTable
    var table:Table?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let table = table{
            edtTableName.text = table.getName()
            navigationItem.title = table.getName()
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        switch navigationType {
        case .newTable:
            dismiss(animated: true, completion: nil)
        case .editTable:
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
                let id = table?.getId() ?? 1
                let name = edtTableName.text ?? ""
                table = Table(id: id, name: name, status: "empty", orderedTime: "")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        edtTableName.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        navigationItem.title =  edtTableName.text
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        btnSave.isEnabled = false
    }
}
