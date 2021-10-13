//
//  ViewController.swift
//  ToDo
//
//  Created by Sanskar Atrey on 12/10/21.
//

import UIKit
import CoreData

class ViewController: UITableViewController,UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
     var itemArray=[Item]()
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let defaults=UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        searchBar.delegate=self
       
        // Do any additional setup after loading the view.
    }

//MARK-TableView DataSource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
    
        cell.textLabel?.text=itemArray[indexPath.row].title
        if itemArray[indexPath.row].done == true{
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
  
        let currState=itemArray[indexPath.row].done
        itemArray[indexPath.row].done = !currState
        saveItems()
       
        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
     
        tableView.reloadData()
    }
    
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
    
        
        var textField=UITextField()
        let alert=UIAlertController(title: "Add", message:"", preferredStyle: .alert)
        
        let action=UIAlertAction(title:"Add Item",style: .default)
        { (action) in
            
            print("Success!")
            
            
        
            let newItem=Item(context: self.context)
            newItem.title=textField.text!
            newItem.done=false
            self.saveItems()
            self.loadItems()
            self.tableView.reloadData()
        }
        
        alert.addTextField{
            (alertTextField) in
            
            textField=alertTextField
            alertTextField.placeholder="Create New Item"
             
        }
        
        alert.addAction(action)
        present(alert,animated:true,completion:nil)
    }
    
    func saveItems(){
        do{
            try context.save()
        } catch{
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    

    
    func loadItems(){
        let request:NSFetchRequest<Item>=Item.fetchRequest()
        
        do{
            itemArray=try context.fetch(request)
        }
        catch{
            print(error)
        }
        
    }
   
    
    
}


extension ViewController{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request:NSFetchRequest<Item>=Item.fetchRequest()
        
        let predicate=NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        
        request.predicate=predicate
        let sortDescriptor=NSSortDescriptor(key:"title",ascending: true)
        
        do{
            itemArray=try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count==0{
            
          
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                self.loadItems()
                self.tableView.reloadData()
            }
           
        }
            
            
    }
}
