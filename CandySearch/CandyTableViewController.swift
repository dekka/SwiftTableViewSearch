//
//  CandyTableViewController.swift
//  CandySearch
//
//  Created by Reed Sweeney on 7/2/14.
//  Copyright (c) 2014 Reed Sweeney. All rights reserved.
//

import UIKit

class CandyTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var candies = Candy[]()
    var filteredCandies = Candy[]()

    @IBOutlet var candySearchBar : UISearchBar
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var newBounds = self.tableView.bounds
        newBounds.origin.y = newBounds.origin.y + candySearchBar.bounds.size.height
        self.tableView.bounds = newBounds

        candies = [Candy(category: "Chocoloate", name: "Chocolate Bar"), Candy(category: "Chocolate", name: "Chocolate Chip"), Candy(category: "Hard", name: "Lollipop")]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Table view data source

    @IBAction func goToSearch(sender : AnyObject) {
        
        candySearchBar.becomeFirstResponder()
    }
    

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.searchDisplayController.searchResultsTableView {
            return self.filteredCandies.count
        } else {
            return self.candies.count
        }
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        var candy : Candy
        
        if tableView == self.searchDisplayController.searchResultsTableView {
            candy = filteredCandies[indexPath.row]
        } else {
            candy = candies[indexPath.row]
        }
        
        
        cell.textLabel.text = candy.name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
        
    }
    
    func filterContentForSearchText(searchText: String, scope: String) {
        self.filteredCandies.removeAll(keepCapacity: false)
        var tempCandies = Candy[]()
        
        tempCandies = self.candies.filter({( bro : Candy) -> Bool in
       
            if bro.name.rangeOfString(searchText) {
                
                return true
                
            } else {
            return false
            }
        
            }) as Candy[]
        if scope != "All" {
            self.filteredCandies = tempCandies.filter({( bro: Candy) -> Bool in
                
                if bro.category == scope {
                    return true
                } else {
                
             return false
                }
                })
        }
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        self.performSegueWithIdentifier("candyDetail", sender: tableView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "candyDetail" {
            let candyDetailViewController = segue.destinationViewController as UIViewController
            if sender as UITableView == self.searchDisplayController.searchResultsTableView {
                let indexPath = self.searchDisplayController.searchResultsTableView.indexPathForSelectedRow()
                let destinationTitle = filteredCandies[indexPath.row].name
                candyDetailViewController.title = destinationTitle
            } else {
                let indexPath = self.tableView.indexPathForSelectedRow()
                let destinationTitle = candies[indexPath.row].name
                candyDetailViewController.title = destinationTitle
            }
        }
    }
    
    func searchDisplayController(controller: UISearchDisplayController!,
        shouldReloadTableForSearchString searchString: String!) -> Bool {
            
            if let scopes = self.searchDisplayController.searchBar.scopeButtonTitles {
            
            let selectedScope = scopes[self.searchDisplayController.searchBar.selectedScopeButtonIndex] as String
            
            self.filterContentForSearchText(searchString, scope: selectedScope)
            
                return true }
            else {
                println(searchString)
                 self.filterContentForSearchText(searchString, scope: "noScope")
                return true
            }
    }
    
    func searchDisplayController(controller: UISearchDisplayController!,
        shouldReloadTableForSearchScope searchOption: Int) -> Bool {
            
            let scope = self.searchDisplayController.searchBar.scopeButtonTitles as String[]
            
            self.filterContentForSearchText(self.searchDisplayController.searchBar.text, scope: scope[searchOption])
            
            
    
            return true
    }
    

}













