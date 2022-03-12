//
//  MainView.swift
//  SwiftUICoreDataSpandingTracker
//
//  Created by Ryan on 3/9/22.
//

import SwiftUI

struct MainView: View {
    
    @State private var shouldPresentAddCardForm = false
    @State private var shouldShowAddTransationForm = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp, ascending: false)],
        animation: .default)
    private var cards: FetchedResults<Card>
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                if !cards.isEmpty {
                    TabView {
                        ForEach(cards) { card in
                            CreditCardView(card: card)
                                .padding(.bottom, 50)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: 280)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    
                    Text("Get started by adding your first transaction")
                    Button {
                        shouldShowAddTransationForm.toggle()
                    } label: {
                        Text("+Transation")
                            .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
                            .background(Color(.label))
                            .foregroundColor(Color(.systemBackground))
                            .font(.headline)
                            .cornerRadius(5)
                    }
                    .fullScreenCover(isPresented: $shouldShowAddTransationForm) {
                        AddTransationForm()
                    }
                    
                } else {
                    
                    emptyPromptMessage                }
                
                Spacer()
                
                    .fullScreenCover(isPresented: $shouldPresentAddCardForm, onDismiss: nil) {
                        AddCardForm()
                    }
            }
            .navigationTitle("Credit Cards")
            .navigationBarItems(leading: HStack {
                addItemButton
                deletAllButton
                
            }, trailing: addCardButton)
        }
    }
    
    private var emptyPromptMessage: some View {
        LazyVStack {
            Text("You currently have no cards in the system")
                .padding(.horizontal, 48)
                .padding(.vertical)
                .multilineTextAlignment(.center)
            Button {
                shouldPresentAddCardForm.toggle()
            } label: {
                Text("+ Add Your First Card")
                    .foregroundColor(Color(.systemBackground))
            }
            .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
            .background(Color(.label))
            .cornerRadius(5)
            
        }.font(.system(size: 22, weight: .semibold))
    }
    
    private var deletAllButton: some View {
        Button {
            cards.forEach {card in
                viewContext.delete(card)
            }
            
            do {
                try viewContext.save()
            } catch {
                
            }
            
        } label: {
            Text("Delete All")
        }
    }
    
    var addItemButton: some View {
        Button(action:  {
            withAnimation {
                let viewContext = PersistenceController.shared.container.viewContext
                let card = Card(context: viewContext)
                card.timestamp = Date()
                
                do {
                    try viewContext.save()
                } catch {
                    
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }, label: {
            Text("Add Item")
        })
        
    }
    
    struct CreditCardView: View {
        
        let card : Card
        
        @State private var shouldShowActionSheet = false
        @State private var shouldShowEditForm = false
        
        @State var refreshId = UUID() //Magic...
        
        private func handleDelete() {
            let viewContext = PersistenceController.shared.self.container.viewContext
            viewContext.delete(card)
            
            do {
                try viewContext.save()
            } catch {
                // error
            }
        }
        
        var body: some View {
            LazyVStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(card.name ?? "")
                        .font(.system(size: 24, weight: .semibold))
                    Spacer()
                    Button {
                        shouldShowActionSheet.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 28, weight: .bold, design: .default))
                    }
                    
                    .actionSheet(isPresented: $shouldShowActionSheet) {
                        .init(title: Text(self.card.name ?? ""), message: Text(""), buttons: [
                            .default(Text("Edit"), action: {
                                shouldShowEditForm.toggle()
                            }),
                            .default(Text("Delete Card"), action: handleDelete),
                            .cancel()])
                    }
                    
                }
                LazyHStack {
                    Image("visa")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 44)
                        .clipped()
                    Spacer()
                    Text("Balance : $5,000")
                        .font(.system(size: 18, weight: .semibold))
                }
                
                
                Text(card.number ?? "")
                
                Text("Credit Limit: $\(card.limit)")
                
                LazyHStack { Spacer()}
            }
            .foregroundColor(.white)
            .padding()
            .background(
                VStack {
                    
                    if let colorData = card.color,
                       let uiColor = UIColor.color(data: colorData),
                       let actualColor = Color(uiColor) {
                        LinearGradient(colors: [actualColor.opacity(0.6), actualColor], startPoint: .top, endPoint: .bottom)
                    } else {
                        Color.cyan
                    }
                    
                }
            )
            .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(.black.opacity(0.5), lineWidth: 1)
            )
            .cornerRadius(8)
            .shadow(radius: 5)
            .padding(.horizontal)
            .padding(.top, 8)
            
            .fullScreenCover(isPresented: $shouldShowEditForm) {
                AddCardForm(card: self.card)
            }
        }
    }
    
    var addCardButton: some View {
        Button(action: {
            shouldPresentAddCardForm.toggle()
            
        }, label: {
            Text("+ Card")
                .font(.system(size: 16, weight: .bold))
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                .background(Color.black)
                .cornerRadius(5)
                .foregroundColor(.white)
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext
        MainView()
            .environment(\.managedObjectContext, viewContext)
        //        addCardForm()
    }
}
