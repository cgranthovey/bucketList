//
//  LocationSearchTableVC.swift
//  bucketList
//
//  Created by Christopher Hovey on 7/13/18.
//  Copyright © 2018 Chris Hovey. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTableVC: UITableViewController {

    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView? = nil
    var delegate: SearchResultDelegate?
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var request = MKLocalSearchRequest()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.delegate = self
        //searchCompleter.queryFragment = searchField.text!
        
//        searchCompleter.queryFragment = searchcon
        
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
        //return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SearchTblCell {
            
//            let cell: UITableViewCell = {
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else {
//                    // Never fails:
//                    return UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "UITableViewCell")
//                }
//                return cell
//            }()
//
            
            
//            let results = searchResults[indexPath.row].title + ", " + searchResults[indexPath.row].subtitle
//            cell.textLabel?.text = results
            
            cell.configure(location: searchResults[indexPath.row])
            
            
            
//            let selectedItem = matchingItems[indexPath.row].placemark
//            cell.textLabel?.text = selectedItem.name
//            cell.detailTextLabel?.text = selectedItem.getAddress()
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        let eventAddress = selectedItem.getAddress()
        if let delegate = delegate{
            delegate.zoomInAt(placemark: selectedItem, address: eventAddress)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension LocationSearchTableVC: MKLocalSearchCompleterDelegate{
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchResults = completer.results
        self.tableView.reloadData()
        print("show me the search results ", searchResults)
    }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("MKLocalSearchCompleter did fail -", error)
    }
}

extension LocationSearchTableVC: UISearchResultsUpdating{
    
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let mapView = mapView,
//            let searchBarText = searchController.searchBar.text else { return }
//        let request = MKLocalSearchRequest()
//        request.naturalLanguageQuery = searchBarText
//        request.region = mapView.region
//        let search = MKLocalSearch(request: request)
//        search.start { response, _ in
//            guard let response = response else {
//                return
//            }
//            self.matchingItems = response.mapItems
//            self.tableView.reloadData()
//        }
//    }
//
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else {return}
        searchCompleter.queryFragment = searchBarText
        
        
        
        return
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        search.start { (response, error) in
            guard error == nil else{
                print("search error - ", error!)
                return
            }
            guard let response = response else{
                return
            }
            // print("updateSearchResults", response)
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
    
    
    
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else {return}
//        z
//        let request = MKLocalSearchRequest()
//        request.naturalLanguageQuery = searchBarText
//        request.region = mapView.region
//        let search = MKLocalSearch(request: request)
//
//        search.start { (response, error) in
//            guard error == nil else{
//                print("search error - ", error!)
//                return
//            }
//            guard let response = response else{
//                return
//            }
//           // print("updateSearchResults", response)
//            self.matchingItems = response.mapItems
//            self.tableView.reloadData()
//        }
//    }
}



























