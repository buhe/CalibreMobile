//
//  BookView.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/19.
//

import SwiftUI

struct BooksView: View {
    @State var books: [Book] = []
    @State var showCalibre = false
    @ObservedObject var viewModel: ViewModel
//    @State var network = true
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var servers: FetchedResults<Server>
    
    @EnvironmentObject var timerWrapper: TimerWrapper
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
                    ForEach(books) {
                        i in
                        BookView(viewModel: viewModel, book: i)
                    }
                    
                }
            }
            .task {
                self.books =  await viewModel.model.sdk.listBooks(by: viewModel.model.lib ?? "")
            }
            .onChange(of: viewModel.model.current) {
                s in
                Task {
                    self.books =  await viewModel.model.sdk.listBooks(by: viewModel.model.lib ?? "")
                }
                
            }
            .onChange(of: viewModel.model.lib) {
                s in
                Task {
                    self.books =  await viewModel.model.sdk.listBooks(by: viewModel.model.lib ?? "")
                }
                
            }
            .navigationTitle("Book")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    HStack{
                        Button{showCalibre = true}label: {
                            Image(systemName: servers.filter{$0.selected}.first?.icon! ?? "0.circle")
                        }
                        if viewModel.model.sdk.network {
                            Image(systemName: "alarm")
                        } else {
                            Image(systemName: "alarm.waves.left.and.right")
                                .foregroundColor(.red)
                                .opacity(0.7)
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
