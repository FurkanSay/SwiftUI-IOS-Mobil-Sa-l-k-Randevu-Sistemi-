//
//  SignInView.swift
//  HospitalHealer
//
//  Created by Mac on 31.12.2021.
//

import SwiftUI

class signin: Decodable, Hashable {
    
    var sonuc: String
    
    static func == (lhs: signin, rhs: signin) -> Bool {
        return lhs.sonuc == rhs.sonuc
    }
    func hash(into hasher: inout Hasher){
        hasher.combine(sonuc)
        
    }

    
}
struct SignInView: View {
    @State var signUser = SignUser(tc: "", name: "", surname: "",password: "", blood: "", birthdate: Date(), province: "",sex: "")
    @Environment(\.dismiss) var dismiss
    @State var sign: [signin] = []
    @State var resul:String = ""
    @State var info:String = ""
    @State var showsAlert = false
    var blood = ["0rh+", "0rh-", "ABrh-", "ABrh+","Brh-","Brh+","Arh-","Arh+"]
    var sex = ["Erkek","Kadın"]
    @State private var selectedColor = "Red"
    var body: some View {
        
        NavigationView{

        VStack{

            TextField("TC",text:$signUser.tc).padding()

            TextField("Name",text:$signUser.name).padding()

            TextField("Surname",text:$signUser.surname).padding()

            TextField("Password",text:$signUser.password).padding()

            TextField("Province",text:$signUser.province).padding()

            DatePicker("Birthdate",selection: $signUser.birthdate,displayedComponents: [.date]).padding()

            Picker("Please choose Blood Group", selection: $signUser.blood) {
                           ForEach(blood, id: \.self) {
                               Text($0)
                           }
                       }

            Picker("Please choose Sex ", selection: $signUser.sex) {
                           ForEach(sex, id: \.self) {
                               Text($0)
                           }
                       }
            Button(action: {
                if(signUser.tc.isEmpty || signUser.name.isEmpty || signUser.surname.isEmpty || signUser.password.isEmpty || signUser.province.isEmpty || signUser.blood.isEmpty || signUser.sex.isEmpty){
                    
                    info = "Tüm Boşlukları doldurun lütfen..."
                    self.showsAlert.toggle()
                    
                }else{
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                formatter.string(from: signUser.birthdate)
                signup(signUser.tc, signUser.name,signUser.surname,signUser.password,signUser.province,formatter.string(from: signUser.birthdate)
,signUser.blood,signUser.sex)
                if(resul == "OK"){

                    self.showsAlert.toggle()
                    info = "Kayit islemi Basarili"
                    dismiss()
                    

                    
                }else{
                    self.showsAlert.toggle()
                    info = "Boyle bir kayit mevcut"
                    
                    

                }}
                    }) {
                        Text("Register")
                    }
                    .alert(isPresented: self.$showsAlert) {
                        Alert(title: Text("\(info)"))
                    }
            Button {
                dismiss()
            } label: {
                Text("Back")
            }.padding()

            

        }.navigationBarHidden(true).navigationBarTitleDisplayMode(.inline)
        }.navigationBarHidden(true).navigationBarTitleDisplayMode(.inline)
    }
    func signup(_ tc:String,_ name:String,_ surname:String,_ password:String,_ province:String,_ date:String,_ blood:String,_ sex:String){

        guard let url: URL = URL(string: "https://www.furkansay.com/swiftui/signin.php") else {
            print("invalid URL")
            return
        }
        let parameters: [String:Any] = [
            "HastaTC": tc,
            "HastaADI": name,
            "HastaSOYADI": surname,
            "HastaPASSWORD": password,
            "HastaIlName": province,
            "HastaDOGUMTARIHI": date,
            "HastaKANGRUBU": blood,
            "HastaCINSIYETI": sex
        ]
        print(parameters.values)
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
                self.sign = try JSONDecoder().decode([signin].self, from: data)
                for items in self.sign {
                    
                    DispatchQueue.main.sync {
                    print(items.sonuc)
                    resul = items.sonuc
                    }
                }
                
            } catch {
                print(error)
            }
        }).resume()


    }
}
struct SignUser {
    var tc:String
    var name:String
    var surname:String
    var password:String
    var blood:String
    var birthdate:Date
    var province:String
    var sex:String
    
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
