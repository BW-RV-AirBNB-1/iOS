//
//  ListingsTableViewController.swift
//  5thWheelRV
//
//  Created by Jorge Alvarez on 3/1/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit
import CoreData

// EditListingSegue
// AddListingSegue
class ListingsTableViewController: UITableViewController {
    

    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Listing> = {
        let fetchRequest: NSFetchRequest<Listing> = Listing.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try? frc.performFetch()
        return frc
    }()
    
    var listingController = ListingController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let listing = fetchedResultsController.object(at: indexPath)
        // Configure the cell...
        //cell.imageView?.image = UIImage(listing.photo_url)
        cell.textLabel?.text = listing.title
        //cell.detailTextLabel?.text = "\(listing.price_per_day)"
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    //    @IBAction func refresh(_ sender: Any) {
    //        listingController.put { (error) in
    //            if let error = error {
    //                //Handle error
    //                print("Error refreshing: \(error)")
    //                self.refreshControl?.endRefreshing()
    //            } else {
    //                self.tableView.reloadData()
    //                self.refreshControl?.endRefreshing()
    //            }
    //        }
    //    }
}

extension ListingsTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        
        listingController.getAllListings()
        
//        listingController.allUserSearchForListingWithID(with: Int16(1)) { (result) in
//            do {
//                let listings = try result.get()
//                print(listings)
//            } catch {
//                print(error)
//            }
//        }
        
        //        searchResultsController.performSearch(searchTerm: searchTerm, resultType: resultType) { (error) in
        
        //        if let error = error {
        //            print("Error \(error)")
        //            return
        //        }
        
//        DispatchQueue.main.sync {
//            self.tableView.reloadData()
//        }
    }
}

extension ListingsTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}
