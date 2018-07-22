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

    var mapView: MKMapView? = nil
    var delegate: SearchResultDelegate?
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var request = MKLocalSearchRequest()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.delegate = self
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SearchTblCell {
            cell.configure(location: searchResults[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = searchResults[indexPath.row].title + ", " + searchResults[indexPath.row].subtitle
        let title = searchResults[indexPath.row].title
        let desc = searchResults[indexPath.row].subtitle
        let searchRequest = MKLocalSearchRequest(completion: searchResults[indexPath.row])
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            guard error == nil else{
                print("error in active search", error)
                return
            }
            
            if let response = response, let delegate = self.delegate{
                delegate.zoomInAt(region: response.boundingRegion, addressPrimary: title, addressSecondary: desc)
            }
        }

        dismiss(animated: true, completion: nil)
    }
}

extension LocationSearchTableVC: MKLocalSearchCompleterDelegate{
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchResults = completer.results
        self.tableView.reloadData()
    }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("MKLocalSearchCompleter did fail -", error)
    }
}

extension LocationSearchTableVC: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let _ = mapView, let searchBarText = searchController.searchBar.text else {return}
        searchCompleter.queryFragment = searchBarText
    }
}



























