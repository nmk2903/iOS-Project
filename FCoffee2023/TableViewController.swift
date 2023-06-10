//
//  TableViewController.swift
//  FCoffee2023
//
//  Created by Koii on 5/30/23.
//  Copyright © 2023 Nguyen Le Tam. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UITextFieldDelegate {
    
    private var tableList = [Table]()
    private var dao:DatabaseLayer!
    
    override func viewDidLoad() {
        //Them btnEdit
        navigationItem.leftBarButtonItem = editButtonItem
        
        super.viewDidLoad()
        dao = DatabaseLayer()
        //        let testTable = Table(id: 1, name: "Ban 2", status: "booked", orderedTime: "15:16")
        //        dao.insertTable(table: testTable)
        dao.getAllTables(tables: &tableList)
        tableView.reloadData()
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
        
        let reuseCell = "TableViewCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? TableViewCell {
            
            //Lay du lieu de do vao table view
            let table = tableList[indexPath.row]
            print(table.getCurrentStatus())
            switch table.getCurrentStatus()     {
            case "booked":
                if(!table.checkAvailableTime()){
                    let red: CGFloat = 0/255
                    let green: CGFloat = 255/255
                    let blue: CGFloat = 127/255
                    let alpha: CGFloat = 1.0
                    cell.tableStatusColor.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
                    cell.tableStatusColor.text = table.getName()
                } else {
                    let red: CGFloat = 255/255
                    let green: CGFloat = 234/255
                    let blue: CGFloat = 0/255
                    let alpha: CGFloat = 1.0
                    cell.tableStatusColor.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
                    cell.tableStatusColor.text! = table.getName()
                    cell.tableStatus.text = table.getOrderedTime()
                }
            case "already" :
                let red: CGFloat = 255/255
                let green: CGFloat = 0/255
                let blue: CGFloat = 0/255
                let alpha: CGFloat = 1.0
                cell.tableStatusColor.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
                cell.tableStatusColor.text = table.getName()
                cell.tableStatus.text = "Đã đặt món"
            default:
                let red: CGFloat = 0/255
                let green: CGFloat = 255/255
                let blue: CGFloat = 127/255
                let alpha: CGFloat = 1.0
                cell.tableStatusColor.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
                cell.tableStatusColor.text = table.getName()
                cell.tableStatus.text = "Bàn trống"
            }
            return cell
        }
        //Khong tao duoc cell => bao loi
        fatalError("Khong the tao doi tuong cell")
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
//    @IBAction func unWindFromTableDetailViewController(segue: UIStoryboardSegue){
//         if let source = segue.source as? TableDetailViewController{
//            dao.getAllTables(tables: &tableList)
//            tableList.removeAll()
//            tablewView.reloadData()
//        }
//    }
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TableDetailViewController{
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                destination.tableId = tableList[selectedIndexPath.row].getId()
            }
        }
    }
}
