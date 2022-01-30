//
//  adminpanel.swift
//  HospitalHealer
//
//  Created by Mac on 19.01.2022.
//

import SwiftUI

class addhospital: Decodable, Hashable {
    
    var sonuc: String
    
    static func == (lhs: addhospital, rhs: addhospital) -> Bool {
        return lhs.sonuc == rhs.sonuc
    }
    func hash(into hasher: inout Hasher){
        hasher.combine(sonuc)
        
    }

    
}
class addbolums: Decodable, Hashable {
    
    var sonuc: String
    
    static func == (lhs: addbolums, rhs: addbolums) -> Bool {
        return lhs.sonuc == rhs.sonuc
    }
    func hash(into hasher: inout Hasher){
        hasher.combine(sonuc)
        
    }

    
}
class adddoktorz: Decodable, Hashable {
    
    var sonuc: String
    
    static func == (lhs: adddoktorz, rhs: adddoktorz) -> Bool {
        return lhs.sonuc == rhs.sonuc
    }
    func hash(into hasher: inout Hasher){
        hasher.combine(sonuc)
        
    }

    
}

class BolumModel: Decodable, Hashable {
    
    
    var bolumadi: String
    static func == (lhs: BolumModel, rhs: BolumModel) -> Bool {
        return lhs.bolumadi == rhs.bolumadi
    }
    func hash(into hasher: inout Hasher){
        hasher.combine(bolumadi)
}
}

class HastaneModel: Decodable, Hashable {
    
    
    
    var hastaneadi:String
    static func == (lhs: HastaneModel, rhs: HastaneModel) -> Bool {
        return lhs.hastaneadi == rhs.hastaneadi
    }
    func hash(into hasher: inout Hasher){
        hasher.combine(hastaneadi)
}
}
struct Hospital: View {
    @Environment(\.dismiss) var dismiss
    @State var hastaneadi:String = ""
    @State var hastaneil:String = ""
    @State var hastaneilce:String = ""
    @State var hastanedurum:String = ""
    @State var hastaneadresi:String = ""
    @State var hastanetel:String = ""
    @State var info:String = ""
    @State var showsalert:Bool = false
    @State var addhas:[addhospital] = []
    
    var body: some View {
        
        TextField("Hastane Adi",text: $hastaneadi).padding()
        TextField("Hastane il",text: $hastaneil).padding()
        TextField("Hastane Ilce",text: $hastaneilce).padding()
        TextField("Hastane (Özel,Devlet)",text: $hastanedurum).padding()
        TextField("Hastane Adres",text: $hastaneadresi).padding()
        TextField("Hastane Tel",text: $hastanetel).padding()
        Button(action: {
            if(hastaneadi.isEmpty || hastaneil.isEmpty || hastaneilce.isEmpty || hastanedurum.isEmpty || hastaneadresi.isEmpty || hastanetel.isEmpty ){
                
                info = "Tüm Boşlukları doldurun lütfen..."
                self.showsalert.toggle()
                
            }else{
                addhost(hastaneadi: hastaneadi, hastaneil: hastaneil, hastaneilce: hastaneilce, hastanedurum: hastanedurum, hastaneadresi: hastaneadresi, hastanetel: hastanetel)
            showsalert.toggle()
            dismiss()
            }
                }) {
                    Text("Add Hospital")
                }
                .alert(isPresented: self.$showsalert) {
                    Alert(title: Text("\(info)"))
                }

        
    }
    
    func addhost(hastaneadi:String,hastaneil:String,hastaneilce:String,hastanedurum:String,hastaneadresi:String,hastanetel:String){
        guard let url: URL = URL(string: "https://www.furkansay.com/swiftui/hospitaladd.php") else {
            print("invalid URL")
            return
        }
        let parameters: [String:Any] = [
            "hastaneadi": hastaneadi,
            "hastaneil": hastaneil,
            "hastaneilce": hastaneilce,
            "hastanedurum": hastanedurum,
            "hastaneadresi": hastaneadresi,
            "hastanetel": hastanetel
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
                self.addhas = try JSONDecoder().decode([addhospital].self, from: data)
                for items in self.addhas {
                    print(items.sonuc)
                    info = items.sonuc
                }
                
            } catch {
                print(error)
            }
        }).resume()
    }
    
}
struct Part:View{
    @Environment(\.dismiss) var dismiss
    @State var addbolumz:[addbolums] = []
    @State var info:String = ""
    @State var bolums:String = ""
    @State var tags:String = ""
    @State var showsalert = false
    var body: some View{
        VStack{
            TextField("Bolum Ekle",text:$bolums).padding()
            TextField("Tag Ekle",text:$tags).padding()
            Button(action: {
                if(bolums.isEmpty || tags.isEmpty){
                    
                    info = "Tüm Boşlukları doldurun lütfen..."
                    self.showsalert.toggle()
                    
                }else{
                    addpart(bolumad: bolums, bolumtags: tags)
                showsalert.toggle()
                dismiss()
                }
                    }) {
                        Text("Add Part")
                    }
                    .alert(isPresented: self.$showsalert) {
                        Alert(title: Text("\(info)"))
                    }

        }
    }
    
    func addpart(bolumad:String,bolumtags:String){
        guard let url: URL = URL(string: "https://www.furkansay.com/swiftui/bolumadd.php") else {
            print("invalid URL")
            return
        }
        let parameters: [String:Any] = [
            "bolumadi": bolumad,
            "tags": bolumtags
            
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
                self.addbolumz = try JSONDecoder().decode([addbolums].self, from: data)
                for items in self.addbolumz {
                    print(items.sonuc)
                    info = items.sonuc
                }
                
            } catch {
                print(error)
            }
        }).resume()
    }
}
struct Doktor:View{
    @Environment(\.dismiss) var dismiss
    @State var adddok:[adddoktorz] = []
    
    
    @State var info:String = ""
    @State var sex:String = ""
    @State var derece:String = ""
    @State var no:String = ""
    @State var name:String = ""
    @State var surname:String = ""
    @State var boluma:String = ""
    @State var nameofhos:String = ""
    @State var showsalert = false
    @State var sexar = ["Erkek","Kadin"]
    @ObservedObject var valuess :bolumhos = .shared
    var body: some View{
        VStack{
            TextField("Doktor Derece(Doc.Dr)",text:$derece).padding()
            TextField("Doktor No",text:$no).padding()
            TextField("Doktor Adi",text:$name).padding()
            TextField("Doktor Soyadi",text:$surname).padding()
            Picker("", selection: $boluma) {
                ForEach(valuess.bolumms, id: \.self) {
                               Text($0)
                           }
                       }
            Picker("", selection: $nameofhos) {
                ForEach(valuess.hosputal, id: \.self) {
                               Text($0)
                           }
                       }
            Picker("", selection: $sex) {
                           ForEach(sexar, id: \.self) {
                               Text($0)
                           }
                       }
            Button(action: {
                if(derece.isEmpty || no.isEmpty || name.isEmpty || surname.isEmpty || boluma.isEmpty || nameofhos.isEmpty){
                    
                    info = "Tüm Boşlukları doldurun lütfen..."
                    self.showsalert.toggle()
                    
                }else{
                    adddoktor(doktorderece: derece, doktorno: no, doktorad: name, doktorsoyad: surname, bolumadi: boluma, hastaneadi: nameofhos, doktorsex: sex)
                showsalert.toggle()
                dismiss()
                }
                    }) {
                        Text("Add Doctor")
                    }
                    .alert(isPresented: self.$showsalert) {
                        Alert(title: Text("\(info)"))
                    }
        }
    }
    
    func adddoktor(doktorderece:String,doktorno:String,doktorad:String,doktorsoyad:String,bolumadi:String,hastaneadi:String,doktorsex:String){
        guard let url: URL = URL(string: "https://www.furkansay.com/swiftui/doktoradd.php") else {
            print("invalid URL")
            return
        }
        let parameters: [String:Any] = [
            "doktorderece": doktorderece,
            "doktorno": doktorno,
            "doktorad": doktorad,
            "doktorsoyad": doktorsoyad,
            "bolumadi": bolumadi,
            "hastaneadi": hastaneadi,
            "doktorsex": doktorsex
            
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
                self.adddok = try JSONDecoder().decode([adddoktorz].self, from: data)
                for items in self.adddok {
                    print(items.sonuc)
                    info = items.sonuc
                }
                
            } catch {
                print(error)
            }
        }).resume()
    }
    
   
}
class bolumhos: ObservableObject {
    @Published var bolumms:[String] = []
    @Published var hosputal:[String] = []
    static let shared = bolumhos()
}
struct adminpanel:View{
    @State private var hastane = false
    @State private var bolum = false
    @State private var doktor = false
    @State var bolumM:[BolumModel] = []
    @State var HastaneM:[HastaneModel] = []
    @ObservedObject var valuess :bolumhos = .shared

    var body: some View{

        VStack{
            
               // hastane doktor bolum tag ekleme yeri
            Button("Hastane Ekle") {
                hastane.toggle()
                    }
                    .sheet(isPresented: $hastane) {
                        Hospital()
                    }.padding().foregroundColor(Color.white).background(Color.gray).cornerRadius(25)
            
            Button("Bölüm Ekle") {
                        bolum.toggle()
                    }
                    .sheet(isPresented: $bolum) {
                        Part()
                    }.padding().foregroundColor(Color.white).background(Color.gray).cornerRadius(25)
            
            Button("Doktor Ekle") {
                        doktor.toggle()
                    }
                    .sheet(isPresented: $doktor) {
                        Doktor()
                    }.padding().foregroundColor(Color.white).background(Color.gray).cornerRadius(25)

        }.onAppear {
            getbolums()
            gethospital()
        }.background{AsyncImage(url: URL(string: "https://wallpaperaccess.com/full/797185.png"))}
    }
    func getbolums(){
        guard let url: URL = URL(string: "https://www.furkansay.com/swiftui/getbolum.php") else {
            print("invalid URL")
            return
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            // check if response is okay
            
            guard let data = data else {
                print("invalid response")
                return
            }
            
            // convert JSON response into class model as an array
            do {
                self.bolumM = try JSONDecoder().decode([BolumModel].self, from: data)
                for items in self.bolumM {
                    valuess.bolumms.append(items.bolumadi)
                    print(items.bolumadi)
                }
                
            } catch {
                print(error.localizedDescription)
            }
            
        }).resume()
    }
    
    func gethospital(){
        guard let url: URL = URL(string: "https://www.furkansay.com/swiftui/gethastane.php") else {
            print("invalid URL")
            return
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            // check if response is okay
            
            guard let data = data else {
                print("invalid response")
                return
            }
            
            // convert JSON response into class model as an array
            do {
                self.HastaneM = try JSONDecoder().decode([HastaneModel].self, from: data)
                for items in self.HastaneM {
                    valuess.hosputal.append(items.hastaneadi)
                    print(items.hastaneadi)
                }
                
            } catch {
                print(error.localizedDescription)
            }
            
        }).resume()
    }
}

struct adminpanel_Previews: PreviewProvider {
    static var previews: some View {
        adminpanel()
    }
}

