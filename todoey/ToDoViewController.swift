//
//  ViewController.swift
//  todoey
//
//  Created by Arpit Singh on 02/07/18.
//  Copyright © 2018 Arpit Singh. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class ToDoViewController: SwipeViewController {
   
    
    @IBOutlet weak var search: UISearchBar!
    var value : Results<item>?
    let realm = try! Realm()
    var itemscategory : categories?
    {
        didSet{
           loaddata()
        }
    }
    // MARK:- value to save user data
    
    override func viewDidLoad() {
        print(FileManager.default.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask))
        super.viewDidLoad()
        tableView.separatorStyle = .none
        // Do any additional setup after loading the view, typically from a nib.
       tableView.rowHeight = 80
       loaddata()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        title = itemscategory?.name
        if let colour = UIColor(hexString: (itemscategory?.colour)!){
            search.barTintColor = colour
            navbarControiler( BartinColour : colour ,textColour : ContrastColorOf(colour, returnFlat: true))
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
       navbarControiler()
    }
    //MARK:- navgation UI
    func navbarControiler(BartinColour : UIColor = UIColor(hexString: "1D9BF6")! , textColour : UIColor = FlatWhite() )  {
        guard let nav = navigationController?.navigationBar else{print(fatalError())}
        nav.barTintColor = BartinColour
        nav.tintColor = textColour
        nav.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor :  textColour]
    }
    //MARK: - table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return value?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = value?[indexPath.row]{
        cell.textLabel?.text = item.title
            print("hex value : =\(CGFloat(indexPath.row)/CGFloat((value?.count)!))")
            if let colour =  UIColor.init(hexString: (itemscategory?.colour)!)?.darken(byPercentage:
                (CGFloat(indexPath.row)/CGFloat((value?.count)!))
                
                )         {
            cell.backgroundColor = colour
            cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
        cell.accessoryType = item.done ? .checkmark : .none
        }
        else
        {
            cell.textLabel?.text =  "no items in list"
        }
     //   savedata()
        return cell
    }
   //--------------------------------------------------------------------------

    //MARK: - tabel selection method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       if let items =  value?[indexPath.row]
       {
        do{
            try realm.write {
       items.done = !items.done
            }
            
        }
        catch
        {
            print(error.localizedDescription)
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    //MARK:- add items to table
    @IBAction func addItems(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let Alet = UIAlertController(title: "Add items", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let Action = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) { (action) in
            if let currentCategory = self.itemscategory{
                 if textfield.text?.count != 0
                 {
                do{
                    try self.realm.write {
                        
                    
                    let items = item()
                       items.title = textfield.text!
                        items.date = Date()
                    currentCategory.items.append(items)
                    // MARK:- saveing user data
                
                   }
                }catch
                {
                    print(error.localizedDescription)
                    }
                    }
               self.tableView.reloadData()
            }
        }
        Alet.addTextField { (alertfield) in
            alertfield.placeholder = "enter item name"
           textfield = alertfield

        }
        Alet.addAction(Action)
    present(Alet, animated: true, completion: nil)
    }
//
//    func savedata()
//    {
//
//        do{
//            try contexts.save()
//        }catch
//        {
//            print(error)
//        }
//    }
    //Marks :- for delete data
    override func deleteAction(indexPath: IndexPath) {
        if let itemsAct = value?[indexPath.row]
        {
            do{
                try realm.write {
                    realm.delete(itemsAct)
                }
            }catch{
                print(error.localizedDescription)
            }
            
        }
    }
    func loaddata()
    {
        value = itemscategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

}
extension ToDoViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        value = value?.filter("title CONTAINS[cd] %@", searchBar.text! ).sorted(byKeyPath: "date", ascending: true)
       tableView.reloadData()
       }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loaddata()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }else
        {
            searchBarSearchButtonClicked(searchBar)

        }
}

}

