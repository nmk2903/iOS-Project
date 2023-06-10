//
//  CategoryViewController.swift
//  FCoffee2023
//
//  Created by Koii on 5/31/23.
//  Copyright © 2023 Nguyen Le Tam. All rights reserved.
//

import UIKit

class CategoryViewController: UITableViewController {

    private var categoryList = [Category]()
    private var dao:DatabaseLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems![1] = editButtonItem
        dao = DatabaseLayer()
        dao.getAllCategories(categories: &categoryList)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = "categoryViewCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? CategoryViewCell {
            let category = categoryList[indexPath.row]
            cell.lblCategoryName.text = category.getName()
            return cell
        }

        fatalError("Khong the tao doi tuong cell")
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    @IBAction func unWindFromCategoryDetailController(segue: UIStoryboardSegue){
        //Lay man hinh source
        if let source = segue.source as? CategoryDetailController{
            if let category = source.category{
                switch source.navigationType{
                case .newCategory:
                    let _ = dao.insertCategory(category: category)
                    let categoryIndexPath = IndexPath(row: categoryList.count, section:0)
                    categoryList += [category]
                    tableView.insertRows(at: [categoryIndexPath], with: .none)
                case .editCategory:
                    if let selectedIndexPath = tableView.indexPathForSelectedRow{
                        dao.updateCategory(category: category)
                        categoryList[selectedIndexPath.row] = category
                        tableView.reloadRows(at: [selectedIndexPath], with: .none)
                    }
                }
            }
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            dao.deleteCategory(categoryId: categoryList[indexPath.row].getId())
            categoryList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? CategoryDetailController{
            if let segueName = segue.identifier{
                if segueName == "newCategory"{
                    destination.navigationType = .newCategory
                }else {
                    destination.navigationType = .editCategory
                    if let selectedIndexPath = tableView.indexPathForSelectedRow{
                        destination.category = categoryList[selectedIndexPath.row]
                    }
                }
            }
        }
    }
    

}
