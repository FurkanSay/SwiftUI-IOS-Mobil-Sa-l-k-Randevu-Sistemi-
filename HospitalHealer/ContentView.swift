
//  ContentView.swift
//  HospitalHealer
//
//  Created by Mac on 15.12.2021.
//
import SwiftUI

class GlobalString: ObservableObject {
    @Published var status = ""
    @Published var name = ""
    @Published var tcs = ""
    @Published var surname = ""
    @Published var blood = ""
    @Published var date = ""
    @Published var sex = ""
    @Published var username = ""
    @Published var password = ""
    static let shared = GlobalString()
}
extension String {
    func isNumber() -> Bool {
        return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil && self.rangeOfCharacter(from: CharacterSet.letters) == nil
    }
}
struct ContentView: View {
    
    @State var username = ""
    @State var password = ""
    @State var active: Bool = false
    @State var actives: Bool = false
    @State var showsAlert = false
    @State var manager = HttpAuth()
    @ObservedObject var values :GlobalString = .shared
    @State var all:[String] = []
    @State var infos = ServerMessage(status: "", name: "", tcs: "", surname: "", blood: "", date: "", sex: "", query: "")
    var body: some View {

        let bind  = Binding<String>(get:{
            self.username
        },set:{
            if $0.isNumber(){
                
                username = $0
                print(username + "1")
            }else{
                self.username = $0.filter { "0123456789".contains($0) }
                print(username + "2")
            }
        })
            NavigationView{
                VStack{
                    Text("HospitalHealer").padding()
                    
                    TextField("TC Numarası",text: bind).padding()

                    SecureField("Password",text:$password).padding()

                    NavigationLink(destination:GetDateView(), isActive:$active){}.navigationBarHidden(true).navigationBarTitleDisplayMode(.inline)
                    
                    Button(action:{

                        //manager.checkDetails(tc: self.username, password: self.password,completion: {info in self.infos = ServerMessage(status: info.status,name: info.name,tcs: info.tcs,surname: info.surname,blood: info.blood,date: info.date,sex: info.sex,query: info.query)})
                        //print(infos.status)
                        
                        if username.count > 10 && username.count < 12 {
                            print("1")
                            values.status = manager.checkDetails(tc: self.username, password: self.password).status
                            values.name = manager.checkDetails(tc: self.username, password: self.password).name
                            values.tcs = manager.checkDetails(tc: self.username, password: self.password).tcs
                            values.surname = manager.checkDetails(tc: self.username, password: self.password).surname
                            values.blood = manager.checkDetails(tc: self.username, password: self.password).blood
                            values.date = manager.checkDetails(tc: self.username, password: self.password).date
                            values.sex = manager.checkDetails(tc: self.username, password: self.password).sex
                            values.username = manager.checkDetails(tc: self.username, password: self.password).username
                            values.password = manager.checkDetails(tc: self.username, password: self.password).password
                            
                           if values.status == "OK"{
                                self.active.toggle()
                            }
                        }else{
                            showsAlert.toggle()
                        }
                        
                       print("4")

                    }) {

                        Text("Login")

                    }.alert(isPresented: self.$showsAlert) {
                        Alert(title:  Text("Hata"), message:  Text("TC 11 haneli olmalidir"))
                    }

                    NavigationLink(destination: SignInView(),isActive:$actives){

                    Text("Sign Up").padding()

                    }.navigationBarHidden(true).navigationBarTitleDisplayMode(.inline)
                   
                    NavigationLink(destination: adminloginpanel()){

                        Image(systemName: "info.circle").padding()

                    }.navigationBarHidden(true).navigationBarTitleDisplayMode(.inline)
                      }.navigationBarHidden(true).navigationBarTitleDisplayMode(.inline)

            }.navigationBarHidden(true).navigationBarTitleDisplayMode(.inline)
    }

  

}












struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()

    }

}
