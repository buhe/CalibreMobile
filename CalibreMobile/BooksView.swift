//
//  BookView.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/19.
//

import SwiftUI
import SwiftUIX

struct BooksView: View {
    @State var books: [Book] = []
    @State var showCalibre = false
    @State var sorted = "time"
//    @State var searchText: String = ""
    @ObservedObject var viewModel: ViewModel
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var servers: FetchedResults<Server>
    
    @EnvironmentObject var timerWrapper: TimerWrapper
    
//    @State var network: Bool? = nil
    func loadBook() async {
        switch sorted {
        case "title":
            self.books =  await viewModel.model.sdk.listBooks(by: viewModel.model.lib ?? "")
                .sorted(by: {$0.title < $1.title})
        case "time":
            self.books =  await viewModel.model.sdk.listBooks(by: viewModel.model.lib ?? "")
                .sorted(by: {$0.timestamp < $1.timestamp})
        case "publisher":
            self.books =  await viewModel.model.sdk.listBooks(by: viewModel.model.lib ?? "")
                .sorted(by: {$0.publisher ?? "" < $1.publisher ?? ""})
        case "auther":
            self.books =  await viewModel.model.sdk.listBooks(by: viewModel.model.lib ?? "")
                .sorted(by: {$0.authors?.first ?? "" < $1.authors?.first ?? ""})
        default:
            self.books =  await viewModel.model.sdk.listBooks(by: viewModel.model.lib ?? "")
        }
        
    }
    var body: some View {
        NavigationStack {
            Picker("Sorted", selection: $sorted){
                ForEach(["title", "time", "publisher", "auther"], id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
                    ForEach(books) {
                        i in
                        BookView(viewModel: viewModel, book: i)
                    }
                    
                }
            }
            .refreshable {
                Task {
                    await loadBook()
                }
            }
            .task {
                await loadBook()
            }
            .onChange(of: viewModel.model.current) {
                s in
                Task {
                    await loadBook()
                }
                
            }
            .onChange(of: viewModel.model.lib) {
                s in
                Task {
                    await loadBook()
                }
                
            }
            .onChange(of: sorted){
                s in
                Task {
                    await loadBook()
                }
            }
            .navigationTitle("Book")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    HStack{
                        Button{showCalibre = true}label: {
                            Image(systemName: servers.filter{$0.selected}.first?.icon! ?? "plus")
                        }
                        if viewModel.model.sdk.network {
                            Image(systemName: "alarm")
                                .task {
                                    await loadBook()
                                }
                        } else {
                            Image(systemName: "alarm.waves.left.and.right")
                                .foregroundColor(.red)
                                .opacity(0.7)
                                .task {
                                    await loadBook()
                                }
                        }
                    }
                }
            }
            .sheet(isPresented: $showCalibre){
                CalibreServerView(viewModel: viewModel){
                    showCalibre = false
                }
            }
            

        }
    }
}

struct BookView: View {
    let viewModel: ViewModel
    let book: Book
    
    var body: some View {
        NavigationLink{
            BookDetailView(viewModel: viewModel, book: book)
        } label: {
            VStack {
                BookImage(viewModel: viewModel, book: book)
                .shadow(radius: 10)
                .frame(width: 120, height: 160)
                .aspectRatio(2/3, contentMode: .fit)
                Text(book.title)
                    .font(.caption)
                    .lineLimit(1)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BooksView(viewModel: ViewModel(viewContext: PersistenceController.preview.container.viewContext))
    }
}
