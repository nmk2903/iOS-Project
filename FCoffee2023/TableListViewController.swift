//
//  TableListViewController.swift
//  FCoffee2023
//
//  Created by Koii on 6/1/23.
//  Copyright © 2023 Nguyen Le Tam. All rights reserved.
//

import UIKit

class TableListViewController: UITableViewController {
    private var tableList = [Table]()
    private var dao:DatabaseLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems![1] = editButtonItem
        dao = DatabaseLayer()
        dao.getAllTables(tables: &tableList)
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
        return tableList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = "addTableViewCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? AddTableViewCell {
            let table = tableList[indexPath.row]
            cell.lblTableName.text = table.getName()
            return cell
        }
        
        fatalError("Khong the tao doi tuong cell")
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    //    @IBAction func unWindFromTableListDetailViewController(segue: UIStoryboardSegue){
    //        //Lay man hinh source
    //        if let source = segue.source as? TableListDetailViewController{
    //            if let table = source.table{
    //                switch source.navigationType{
    //                case .newTable:
    //                    let _ = dao.insertTable(table: table)
    //                    let tableIndexPath = IndexPath(row: tableList.count, section:0)
    //                    tableList += [table]
    //                    tableView.insertRows(at: [tableIndexPath], with: .none)
    //                case .editTable:
    //                    if let selectedIndexPath = tableView.indexPathForSelectedRow{
    //                        dao.updateTable(table: table)
    //                        tableList[selectedIndexPath.row] = table
    //                        tableView.reloadRows(at: [selectedIndexPath], with: .none)
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    @IBAction func unWind2FromTableListDetailViewController(segue: UIStoryboardSegue){
        if let source = segue.source as? TableListDetailViewController{
            if let table = source.table{
                switch source.navigationType{
                case .newTable:
                    let _ = dao.insertTable(table: table)
                    let tableIndexPath = IndexPath(row: tableList.count, section:0)
                    tableList += [table]
                    tableView.insertRows(at: [tableIndexPath], with: .none)
                case .editTable:
                    if let selectedIndexPath = tableView.indexPathForSelectedRow{
                        dao.updateTable(table: table)
                        tableList[selectedIndexPath.row] = table
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
            dao.deleteTable(tableID: tableList[indexPath.row].getId())
            tableList.remove(at: indexPath.row)
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
        if let destination = segue.destination as? TableListDetailViewController{
            if let segueName = segue.identifier{
                if segueName == "newTable"{
                    destination.navigationType = .newTable
                }else {
                    destination.navigationType = .editTable
                    if let selectedIndexPath = tableView.indexPathForSelectedRow{
                        destination.table = tableList[selectedIndexPath.row]
                    }
                }
            }
        }
    }
}
