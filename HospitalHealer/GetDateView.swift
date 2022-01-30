//
//  GetDateView.swift
//  HospitalHealer
//
//  Created by Mac on 31.12.2021.
//

import SwiftUI


class ResponseModel: Decodable, Hashable {
    
    var il: String
    var ilkodu:String
    
    static func == (lhs: ResponseModel, rhs: ResponseModel) -> Bool {
        return lhs.il == rhs.il && lhs.ilkodu == rhs.ilkodu
    }
    func hash(into hasher: inout Hasher){
        hasher.combine(il)
        hasher.combine(ilkodu)
    }
    
}
class ResponseModelcity: Decodable, Hashable {
    
    var ilce: String
    static func == (lhs: ResponseModelcity, rhs: ResponseModelcity) -> Bool {
        return lhs.ilce == rhs.ilce
    }
    func hash(into hasher: inout Hasher){
        hasher.combine(ilce)
    }
    
}
class ResponseModelproblem: Decodable, Hashable {
    
    
    var bolum: String
    var doktoradi:String
    var doktorsoyadi:String
    var hastaneadi:String
    static func == (lhs: ResponseModelproblem, rhs: ResponseModelproblem) -> Bool {
        return lhs.bolum == rhs.bolum
    }
    func hash(into hasher: inout Hasher){
        hasher.combine(bolum)
}
}

class Resadddate: Decodable, Hashable {
    
    var sonuc: String
    
    static func == (lhs: Resadddate, rhs: Resadddate) -> Bool {
        return lhs.sonuc == rhs.sonuc
    }
    func hash(into hasher: inout Hasher){
        hasher.combine(sonuc)
        
    }

    
}
struct GetDateView: View {
    @State var showdatesz:Bool = false
    @State var models: [ResponseModel] = []
    @State var modelscity: [ResponseModelcity] = []
    @State var modelsproblems: [ResponseModelproblem] = []
    @State var resuls:[Resadddate] = []
    @Environment(\.presentationMode) var presentationMode
    @State var userInfo = UserInfo(tc: "", name: "", surname: "", blood: "", city: "", doctordatecount: "", date: Date(), province: "", district: "", problem: "")
    @ObservedObject var values :GlobalString = .shared
    @State var field1 : String = ""
    @State var field2 : String = ""
    @State var field3 : String = ""
    @State var bolumaA: String = ""
    @State var doktorn: String = ""
    @State var doktorsur: String = ""
    @State var hastaneaA: String = ""
    var city = ["Adana","Mersin","Ankara","Kocaeli"]
    @State private var food = ""
    @State private var food1 = ""
    @State private var foodArray = ["Milk", "Apples", "Sugar", "Eggs", "Oranges", "Potatoes", "Corn", "Bread"]

    @State private var country = ""
    @State var booldate = false
    @State private var tag: Int = 1
    @State var isSearching = false
    @State var isSearching1 = false
    @State var isSearching2 = false
    @State var province:[String] = []
    @State var citysz:[String] = []
    @State var hosproblemdoc:[String] = []
    @State var location: String = ""
    @State var selectedDate = Date()
    var body: some View {
        
        NavigationView{
            
            let binding  = Binding<String>(get:{
                self.field1
            },set:{
                self.field1 = $0.uppercased()
            })
            
            let binding1  = Binding<String>(get:{
                self.field2
            },set:{
                self.field2 = $0.uppercased()
            })
            VStack{
            
                Group{
                    NavigationLink(destination:showdate(), isActive:$booldate){}.navigationBarHidden(true).navigationBarTitleDisplayMode(.inline)
                    NavigationLink(destination: DateView(), isActive:$showdatesz){}.navigationBarHidden(true).navigationBarTitleDisplayMode(.inline)
                    
                }
                
            Group{
                Text(values.tcs)
                Text(values.name + " " + values.surname)
                Text(values.blood)
            }
           
            
        
                Group{
                    TextField("Choose Province", text:binding)
                        .padding().onTapGesture(perform: {
                            citysz = []
                            provi()
                            isSearching = true
                        })
                    if isSearching {
                        ScrollView{
                            ForEach((citysz).filter({ "\($0)".contains(field1.uppercased()) || field1.isEmpty }), id: \.self) { num in
                            
                            HStack {
                                Text("\(num)").onTapGesture {
                                    field1 = num
                                    isSearching = false
                                }
                                
                                
                                
                                Spacer()
                            }.padding()
                            
                            Divider()
                                .background(Color(.systemGray4))
                                .padding(.leading)}
                        }
                    }
                
                
                TextField("Choose City", text: binding1)
                    .padding().onTapGesture(perform: {
                        province = []
                        citys()
                        isSearching1 = true
                    })
                if isSearching1 {
                    ScrollView{
                        ForEach((province).filter({ "\($0)".contains(field2.uppercased()) || field2.isEmpty }), id: \.self) { num in
                        
                        HStack {
                            Text("\(num)").onTapGesture {
                                field2 = num
                                isSearching1 = false
                            }
                            
                            
                            
                            Spacer()
                        }.padding()
                        
                        Divider()
                            .background(Color(.systemGray4))
                            .padding(.leading)
                    }
                    }
                }
                
                
                TextField("What is your problem", text: $field3).onChange(of: field3){
                 print($0)
                hosproblemdoc = []
                    findproblem(provinceA: field1, cityA: field2, infoA: field3)
                }
                    .padding().onTapGesture(perform: {
                        isSearching2 = true
                        field3 = ""
                    })
                if isSearching2 {
                    ScrollView{
                    ForEach(modelsproblems, id: \.self) { num in
                        
                        HStack {
                            Text("\( num.bolum + "\n" + num.doktoradi + " " + num.doktorsoyadi + "\n" + num.hastaneadi)").onTapGesture {
                                field3 = num.bolum + "\n" + num.doktoradi + " " + num.doktorsoyadi + "\n" + num.hastaneadi
                                bolumaA = num.bolum
                                doktorn = num.doktoradi
                                doktorsur = num.doktorsoyadi
                                hastaneaA = num.hastaneadi
                                isSearching2 = false
                            }
                            
                            
                            
                            Spacer()
                        }.padding()
                        
                        Divider()
                            .background(Color(.systemGray4))
                            .padding(.leading)
                    }}
                }
                
                }
            DatePicker("", selection: $selectedDate, displayedComponents: .date).onTapGesture{
                
            }
            
            Button {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                let formatter1 = DateFormatter()
                formatter1.dateFormat = "HH:mm"
                print(field1)
                print(field2)
                print(hastaneaA)
                print(doktorn)
                print(doktorsur)
                print(bolumaA)
                print(values.tcs)
                print(formatter.string(from: selectedDate))
                print(formatter1.string(from: selectedDate))
                
                addrandevu(provinceA: values.tcs, cityA: field1, hastaneadiA: field2, doktoradiA: hastaneaA, doktorsoyadsi: doktorn, bolumaadi: doktorsur, dater: bolumaA, hourr: formatter.string(from: selectedDate), tct: formatter1.string(from: selectedDate))
               
            } label: {
                Text("Get Date")
            }.disabled(self.field3.isEmpty)
            
                
                Button {
                    showdatesz.toggle()
                } label: {
                    Text("Show Today Dates")
                }

            
            
            
            
            
            

            //DatePicker("Choose Date",selection: $userInfo.date,displayedComponents: [.date]).padding()
           // List{
          //      Section(header: Text("Form Header"), footer:Text("Form FFooter")){
           //         TextField("line 1",text:$field1).environment(\.isEnabled, true)
           //         TextField("line 2",text:$field2)
          //      }
           // }
            //Button("Get Date") {
                
            //}.padding()


        }.contentShape(Rectangle())
                .onTapGesture {
                  print("The whole VStack is tappable now!")
                
                    
                }
        }.navigationTitle("Anasayfa").toolbar{
            
            Button {
                booldate.toggle()
            } label: {
                
                if !booldate{
                    Text("Show Date")
                    Image(systemName: "heart.fill")
                    
                }else{
                    Text("Go Back")
                    Image(systemName: "heart.fill")
                }            }
            

        }.navigationBarBackButtonHidden(true).navigationBarItems(leading:
                                                                    Button(action: {
                                                                        self.presentationMode.wrappedValue.dismiss()
                                                                    }) {
                                                                        HStack {
                                                                            Image(systemName: "arrow.left.circle")
                                                                            Text("Exit")
                                                                        }
                                                                    })
       

    }
   //https://www.furkansay.com/swiftui/randevuadd.php
    func provi(){
        guard let url: URL = URL(string: "https://www.furkansay.com/swiftui/province.php") else {
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
                self.models = try JSONDecoder().decode([ResponseModel].self, from: data)
                for items in models {
                    citysz.append(items.il)
                }
            } catch {
                print(error.localizedDescription)
            }
            
        }).resume()
    }
    func citys(){
        guard let url: URL = URL(string: "https://www.furkansay.com/swiftui/city.php") else {
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
                self.modelscity = try JSONDecoder().decode([ResponseModelcity].self, from: data)
                for items in self.modelscity {
                    province.append(items.ilce)
                }
                
            } catch {
                print(error.localizedDescription)
            }
            
        }).resume()
    }
    func findproblem(provinceA:String,cityA:String,infoA:String){
        guard let url: URL = URL(string: "https://www.furkansay.com/swiftui/findproblem.php") else {
            print("invalid URL")
            return
        }
        let parameters: [String: Any] = [
            "province":  provinceA,
            "city": cityA,
            "info": infoA
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
                self.modelsproblems = try JSONDecoder().decode([ResponseModelproblem].self, from: data)
                for items in self.modelsproblems {
                    hosproblemdoc.append(items.bolum + "\n" + items.doktoradi + " " + items.doktorsoyadi + "\n" + items.hastaneadi)
                }
                
            } catch {
                print(error.localizedDescription)
            }
                
            // check if response is okay
           /*
            // convert JSON response into class model as an array
            if error != nil {
                print("error",error?.localizedDescription ?? "")
            }
            do {
                print("2")
                if let data = data{
                    let result = try JSONDecoder().decode(ResponseModelproblem.self, from:data)
                    DispatchQueue.main.sync {
                        //print(result.doktoradi)
                        //hosproblemdoc.append(result.bolum + "\n" + result.doktoradi + " " + result.doktorsoyadi + "/n" + result.hastaneadi)
                       
                        
                       
                       
                    
                        
                    }
                } else {
                    print("No data")
                }
            } catch let JsonError{
                print("fetch json error:",JsonError.localizedDescription)
            }*/
            
        }).resume()
    }
    func addrandevu(provinceA:String,cityA:String,hastaneadiA:String,doktoradiA:String,doktorsoyadsi:String,bolumaadi:String,dater:String,hourr:String,tct:String){
        guard let url: URL = URL(string: "https://www.furkansay.com/swiftui/randevuadd.php") else {
            print("invalid URL")
            return
        }
        let parameters: [String:Any] = [
            "province": provinceA,
            "city": cityA,
            "hastaneadi": hastaneadiA,
            "doktoradi": doktoradiA,
            "doktorsoyadi": doktorsoyadsi,
            "bolumadi": bolumaadi,
            "date": dater,
            "hour": hourr,
            "tc":tct
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
                self.resuls = try JSONDecoder().decode([Resadddate].self, from: data)
                for items in self.resuls {
                    print(items.sonuc)
                }
                
            } catch {
                print(error)
            }
        }).resume()
    }
    
    
}

extension String {
    func replace(string:String, replacement:String) -> String {
            return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
        }
    func removingLeadingSpaces() -> String {
        return self.replace(string: " ", replacement: "")
    }
}
struct UserInfo {
    var tc:String
    var name:String
    var surname:String
    var blood:String
    var city:String
    var doctordatecount:String
    var date:Date
    var province:String
    var district:String
    var problem:String
}


struct GetDateView_Previews: PreviewProvider {
    static var previews: some View {
        GetDateView()
    }
}
