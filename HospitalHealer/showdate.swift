//
//  showdate.swift
//  HospitalHealer
//
//  Created by Mac on 18.01.2022.
//

import SwiftUI

class getdates: Decodable, Hashable {
    
    
    var RandevuSaat: String
    var RandevuTarih:String
    var RandevuHastaneADI:String
    var RandevuBolumADI:String
    var RandevuDoktorNAME:String
    var RandevuDoktorSURNAME:String
    var RandevuCONTROL:String
    
    static func == (lhs: getdates, rhs: getdates) -> Bool {
        return lhs.RandevuSaat == rhs.RandevuSaat
    }
    func hash(into hasher: inout Hasher){
        hasher.combine(RandevuSaat)
}
}
struct showdate: View {
    @State var delitem:[Resadddate] = []
    @State var getdts:[getdates] = []
    @ObservedObject var values :GlobalString = .shared
    @State var Randevuc:String = ""
    var body: some View {
        NavigationView{
            List{
                ForEach((getdts), id: \.self) { num in
                
                HStack {
                    Text("\(num.RandevuSaat + "\n" + num.RandevuTarih + "\n" + num.RandevuBolumADI + "\n" + num.RandevuDoktorNAME + " " + num.RandevuDoktorSURNAME + "\n" + num.RandevuHastaneADI )").onTapGesture{
                        Randevuc = num.RandevuCONTROL
                        print(Randevuc)
                    }
                    
                    
                    
                    Spacer()
                }.padding()
                
                Divider()
                    .background(Color(.systemGray4))
                    .padding(.leading)
            }.onDelete(perform: delete)
            }
        }.navigationBarHidden(true).onAppear{
            getdate(tcss: values.tcs)
        }
        
    }
    func delete(at offsets: IndexSet) {
            print(Randevuc)
           deletedate(rcontrol: Randevuc)
        getdate(tcss: values.tcs)
       }
    func getdate(tcss:String){
        guard let url: URL = URL(string: "https://www.furkansay.com/swiftui/getdate.php") else {
            print("invalid URL")
            return
        }
        let parameters: [String: Any] = [
            "tc":  tcss
            
        ]
        
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
                self.getdts = try JSONDecoder().decode([getdates].self, from: data)
                
                
            } catch {
                print(error.localizedDescription)
            }
                
          
        }).resume()
    }
    func deletedate(rcontrol:String){
        guard let url: URL = URL(string: "https://www.furkansay.com/swiftui/deldate.php") else {
            print("invalid URL")
            return
        }
        let parameters: [String: Any] = [
            "RandevuCONTROL":  rcontrol
            
        ]
        print(rcontrol)
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
                self.delitem = try JSONDecoder().decode([Resadddate].self, from: data)
                for items in delitem {
                    print(items.sonuc)
                }
                
            } catch {
                print(error.localizedDescription)
            }
                
          
        }).resume()
    }
}

struct showdate_Previews: PreviewProvider {
    static var previews: some View {
        showdate()
    }
}
