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
    case delete = "DELETE"
    case put = "PUT"
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
// MARK: - ListingController

class ListingController {
    
    init() {
        fetchListingsFromServer()
    }
    
    var listings: [ListingRepresentation]? = []
    static let shared = ListingController()
    
    let baseURL = URL(string: "https://build-wk-4-backend-coreygumbs.herokuapp.com/api/listings/")
    
    typealias CompletionHandler = (Error?) -> Void
    
    let MC = CoreDataStack.shared.mainContext
    
    
    // MARK: - CRUD
    
    func createListing(land_owner: Bool, desc: String, lattitude: String, longitude: String, owner: String, photo_url: String, state: String, state_abbrv: String, title: String, price_per_day: Float, id: Int16) {
        let listing = Listing(land_owner: land_owner, desc: desc, latitude: lattitude, longitude: longitude, owner: owner, photo_url: photo_url, state: state, state_abbrv: state_abbrv, title: title, price_per_day: price_per_day, id: id)
        put(listing: listing)
    }
    
    func updateListing(listing: Listing, representation: ListingRepresentation) {
        listing.land_owner = representation.land_owner
        listing.desc = representation.desc
        listing.latitude = representation.latitude
        listing.longitude = representation.longitude
        listing.photo_url = representation.photo_url
        listing.state = representation.state
        listing.state_abbrv = representation.state_abbrv
        listing.title = representation.title
        listing.price_per_day = representation.price_per_day
        listing.id = representation.id
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
    
    // GET All Listings (RV ONLY)
    func getAllListing(completion: @escaping CompletionHandler = { _ in }) {
        
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
                NSLog("Error decoding entry representations from DataBase: \(error)")
                completion(error)
            }
        }.resume()
    }
    
    
  
    // GET Listing by ID
    func allUserSearchForListingWithID(with id: String, completion: @escaping (Result<ListingRepresentation, NetworkError>) -> Void) {
            
        let url = baseURL!.appendingPathComponent(id)
            var requestURL = baseURL!.appendingPathComponent("\(id)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    NSLog("404 File Not Found")
                    completion(.failure(.badURL))
                }
            }
                
                if let error = error {
                    print("Error getting data : \(String(describing: error))")
                    completion(.failure(.serverError))
                    return
                }
            
            guard let data = data else {
                NSLog("403 Forbidden")
                completion(.failure(.forbidden))
                return
            }
            
            do {
                let listingRepresentation = try JSONDecoder().decode(ListingRepresentation.self, from: data)
                self.listings = nil
                var rep: [ListingRepresentation] = [listingRepresentation]
                try self.updateListings(with: rep)
                
                completion(.success(listingRepresentation))
            }     catch {
                NSLog("Error decoding JSON data: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
        
        
    }
    
    
    
    
    // MARK: - RV OWNER API METHODS
    
    
    
    // MARK: -
    
    func put(listing: Listing, completion: @escaping CompletionHandler = {_ in }) {
        let requestURL = baseURL!.appendingPathComponent(String(listing.id)).appendingPathExtension("json")
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
                NSLog("Error PUTing l to database. : \(error)")
                completion(error)
                return
            }
            completion(nil)

        }.resume()
        
    }
    
    
    func deleteEntryFromServer(listing: Listing, completion: @escaping CompletionHandler = {_ in }) {
        
        
        
        let requestURL = baseURL!.appendingPathComponent("\(listing.id)")
        
        
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
                        let representation = representationsByID[listing.id]
                       
                        try self.updateListing(listing: listing, representation: representation!)
                        listingsToCreate.removeValue(forKey: listing.id)
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
    
    
    // MARK: - This is also GET All Listings (RV)
    
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
    
    
    // MARK: - RV OWNER ONLY METHOD
    
    
    
}


