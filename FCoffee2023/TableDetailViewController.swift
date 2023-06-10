//
//  TableDetailViewController.swift
//  FCoffee2023
//
//  Created by Koii on 5/31/23.
//  Copyright © 2023 Nguyen Le Tam. All rights reserved.
//

import UIKit

class TableDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var tableId:Int?
    private var dao:DatabaseLayer!
    private var billDetailList = [BillDetail]()
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        dao = DatabaseLayer()
        dao.getMealsFromTableId(forTableId: tableId!, billDetailList: &billDetailList)
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return billDetailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = "tableDetailCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? TableDetailViewCell{
            let mealInBillDetail = billDetailList[indexPath.row]
            cell.mealName.text = mealInBillDetail.getName()
            cell.mealImg.image = mealInBillDetail.getImg()
            cell.mealPrice.text = String(mealInBillDetail.getTotalPrice())
            return cell
        }        
        
        fatalError("Khong the tao doi tuong cell")
    }
    
    @IBAction func unWindFromAddMealToTableViewController(segue: UIStoryboardSegue){
        if let source = segue.source as? AddMealToTableViewController{
            if let billDetail = source.billDetail{
                let billDetailIndexPath = IndexPath(row: billDetailList.count, section:0)
                if let meal = source.meal{
                    let uncheckBillId = dao.getBillUncheck(tableId: tableId!)
                    if uncheckBillId == -1{
                        dao.insertBill(tableId: tableId!)
                        let maxId = dao.getMaxBillId()
                        let billInfo:BillInfo = BillInfo(id: 1, mealId: meal.getId(), count: 1, billId: maxId!)
                        dao.insertBillInfo(billInfo: billInfo)
                        billDetailList += [billDetail]
                        tableView.insertRows(at: [billDetailIndexPath], with: .none)
                    }else{
                        let billInfo = BillInfo(id: 1, mealId: meal.getId(), count: billDetail.getCount(), billId: uncheckBillId!)
                        dao.insertBillInfo(billInfo: billInfo)
                        billDetailList += [billDetail]
                        tableView.insertRows(at: [billDetailIndexPath], with: .none)
                        //                        for element in billDetailList {
                        //                            element.setCount(count: element.getCount() + billDetail.getCount())
                        //                            if element.getName() == billDetail.getName() {
                        //                                let reuseCell = "tableDetailCell"
                        //                                if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: billDetailIndexPath) as? TableDetailViewCell{
                        //                                    cell.mealCount.text = String(element.getCount())
                        //                                }
                        //                            }
                        //                 {

                        
                    }
                    
                    
                }
            }
        }
    }
    
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //    @IBAction func btnThanhToan(_ sender: UIButton) {
    //        dao.(tableId: tableId)
    //        dismiss(animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
    //    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
