//
//  NewServerView.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/20.
//

import SwiftUI

struct NewServerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let firstServer: Bool
    let viewModel: ViewModel
    let close: (_ c: String) -> Void
    @State var name = ""
    @State var icon = "a.circle"
    @State var host = ""
    @State var port = ""
    @State var showErrorMessage = false
    @State var errorMessage = ""
    
    var body: some View {
        Form {
            TextField("Calibre Server Name", text: $name)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
       
            Picker("Calibre Server Icon", selection: $icon){
                ForEach(["a.circle", "b.circle", "c.circle", "e.circle", "f.circle", "g.circle", "h.circle", "i.circle", "j.circle", "k.circle", "l.circle", "m.circle", "n.circle", "o.circle", "p.circle", "q.circle", "r.circle", "s.circle", "t.circle", "u.circle", "v.circle", "w.circle", "x.circle", "y.circle"], id: \.self) {
                    Image(systemName: $0)
                }
                
            }
            TextField("Calibre Server Host", text: $host)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)

            TextField("Calibre Server Port", text: $port)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
            Section {
                Button{
                    // save to core data
                    addItem()
                    
                } label: {
                    Text("Save")
                }
            }
            
            Section {
                Button{
                    if check() {
                        do {
                            try ping(host: host, port: port)
                            errorMessage = "Server status is OK."
                        } catch {
                            errorMessage = "Server status is down."
                        }
                    }
                    showErrorMessage = true
                } label: {
                    Text("Test")
                }
            }
        }
        .alert(errorMessage, isPresented: $showErrorMessage){
            Button("OK", role: .cancel) {
                showErrorMessage = false
            }
        }
    }
    private func check() -> Bool {
        if name.isEmpty {
            showErrorMessage = true
            errorMessage = "Input calibre server name, please."
            return false
        }
        if host.isEmpty {
            showErrorMessage = true
            errorMessage = "Import calibre host, please."
            return false
        }
        if port.isEmpty {
            showErrorMessage = true
            errorMessage = "Import calibre port, please."
            return false
        }
        return true
    }
    private func addItem() {

        if check() {
            let newItem = Server(context: viewContext)
            newItem.name = name
            newItem.icon = icon
            newItem.host = host
            newItem.port = port
            if firstServer {
                newItem.selected = true
            }
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            close(newItem.name!)
        }
        
    }
    
    func ping(host: String, port: String) throws {
        var e: Any? = nil
        let semaphore = DispatchSemaphore(value: 0)
        let url = URL(string: "http://\(host):\(port)/interface-data/update")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            e = error
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        if e != nil {
            throw PingError()
        }
    }
    
}
//
//struct NewServerView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewServerView(firstServer: true){}
//    }
//}
