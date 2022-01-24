//
//  CollectionView.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2022/1/12.
//

import SwiftUI

struct CollectionView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SavedNews.saveTime, ascending: false)],
        animation: .default)
    private var savedNews: FetchedResults<SavedNews>
    @State var filteredNews = [SavedNews]()
    @State var searchword:String = ""
    @State private var animateGradient = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchword.isEmpty ? savedNews.filter{
                    $0.title == $0.title
                } : savedNews.filter { $0.title!.contains(searchword)}) { news in
                    NavigationLink {
//                        Text("標題 \(news.title!) ")
                        WebView(urlStr: news.url!).navigationTitle(news.title!)
                    } label: {
//                        Text(news.saveTime!, formatter: itemFormatter)
                        Text(news.title!)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
            }.navigationTitle("收藏的新聞")
            LinearGradient(colors: [.blue, .yellow], startPoint: animateGradient ? .topLeading : .bottomLeading, endPoint: animateGradient ? .bottomTrailing : .topTrailing).overlay(content: {
                Text("請選擇新聞")
            })
            .ignoresSafeArea().onAppear {
                withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
            
        }.searchable(text: $searchword, placement: .navigationBarDrawer(displayMode: .always))
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { savedNews[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}


private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
