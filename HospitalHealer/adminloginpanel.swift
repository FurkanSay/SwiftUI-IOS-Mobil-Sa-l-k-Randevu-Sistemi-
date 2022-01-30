//
//  adminloginpanel.swift
//  HospitalHealer
//
//  Created by Mac on 19.01.2022.
//

import SwiftUI
class admins: Decodable, Hashable {
    
    var result: String
    
    static func == (lhs: admins, rhs: admins) -> Bool {
        return lhs.result == rhs.result
    }
    func hash(into hasher: inout Hasher){
        hasher.combine(result)
        
    }

    
}

struct adminloginpanel:View{ // burayi cagiralacak gizli bir button ekleme

    @State var adminuser = ""

    @State var Apassword = ""
    @State var sonuc = ""
    @State var adminn:[admins] = []
    @State var bool:Bool = false
        var body: some View{

            NavigationView{

        VStack{
            NavigationLink(destination: adminpanel(), isActive:$bool){}.navigationBarHidden(true).navigationBarTitleDisplayMode(.inline)
            TextField("Username",text:$adminuser).padding()

            TextField("Password",text:$Apassword).padding()

            
            Button {
                adminz(username: adminuser, password: Apassword)
                if(sonuc == "OK"){
                    bool.toggle()
                   
                   
               }
            } label: {
                Text("Login")
            }

           

    }.navigationBarHidden(true).navigationBarTitleDisplayMode(.inline)

            }.navigationBarHidden(true).navigationBarTitleDisplayMode(.inline)
}
    
    
    func adminz(username:String,password:String){
        guard let url: URL = URL(string: "https://www.furkansay.com/swiftui/admin.php") else {
            print("invalid URL")
            return
        }
        let parameters: [String: Any] = [
            "username":  username,
            "password": password
            
        ]
        print(username)
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = parameters.percentEncoded()
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            
            guard let data = data else {
                print("invalid response")
                return
            }
            
            // convert JSON response into class model as an array
            do {
                self.adminn = try JSONDecoder().decode([admins].self, from: data)
                for items in adminn {
                    print(items.result)
                    sonuc = items.result
                }
                
            } catch {
                print(error.localizedDescription)
            }
                
          
        }).resume()
    }
    
    
}

struct adminloginpanel_Previews: PreviewProvider {
    static var previews: some View {
        adminloginpanel()
    }
}
