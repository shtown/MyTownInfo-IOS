//
//  MasterViewController.swift
//  YouthServices
//
//  Created by Southampton Dev on 9/15/16.
//  Copyright © 2016 TOS. All rights reserved.
//

import UIKit
import CoreLocation

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class MasterViewController: UITableViewController {

    var facilityStore: FacilityStore!
    var facilities = [Facility]();
    var filteredFacilities = [Facility]()
    var tapGestureRecognizer: UITapGestureRecognizer!
    var isFiltered:Bool = true
    

    let locationManager = CLLocationManager()
    var currLocation: CLLocation?
    
    var selectedService: String = "All Services"
    var selectedTown: String = "All Towns"
    
    let searchController = UISearchController(searchResultsController:nil)

    
    var detailViewController: DetailViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
 
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
        
        getFacilities()

    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ShowService"  {
            
            
            if let row = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row  {
                let facilityDetail: Facility
                
                if(selectedTown != "All Towns" || selectedService != "All Services")  {
                    facilityDetail = filteredFacilities[row]
                } else {
                    facilityDetail = facilities[row]
                }
                
                let detailViewController = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                detailViewController.facility = facilityDetail
                detailViewController.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                detailViewController.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {


        if(selectedTown != "All Towns" || selectedService != "All Services")  {
             return filteredFacilities.count
        }
        return facilities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as! ServiceCell
        
        let facility: Facility
        
        cell.updateLabels()
        
        if(selectedTown != "All Towns" || selectedService != "All Services")  {
            facility = filteredFacilities[(indexPath as NSIndexPath).row]
            isFiltered = true
        }
        else  {
            facility = facilities[(indexPath as NSIndexPath).row]
            isFiltered = false
        }
        
        cell.titleView?.text = facility.Title
        cell.descView?.text = facility.Desc

        let browserLaunchImage = cell.launchBrowserIcon
        tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(MasterViewController.browserLaunchImageTapped(_:)))
        browserLaunchImage?.isUserInteractionEnabled = true
        browserLaunchImage?.addGestureRecognizer(tapGestureRecognizer)
        
        let emailLaunchImage = cell.launchEmailIcon
        tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(MasterViewController.emailLaunchImageTapped(_:)))
        emailLaunchImage?.isUserInteractionEnabled = true
        emailLaunchImage?.addGestureRecognizer(tapGestureRecognizer)
        
        
        let phoneLaunchImage = cell.launchTelIcon
        tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(MasterViewController.phoneLaunchImageTapped(_:)))
        phoneLaunchImage?.isUserInteractionEnabled = true
        phoneLaunchImage?.addGestureRecognizer(tapGestureRecognizer)
        
        let directionsLaunchImage = cell.launchDirectionsIcon
        tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(MasterViewController.directionsLaunchImageTapped(_:)))
        directionsLaunchImage?.isUserInteractionEnabled = true
        directionsLaunchImage?.addGestureRecognizer(tapGestureRecognizer)
        

        return cell
    }
    
    func getFacilities()  {

        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        facilityStore.fetchFacilities()  {
            (facilitiesResult) -> Void in
            
            switch facilitiesResult {
            case let .success(facilities):
                OperationQueue.main.addOperation {
                    self.facilities = self.getSortedByDistance(facilities)
                }
            case let .failure(error):
                print ("Error fetching facilities: \(error)")
                let alertController = UIAlertController(title: "Error fetching facilities: Please check your wireless settings", message: "Click OK to continue", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    //NSLog("OK Pressed")
                }
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
            self.do_table_refresh()
            
            //UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
 
    
    func do_table_refresh()
    {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
            return
        })
    }
    

 
 
    func getSortedByDistance(_ facilities: [Facility]) -> [Facility] {
        
       
        return facilities
       // return facilities.sorted { $0.DistFromCenter < $1.DistFromCenter }
    }
    
   
    @objc func directionsLaunchImageTapped(_ sender: UITapGestureRecognizer)  {
        /*
        var facility: Facility!

        let touch = sender.location(in: tableView)
        
        if let indexPath = tableView.indexPathForRow(at: touch) {
            if(isFiltered)  {
                facility = filteredFacilities[(indexPath as NSIndexPath).row]
            } else  {
                facility = facilities[(indexPath as NSIndexPath).row]
            }

 
            if facility.Lat! != "" && facility.Lon! != ""{

                let urlString = "http://maps.google.com/?daddr=\(facility.Lat!),\(facility.Lon!)&directionsmode=driving"
                UIApplication.shared.open(URL(string: urlString)!)
                
            } else {
                
                let alertController = UIAlertController(title: "Coordinates Not Supplied", message: "Click OK to continue", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    //NSLog("OK Pressed")
                }
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
        */
    }
    
  
    @objc func phoneLaunchImageTapped(_ sender: UITapGestureRecognizer)  {
    
        var phone: String!
     
        phone = "631-702-1994"
        let url:URL = URL(string: "tel://" + phone)!
        UIApplication.shared.open(url)
 
    }
    
    
    @objc func emailLaunchImageTapped(_ sender: UITapGestureRecognizer)  {

        var email: String!
 
        email = "gissupport@southamptontownny.gov"
                
        let url = URL(string: "mailto:\(email!)")
        UIApplication.shared.open(url!)
    }

    
    @objc func browserLaunchImageTapped(_ sender: UITapGestureRecognizer)  {
   
        var website: String!
        var facility: Facility!
        
        let touch = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touch) {
            if (isFiltered)  {
                facility = filteredFacilities[(indexPath as NSIndexPath).row]
            } else {
                facility = facilities[(indexPath as NSIndexPath).row]
            }
            
            if facility.URL! != ""  {
                website = facility.URL!
            } else {
                website = "https://www.southamptontownny.gov"
            }
        }
        
        if let url = URL(string: website) {
            UIApplication.shared.open(url)
        }
  
    }
    

    func filteredContentForSearchText(_ searchText: String, scope: String = "All")  {
        /*
        filteredFacilities = facilities.filter { facility in
            let typeMatch = (scope == "All") || (facility.Hamlet! == scope)
//            print (facility.Address!.lowercased() + "=> " + searchText.lowercased())
            return typeMatch && facility.Address!.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
         */
    }

}

extension MasterViewController: UISearchResultsUpdating  {

    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filteredContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

extension MasterViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int)  {
        
        filteredContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}


