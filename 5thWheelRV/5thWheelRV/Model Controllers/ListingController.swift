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

// MARK: - Listing Controller Class
class ListingController {
    init() {
        getAllListings()
        getAllReservationsFromServer()
    }
    var reservations: [ReservationRepresentation]? = []
    var listings: [ListingRepresentation]? = []
    static let shared = ListingController()
    let baseURL = URL(string: "https://build-wk-4-backend-coreygumbs.herokuapp.com/api/listings/")
    typealias CompletionHandler = (Error?) -> Void
    let MC = CoreDataStack.shared.mainContext
    // MARK: - CRUD For Listings
    func createListing(listingRepresation: ListingRepresentation) {
        let listing = Listing(listingRepresentation: listingRepresation)
        put(listing: listing!)
    }
    func updateListing(listing: Listing, representation: ListingRepresentation) {
        listing.land_owner = representation.landOwner
        listing.desc = representation.desc
        listing.latitude = representation.latitude
        listing.longitude = representation.longitude
        listing.photo_url = representation.photoURL
        listing.state = representation.state
        listing.state_abbrv = representation.stateAbbrv
        listing.title = representation.title
        listing.price_per_day = representation.pricePerDay
        listing.id = representation.id
    }
    func deleteListing(for listing: Listing) {
        deleteListingFromServer(listing: listing) { (error) in
        guard error == nil else {
            print("Error deleting entry from server: \(String(describing: error))")
            return
        }
        self.MC.delete(listing)
        }
    }
    // MARK: - Listing GET Calls
    // GET All Listings (RV ONLY)
    func getAllListings(completion: @escaping CompletionHandler = { _ in }) {
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
                let decodedListings = Array(
                    try jsonDecoder.decode([String: ListingRepresentation].self,
                                                                   from: data).values)
                self.listings = nil
                self.listings = decodedListings
                completion(nil)
            } catch {
                NSLog("Error decoding entry representations from DataBase: \(error)")
                completion(error)
            }
        }.resume()
    }
    // GET Listing by listingID
    func allUserSearchForListingWithID(with listingID: Int16,
                                       completion: @escaping (Result<ListingRepresentation, NetworkError>) -> Void) {
        let url = baseURL!.appendingPathComponent("\(listingID)")
        var request = URLRequest(url: url)
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
                let rep = listingRepresentation
                self.listings = [rep]
                completion(.success(listingRepresentation))
            } catch {
                NSLog("Error decoding JSON data: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
    // GET All Land Owner Listings
    func getAllLandOwnerListingsByID(with id: Int16,
                                     completion: @escaping (Result<ListingRepresentation, NetworkError>) -> Void) {
        let url = baseURL!.appendingPathComponent("\(id)")
        var request = URLRequest(url: url)
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
                let rep: ListingRepresentation = listingRepresentation
                self.listings = [rep]
                completion(.success(listingRepresentation))
            } catch {
                NSLog("Error decoding JSON data: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
    // MARK: - Put, Delete Listing
    func put(listing: Listing, completion: @escaping CompletionHandler = {_ in }) {
        let requestURL = baseURL!.appendingPathComponent(String(listing.id)).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        do { guard let listingRepresentation = listing.listingRepresentation
            else { NSLog("No entry, Entry == nil")
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
    func deleteListingFromServer(listing: Listing, completion: @escaping CompletionHandler = {_ in }) {
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
    // MARK: - User Methods
    func registerAccount(user: User) -> ValidLogon {
        let defaultURL = URL(string: "https://build-wk-4-backend-coreygumbs.herokuapp.com/api/register")
        let userArray: [User] = [user]
        var request = URLRequest(url: defaultURL!)
        request.httpMethod = "POST"
        var logon = ValidLogon(user: userArray, token: UUID().uuidString)
        return logon
}
  //  func login(userRepresentation: UserRepresentation) {
    //https://build-wk-4-backend-coreygumbs.herokuapp.com/api/login}
    // MARK: - Reservation Methods
    // GET Reservation by reservationID
       func getReservationByReservationID(with reservationID: Int16,
                                          completion: @escaping (Result<ReservationRepresentation, NetworkError>) -> Void) {
           let reservationURL: URL = URL(string: "https://build-wk-4-backend-coreygumbs.herokuapp.com/api/reservations/")!
           let url = reservationURL.appendingPathComponent("\(reservationID)")
           var request = URLRequest(url: url)
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
                   let reservationRepresentation = try JSONDecoder().decode(ReservationRepresentation.self, from: data)
                   self.reservations = nil
                   let res: ReservationRepresentation = reservationRepresentation
                   self.reservations = [res]
                   completion(.success(reservationRepresentation))
               } catch {
                   NSLog("Error decoding JSON data: \(error)")
                   completion(.failure(.noDecode))
               }
           }.resume()
       }
    // GET Reservation By listingID
    func getReservationByListingID(with listingID: Int16,
                                   completion: @escaping (Result<ReservationRepresentation, NetworkError>) -> Void) {
            let reservationURL: URL = URL(string: "https://build-wk-4-backend-coreygumbs.herokuapp.com/api/reservations/")!
            let url = reservationURL.appendingPathComponent("\(listingID)")
            var request = URLRequest(url: url)
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
                    let reservationRepresentation = try JSONDecoder().decode(ReservationRepresentation.self, from: data)
                    self.reservations = nil
                    let res: ReservationRepresentation = reservationRepresentation
                    self.reservations = [res]
                    completion(.success(reservationRepresentation))
                } catch {
                    NSLog("Error decoding JSON data: \(error)")
                    completion(.failure(.noDecode))
                }
            }.resume()
        }
    // GET Reservation by userID
    func getReservationByUserID(with userID: Int16,
                                completion: @escaping (Result<ReservationRepresentation, NetworkError>) -> Void) {
        let reservationURL: URL = URL(string: "https://build-wk-4-backend-coreygumbs.herokuapp.com/api/reservations/owner/")!
        let url = reservationURL.appendingPathComponent("\(userID)")
        var request = URLRequest(url: url)
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
                let reservationRepresentation = try JSONDecoder().decode(ReservationRepresentation.self, from: data)
                self.reservations = nil
                let res: ReservationRepresentation = reservationRepresentation
                self.reservations = [res]
                completion(.success(reservationRepresentation))
            } catch {
                NSLog("Error decoding JSON data: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
    // GET all reservations
    func getAllReservationsFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let reservationURL: URL = URL(string: "https://build-wk-4-backend-coreygumbs.herokuapp.com/api/reservations")!
        var request = URLRequest(url: reservationURL)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, _, error) in
                    if let error = error {
                        NSLog("Error fetching tasks from API: \(error)")
                        completion(error)
                        return
            }
        guard let data = data else {
            NSLog("No reservations returned from API")
            completion(NSError())
            return
        }
        let jsonDecoder = JSONDecoder()
        do {
            let decodedReservations = Array(
                try jsonDecoder.decode([String: ReservationRepresentation].self,
                                                                from: data).values)
            self.reservations = decodedReservations
                completion(nil)
        } catch {
            NSLog("Error decoding entry representations from DataBase: \(error)")
            completion(error)
        }
    }.resume()
}
    // PUT UPDATE RESERVATION
    func updateReservation(reservation: Reservation, representation: ReservationRepresentation) {
           reservation.reserved = representation.reserved
           reservation.desc = representation.desc
           reservation.reservation_name = representation.reservationName
           reservation.reserved_from = representation.reservedFrom
           reservation.reserved_to = representation.reservedTo
           reservation.state = representation.state
           reservation.title = representation.title
           reservation.listing_id = representation.listingID
           reservation.reservation_id = representation.reservationID
           putReservation(reservation: reservation)
           getAllReservationsFromServer()
       }
    func createReservation(reservationRepresentation: ReservationRepresentation) {
        let reservation: Reservation = Reservation(reservationRepresentation: reservationRepresentation)!
        putReservation(reservation: reservation)
    }
    // DELETE Reservation
    func deleteReservationFromServer(reservation: Reservation, completion: @escaping CompletionHandler = {_ in }) {
        let reservationURL: URL = URL(string: "https://build-wk-4-backend-coreygumbs.herokuapp.com/api/reservations/")!
        let requestURL = reservationURL.appendingPathComponent("\(reservation.reservation_id)")
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
    // PUT Method
    func putReservation(reservation: Reservation, completion: @escaping CompletionHandler = {_ in }) {
        let putURL: URL = URL(string: "https://build-wk-4-backend-coreygumbs.herokuapp.com/api/reservations/")!
        let requestURL = putURL.appendingPathComponent(String(reservation.reservation_id)).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        do {
            guard let reservationRepresentation = reservation.reservationRepresentation
            else { NSLog("No entry, Entry == nil")
            completion(nil)
            return
        }
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(reservationRepresentation)
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
}
