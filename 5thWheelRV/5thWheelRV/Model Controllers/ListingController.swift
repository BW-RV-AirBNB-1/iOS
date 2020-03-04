//
//  ListingController.swift
//  5thWheelRV
//
//  Created by Lambda_School_Loaner_268 on 3/3/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation
import UIKit
import CoreData


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    
    case noAccess
    case notFound
    case serverError 
    case badURL
    case otherError
    case forbidden
    case noDecode
    case noData
    }

class ListingController {
    
    init() {
        fetchListingsFromServer()
    }
    
    var listings: [ListingRepresentation] = []
    static let shared = ListingController()
    
    let baseURL = URL(string: "https://build-wk-4-backend-coreygumbs.herokuapp.com/api/listings/")
    
    typealias CompletionHandler = (Error?) -> Void
    
    let MC = CoreDataStack.shared.mainContext
    
    
    // MARK: - CRUD
    
    func createListing(title: String, id: UUID, description: String, lat: String, long: String, photo: String, state_id: String, price: Float) {
        let listing = Listing(id: id, state_id: state_id, price: price, description_String: description, lat: lat, long: long, photo: photo, title: title, landowner_id: true, created: Date(), updated: Date(), context: MC)
        put(listing: listing)
    }
    
    func updateListing(listing: Listing, representation: ListingRepresentation) {
        listing.id = representation.id
        listing.price = representation.price_per_day!
        listing.description_String = representation.description
        listing.lat = representation.lat
        listing.long = representation.long
        listing.photo = representation.photo_url
        listing.state_id = representation.state_id
        listing.title = representation.title
        listing.landowner_id = representation.landowner_ID!
        listing.created = representation.created
        listing.updated = Date()
    }
    
    func deleteListing(for listing: Listing) {
        deleteEntryFromServer(listing: listing) { (error) in
        guard error == nil else {
            print("Error deleting entry from server: \(String(describing: error))")
            return
        }
        self.MC.delete(listing)
        }
    }
    
    // MARK: - ALL USER API METHODS
    
    func allUserSearchForListing(with id: String, completion: @escaping (Error?) -> Void) {
            
            var requestURL = baseURL!.appendingPathComponent("\(id)")
        
            URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error searching for movie with id #\(id): \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(error)
                return
            }
            
            do {
                let listingRepresentations = try JSONDecoder().decode(ListingRepresentations.self, from: data).results
                self.listings = listingRepresentations
                completion(nil)
            }     catch {
                NSLog("Error decoding JSON data: \(error)")
                completion(error)
            }
        }.resume()
    }
    
    // MARK: - RV OWNER API METHODS
    
    
    
    // MARK: -
    
    func put(listing: Listing, completion: @escaping CompletionHandler = {_ in }) {
        
        let id = listing.id ?? UUID()
        listing.id = id
    
        let requestURL = baseURL!.appendingPathComponent(id.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
    
        
        do  {
        guard let listingRepresentation = listing.listingRepresentation else {
            NSLog("No entry, Entry == nil")
            completion(nil)
            return
        }
    
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(listingRepresentation)
    
        } catch {
            NSLog("Can't encode listing representation")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error PUTing movie to database. : \(error)")
                completion(error)
                return
            }
            completion(nil)

        }.resume()
    }
    
    
    func deleteEntryFromServer(listing: Listing, completion: @escaping CompletionHandler = {_ in }) {
        
        guard let id = listing.id else {
            completion(NSError())
            return
        }
        
        let requestURL = baseURL!.appendingPathComponent("\(id)")
        
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            guard error == nil  else {
                print("Error deleting entry: \(String(describing: error))")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
                
        }.resume()
            
    }
    
    func updateListings(with representations: [ListingRepresentation]) throws {
            let listingWithID = representations.filter { $0.id != nil}
            let identifiersToFetch = listingWithID.compactMap { $0.id }
            let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, listingWithID))
            var listingsToCreate = representationsByID

            let fetchRequest: NSFetchRequest = Listing.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)

            let context = CoreDataStack.shared.container.newBackgroundContext()

            context.perform {
                do {
                    let existingListings = try context.fetch(fetchRequest)

                    for listing in existingListings {
                        guard let id = listing.id,
                              let representation = representationsByID[id]
                        else { continue }
                        self.updateListing(listing: listing, representation: representation)
                        listingsToCreate.removeValue(forKey: id)
                    }
                    for representation in listingsToCreate.values {
                        let _ = Listing(listingRepresentation: representation, context: context)
                    }
                } catch {
                    NSLog("Error fetching listing for id: \(error)")
                }
            }
            do{
            try CoreDataStack.shared.save(context: context)
        } catch {
            print("error saving listing: \(error)")
        }
    }
    
    
  
    
    func fetchListingsFromServer(completion: @escaping CompletionHandler = { _ in }) {
    
        var request = URLRequest(url: baseURL!)
        request.httpMethod = "GET"
                
        URLSession.shared.dataTask(with: request) { (data, _, error) in
                    if let error = error {
                        NSLog("Error fetching tasks from API: \(error)")
                        completion(error)
                        return
                    
            }
        guard let data = data else {
            NSLog("No data returned from API")
            completion(NSError())
            return
        }
        
        
        let jsonDecoder = JSONDecoder()
        do {
            let decodedListings = Array(try jsonDecoder.decode([String : ListingRepresentation].self, from: data).values)
            try self.updateListings(with: decodedListings)
                completion(nil)
        } catch {
            NSLog("Error decoding entry representations from Firebase: \(error)")
            completion(error)
        }
    }.resume()
}
    
    
    
}


