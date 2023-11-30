//
//  Depricated.swift
//  CaloriesTracker
//
//  Created by Tenzin Norden on 11/29/23.
//

//import Foundation

//struct Sheet: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query var items: [Item]
//    @Query var days: [Day]
//    @Binding var presentSheet: Bool
//    @Binding var selectedDay: Day
//    var sheetSelection: Meals
//
//    var body: some View {
//        NavigationStack {
//            VStack(alignment: .leading) {
//                Button(action: {
//                    presentSheet = false
//                }, label: {
//                        HStack(spacing: 5) {
//                            Image(systemName: "chevron.left")
//                            Text("back")
//                        }
//                            .font(.system(size: 12))
//                    })
//                    .buttonStyle(.plain)
//                    .padding(.top, 10)
//                    .padding(.leading, 10)
//                HStack {
//                    Text("Items")
//                        .fontWeight(.bold)
//                        .padding(.top, 15)
//                        .padding(.leading, 15)
//                    Spacer()
//                    NavigationLink(destination: SheetForm(itemName: "", itemDesc: "", calories: Decimal(0), protien: Decimal(0), carbs: Decimal(0), fat: Decimal(0))) {
//                        Image(systemName: "plus")
//                            .font(.system(size: 20, weight: .bold))
//                            .padding(.top, 15)
//                            .padding(.trailing, 15)
//                    }
//                        .buttonStyle(.plain)
//                }
//                if items.isEmpty {
//                    Spacer()
//                    HStack {
//                        Spacer()
//                        Text("no items yet")
//                            .foregroundStyle(Color.secondary)
//                        Spacer()
//                    }
//                    Spacer()
//                } else {
//                    List {
//                        ForEach(items) { item in
//                            Button(action: {
//                                presentSheet = false
//                                withAnimation {
//                                    switch(sheetSelection) {
//                                    case .breakfast:
//                                        selectedDay.breakfast.append(item)
//                                        print(selectedDay.breakfast)
//                                    case .lunch:
//                                        selectedDay.lunch.append(item)
//                                        print(selectedDay.lunch)
//                                    case .dinner:
//                                        selectedDay.dinner.append(item)
//                                        print(selectedDay.dinner)
//                                    case .snack:
//                                        selectedDay.snack.append(item)
//                                        print(selectedDay.snack)
//                                    }
//                                }
//                            }, label: {
//                                    SheetItem(item: item)
//                                })
//                                .listRowSeparator(.hidden)
//                                .listRowInsets(EdgeInsets(.init(top: 30, leading: 20, bottom: 30, trailing: 20)))
//                                .swipeActions(allowsFullSwipe: false) {
//                                Button(role: .destructive, action: {
//                                    for day in days {
//                                        if let index = day.breakfast.firstIndex(of: item) {
//                                            day.breakfast.remove(at: index)
//                                        }
//                                        if let index = day.lunch.firstIndex(of: item) {
//                                            day.lunch.remove(at: index)
//                                        }
//                                        if let index = day.dinner.firstIndex(of: item) {
//                                            day.dinner.remove(at: index)
//                                        }
//                                    }
//                                    modelContext.delete(item)
//                                }, label: {
//                                        Image(systemName: "trash")
//                                    })
//                                NavigationLink(destination: SheetForm(itemName: item.name, itemDesc: item.desc, calories: Decimal(item.calories), protien: Decimal(item.protien), carbs: Decimal(item.carbs), fat: Decimal(item.fat), isEditing: true, item: item)) {
//                                    Image(systemName: "applepencil")
//                                }
//                                    .tint(.blue)
//                            }
//                        }
//                    }
//                        .listStyle(.plain)
//                }
//                Spacer()
//            }
//        }
//    }
//struct CardDescriptionAddButton: View {
//    var body: some View {
//        HStack {
//            VStack (alignment: .leading) {
//                Text("add +")
//                    .fontWeight(.bold)
//                Text("Item Desc")
//                    .font(.system(size: 12))
//                    .foregroundStyle(Color.clear)
//            }
//            Spacer()
//        }
//    }
//}
//}
