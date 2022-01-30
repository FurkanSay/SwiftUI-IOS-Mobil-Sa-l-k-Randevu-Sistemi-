//
//  Api.swift
//  HospitalHealer
//
//  Created by Mac on 1.01.2022.
//

import Foundation
import Combine
import SwiftUI

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}
extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}


struct ServerMessage: Decodable{
    let status,name,tcs,surname,blood,date,sex,query:String?
}


class HttpAuth: ObservableObject {
    @Published var status = ""
    @Published var name = ""
    @Published var tcs = ""
    @Published var surname = ""
    @Published var blood = ""
    @Published var date = ""
    @Published var sex = ""
    @Published var username = ""
    @Published var password = ""
    
    
    var didChange = PassthroughSubject<HttpAuth,Never>()
    
    var autheticated = false {
        didSet{
            didChange.send(self)
        }
    }
  
    func checkDetails(tc:String,password:String) ->(status:String,name:String,tcs:String,surname:String,blood:String,date:String,sex:String,username:String,password:String){
        self.username = tc
        self.password = password
        print("0")

        guard let url = URL(string: "https://www.furkansay.com/swiftui/login.php") else{
            fatalError("Missing URL")
        }
        
        let parameters: [String: Any] = [
            "tc":  self.username,
            "password": self.password
        ]
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = parameters.percentEncoded()
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request){ (data,res,error) in
            if error != nil {
                print("error",error?.localizedDescription ?? "")
            }
            do {
                print("2")
                if let data = data{
                    let result = try JSONDecoder().decode(ServerMessage.self, from:data)
                    DispatchQueue.main.sync {
                        print(result)
                        self.status = result.status ?? "1"
                        self.name = result.name ?? ""
                        self.blood = result.blood ?? ""
                        self.tcs = result.tcs ?? ""
                        self.surname = result.surname ?? ""
                        self.sex = result.sex ?? ""
                        self.date = result.date ?? ""
                        
                       
                       
                        print("" ,self.status)
                        
                    }
                } else {
                    print("No data")
                }
            } catch let JsonError{
                print("fetch json error:",JsonError.localizedDescription)
            }
        }.resume()
        print("3",status)
        return (status,name,tcs,surname,blood,date,sex,username,password)
    }
    
}
/*
 func checkDetails(tc:String,password:String,completion: @escaping ((ServerMessage) -> Void)){
     self.username = tc
     self.password = password
     
     print("6")
     guard let url = URL(string: "https://www.furkansay.com/swiftui/login.php") else{
         fatalError("Missing URL")
     }
     
     let parameters: [String: Any] = [
         "tc":  self.username,
         "password": self.password
     ]
     var request = URLRequest(url: url)
     print("5")
     request.httpMethod = "POST"
     request.httpBody = parameters.percentEncoded()
     request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
     request.setValue("application/json", forHTTPHeaderField: "Accept")
     URLSession.shared.dataTask(with: request){ (data,res,error) in
         if error != nil {
             print("error",error?.localizedDescription ?? "")
         }else{
         do {
             print("4")
             if let data = data{
                 let result = try JSONDecoder().decode(ServerMessage.self, from:data)
                 DispatchQueue.main.async {
                     print(result)
                     self.info = result
                     
                     self.status = result.status ?? ""
                     self.name = result.name ?? ""
                     self.blood = result.blood ?? ""
                     self.tcs = result.tcs ?? ""
                     self.surname = result.surname ?? ""
                     self.sex = result.sex ?? ""
                     self.date = result.date ?? ""
                     
                    
                     completion(self.info)
                     print(self.info)
                     print("2",self.status)
                     
                 }
             } else {
                 print("No data")
             }
         } catch let JsonError{
             print("fetch json error:",JsonError.localizedDescription)
         }
         }
     }.resume()
     print("3",status)
     
 }
 */
