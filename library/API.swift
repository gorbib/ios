//
//  BookService.swift
//  Library
//
//  Created by Andrey Polyskalov on 20.03.15.
//  Copyright (c) 2015 Andrey Polyskalov. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON
import Haneke


class API {
    
    // Singleton
    class var sharedInstance: API {
        struct Singleton {
            static let instance = API()
        }
        return Singleton.instance
    }
    
    
    let API_URL = "https://library-api.polyskalov.com/"

        
    let session = Alamofire.SessionManager.default.session
    
    
   
    /**
    Search something in catalog
    
    - parameter searchQuery: Text for searching
    - parameter forPage:     Page of search results
    - parameter limit:       Limit returned results
    - parameter completion:  Completion handler
    */
    func search(_ searchQuery:String, forPage page:Int = 0, limit:Int = 10, fail: ((NSError?) -> ())? = nil, completion: @escaping ([Book], _ count:Int) -> Void) {
        
        print("Reader: — Can you search a book named «\(searchQuery)» for me, please?")
        
        print("Librarian: — Of course, wait…")

        
        self.request("search", params: [
            
            "q": searchQuery as AnyObject,//.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!,
            "page": page,
            "per_page": limit
            
        ],
            fail: fail,
            success: {
                json in

                var result:[Book] = []

                for (_, bookJson):(String, SwiftyJSON.JSON) in json["books"] {
                    result.append(Book(json: bookJson))
                }

                completion(result, json["count"].intValue)
            }

        )
    }
    
    /**
    Search something in catalog
    
    - parameter searchQuery: Text for searching
    - parameter forPage:     Page of search results
    - parameter limit:       Limit returned results
    - parameter completion:  Completion handler
    */
    func getBooksByAuthor(withName author:String, forPage page:Int = 0, limit:Int = 10, fail: ((NSError?) -> ())? = nil, completion: @escaping (_ result: SwiftyJSON.JSON) -> Void) {
        
        print("Reader: — Can you search books by «\(author)» for me, please?")
        
        print("Librarian: — Of course, wait…")
        
        self.request("search", params: [
            
            "q": "700: " + author,
            "page": page,
            "per_page": limit
            
            ],
            fail: fail,
            success: completion
        )
    }

    /**
     Get related books

     - parameter searchQuery: Text for searching
     - parameter forPage:     Page of search results
     - parameter limit:       Limit returned results
     - parameter completion:  Completion handler
     */
    func getRelatedBooks(toBook bookId:Int, forPage page:Int = 0, limit:Int = 10, fail: ((NSError?) -> ())? = nil, completion: @escaping ([Book]) -> Void) {

        self.request("books/"+String(bookId)+"/related", params: [
            "page": page,
            "per_page": limit
            ],
            fail: fail,
            success: {
                response in

                var result:[Book] = []

                for (_, bookJson):(String, SwiftyJSON.JSON) in response {
                    result.append(Book(json: bookJson))
                }

                completion(result)
            }
        )
    }
    
    
    /**
    Make request to API with **:params:** and run **:completion:** after success
    
    - parameter method:      The API method.
    - parameter params:      Request parameters.
    - parameter completion:  Completion handler.
    */
    func request(_ method:String, params: [String:Any]? = nil, fail: ((NSError?) -> ())? = nil, success: @escaping (_ result: SwiftyJSON.JSON) -> Void) {

        print("(Librarian walk into library book storage to find [\(method)] with \(params))")
        
        Alamofire.request(API_URL + method, parameters: params).responseData {
            response in

            if let data = response.data , response.response?.statusCode == 200 {

                let json = JSON(data: data)

                if json["error"].isEmpty {
                    print("(Librarian looked up and comes back)")
                    success(json)
                } else {
                    fail?(NSError(domain: "api.library", code: 0, userInfo: ["message": "Server side error" + (json["error"].string ?? "")]))
                }

            } else {

                print("Librarian: Oh, no! It seems bad!!1")

                print("Librarian: \(response.response?.statusCode), «\(response.response?.description)»")

                fail?(NSError(domain: "api.library", code: 0, userInfo: ["message": "Something wrong with network"]))
            }
        }
        
    }


}
