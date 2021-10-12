//
//  ServerConnector.swift
//  vGuest Extension
//
//  Created by Shariq Hussain on 10/04/18.
//  Copyright © 2018 Shariq. All rights reserved.
//

import Foundation

protocol ViewControllerProtocol  {
    func initilizationHandler(status: Bool, data: NSDictionary?, error: NSString?) -> Void
}

protocol InitializationProtocol {
    func initilizationHandlerNew(urlResponse: URLResponse?, data : Data?, error : Error? ) -> Void
}

protocol PlayerListProtocol {
     func initilizationHandlerPlayerList(status: Bool, data: NSDictionary?, error: NSString?) -> Void
}

protocol PlayerListFavouriteProtocol {
    func initializerHandlerFavourite(status: Bool, data: NSDictionary?, error: NSString?, Index : Int) -> Void
}

protocol ViewControllerProtocolForRoleCodeValidation {
    func initilizationHandlerForRoleCodeValidation(status: Bool, data: NSDictionary?, error: NSString?) -> Void
}

class ServerConnector: URLSession {
    var baseViewController:String?  = nil
    var initializerHandlerDelegate : ViewControllerProtocol?
    var initializerHandlerNewDelegate : InitializationProtocol?
    var initializerHandlerPlayerListDelegate : PlayerListProtocol?
    var initializerHandlerDelegateForRoleCodeValidation : ViewControllerProtocolForRoleCodeValidation?
    var initializerHandlerFavouriteDelegate : PlayerListFavouriteProtocol?
    
  
    func datataskNew(request1: NSMutableURLRequest, method1: String) -> Void
    {
        
        request1.httpMethod=method1
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        var datatask1 : URLSessionDataTask?
        if datatask1 == nil {
            datatask1?.cancel()
        }
        
        datatask1 = session.dataTask(with: request1 as URLRequest, completionHandler: {
            (data, response, error) in
            
            self.initializerHandlerNewDelegate?.initilizationHandlerNew(urlResponse: response, data: data, error: error)

            
        })
        datatask1?.resume()
    }

    
    func datatask(request1: NSMutableURLRequest, method1: String) -> Void
    {
        request1.httpMethod=method1
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        var datatask1 : URLSessionDataTask?
        if datatask1 == nil {
            datatask1?.cancel()
        }
        
        datatask1 = session.dataTask(with: request1 as URLRequest, completionHandler: {
            (data, response, error) in

            if error != nil {
                print(error!.localizedDescription)
                self.initializerHandlerDelegate?.initilizationHandler(status: false, data: nil, error: error!.localizedDescription as NSString)
            }
            else
            {
                #if  DEBUG
                let responseString = String(data: data!, encoding: .utf8)
                print("responseString = \(responseString!)")
                #endif
                
                do {
                    
                    guard let dataMain = data
                    else
                    {
                        self.initializerHandlerDelegate?.initilizationHandler(status: false, data: nil, error: nil)
                       return
                    }
                    
                    do{
//                        let parsedData = try JSONDecoder().decode(ValidateUser.self, from: dataMain)
//                        print(parsedData)
                    }
                    catch
                    {
                        print("Error info: \(error)")
                        print("error in JSONSerialization")
                        self.initializerHandlerDelegate?.initilizationHandler(status: false, data: nil, error: nil)
                    }
                  
                    
                    if  let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    {
                        print(json)
                        self.initializerHandlerDelegate?.initilizationHandler(status: true, data: json, error: nil)
                    }
                    else
                    {
                        let jsonStr=NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Could not parse JSON string \(jsonStr)")
                        self.initializerHandlerDelegate?.initilizationHandler(status: false, data: nil, error: jsonStr)
                    }
                }
                catch
                {
                    print("Error info: \(error)")
                    print("error in JSONSerialization")
                    self.initializerHandlerDelegate?.initilizationHandler(status: false, data: nil, error: nil)
                    
                }
                
            }
            
        })
        datatask1?.resume()
    }
    
    
    func datataskForRoleCodeValidation(request1: NSMutableURLRequest, method1: String) -> Void
    {
        request1.httpMethod=method1
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        var datatask1 : URLSessionDataTask?
        if datatask1 == nil {
            datatask1?.cancel()
        }
        
        datatask1 = session.dataTask(with: request1 as URLRequest, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                self.initializerHandlerDelegateForRoleCodeValidation?.initilizationHandlerForRoleCodeValidation(status: false, data: nil, error: error!.localizedDescription as NSString)
            }
            else
            {
                do {
                    print(response!)
                    
                    if  let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    {
                        print(json)
                        self.initializerHandlerDelegateForRoleCodeValidation?.initilizationHandlerForRoleCodeValidation(status: true, data: json, error: nil)
                    }
                    else
                    {
                        
                        let jsonStr=NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Could not parse JSON string \(jsonStr)")
                        self.initializerHandlerDelegateForRoleCodeValidation?.initilizationHandlerForRoleCodeValidation(status: false, data: nil, error: jsonStr)
                    }
                    
                    
                }
                catch
                {
                    print("Error info: \(error)")
                    print("error in JSONSerialization")
                    self.initializerHandlerDelegateForRoleCodeValidation?.initilizationHandlerForRoleCodeValidation(status: false, data: nil, error: error as! NSString)
                    
                }
                
            }
            
        })
        datatask1?.resume()
    }
    
    
    func datataskForPlayerList(request1: NSMutableURLRequest, method1: String) -> Void
    {
        request1.httpMethod=method1
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        var datatask1 : URLSessionDataTask?
        if datatask1 == nil {
            datatask1?.cancel()
        }
        datatask1 = session.dataTask(with: request1 as URLRequest, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                self.initializerHandlerPlayerListDelegate?.initilizationHandlerPlayerList(status: false, data: nil, error: error!.localizedDescription as NSString)
            }
            else
            {
                do {
                    print(response!)
                    
                    if  let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    {
                        print(json)
                        self.initializerHandlerPlayerListDelegate?.initilizationHandlerPlayerList(status: true, data: json, error: nil)
                    }
                    else
                    {
                        let jsonStr=NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Could not parse JSON string \(jsonStr)")
                        self.initializerHandlerPlayerListDelegate?.initilizationHandlerPlayerList(status: false, data: nil, error: jsonStr)
                    }
                    
                }
                catch
                {
                    print("Error info: \(error)")
                    print("error in JSONSerialization")
                    self.initializerHandlerPlayerListDelegate?.initilizationHandlerPlayerList(status: false, data: nil, error: error as! NSString)
                    
                }
                
            }
            
        })
        datatask1?.resume()
    }

    func datataskForPlayerListFavourite(request1: NSMutableURLRequest, method1: String, ind : Int) -> Void
    {
        request1.httpMethod=method1
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        var datatask1 : URLSessionDataTask?
        if datatask1 == nil {
            datatask1?.cancel()
        }
        datatask1 = session.dataTask(with: request1 as URLRequest, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                self.initializerHandlerFavouriteDelegate?.initializerHandlerFavourite(status: false, data: nil, error: error!.localizedDescription as NSString, Index: ind)
            }
            else
            {
                do {
                    print(response!)
                    
                    if  let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    {
                        print(json)
                        self.initializerHandlerFavouriteDelegate?.initializerHandlerFavourite(status: true, data: json, error: nil, Index: ind)
                    }
                    else
                    {
                        
                        let jsonStr=NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Could not parse JSON string \(jsonStr)")
                        self.initializerHandlerFavouriteDelegate?.initializerHandlerFavourite(status: false, data: nil, error: jsonStr, Index: ind)
                        
                        
                    }
                }
                catch
                {
                    print("Error info: \(error)")
                    print("error in JSONSerialization")
                    self.initializerHandlerFavouriteDelegate?.initializerHandlerFavourite(status: false, data: nil, error: error as! NSString, Index: ind)
                    
                }
                
            }
            
        })
        datatask1?.resume()
    }
}
