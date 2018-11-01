//
//  CategoriesTableViewController.swift
//  todoey
//
//  Created by Arpit Singh on 08/07/18.
//  Copyright © 2018 Arpit Singh. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoriesTableViewController: SwipeViewController{
    var category : Results<categories>?
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.rowHeight = 80
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
     
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = category?[indexPath.row].name ?? "No categories yet Added"
        if let view = category?[indexPath.row]{
         cell.backgroundColor = UIColor(hexString: view.colour)
         cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        }
        // Configure the cell...
        tableView.separatorStyle = .none
        return cell
    }
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return category?.count ?? 1
    }
    //MARK:- adding categories
    @IBAction func addCategory(_ sender: Any) {
    var input = UITextField()
        let alert = UIAlertController(title: "Add category", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let  action  = UIAlertAction(title: "add", style: UIAlertActionStyle.default) { (action) in
            if input.text?.count != 0
            { let addcategory = categories()
                addcategory.name = input.text!
                 addcategory.colour = UIColor.randomFlat.hexValue()
                self.savedata(category: addcategory)
                self.tableView.reloadData()
            }
        }
        alert.addTextField { (text) in
            text.placeholder = "enter category"
            input = text
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //Marke:- table data source
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToDoList", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK:- saveing data
    func savedata(category : categories ) {
    do{
        try realm.write {
            realm.add(category)
        }
    }catch{
        print(error)
        }
        tableView.reloadData()
    }
    //MARK:- load data
    func loadData () {
        category  = realm.objects(categories.self)
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDoList"
        {
            let dataContoller = segue.destination as! ToDoViewController
            if let index = tableView.indexPathForSelectedRow
            {
                dataContoller.itemscategory = category?[index.row]
            }

        }
    }
    //Mark:- data delete
    override func deleteAction(indexPath: IndexPath) {
                    if let categorey = self.category?[indexPath.row]
                    {
                        do{
                            try self.realm.write {
                                self.realm.delete(categorey)
                            }
        
                        }catch{
                            print(error.localizedDescription)
                        }
                    }
                }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


