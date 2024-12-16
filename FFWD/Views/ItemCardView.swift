//
//  ItemCardView.swift
//  FFWD
//
//  Created by Joseph DeWeese on 12/15/24.
//

import SwiftUI
import SwiftData


struct ItemCardView: View {
    @Environment(\.modelContext) private var context
    let item: Item
    var body: some View {
        NavigationStack{
            SwipeAction(cornerRadius: 10, direction: .trailing) {
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(.ultraThinMaterial.opacity(.greatestFiniteMagnitude))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    VStack(alignment: .leading){
                        HStack{
                            ZStack {
                                
                            }
                        }
                        //MARK:  MAIN BODY OF CARD
                        HStack{
                            //MARK:  ICON
                            item.icon
                                .font(.title)
                                .padding(.leading, 5)
                                .padding(.horizontal, 10)
                                .padding(.bottom, 30)
                                .foregroundStyle(.orange)
                            VStack(alignment: .leading){
                                Text(item.title )
                                    .fontDesign(.serif)
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)
                                    .padding(.horizontal, 2)
                                    .padding(.bottom, 4.0)
                                Text(item.remarks)
                                    .fontDesign(.serif)
                                    .font(.system(size: 14))
                                    .foregroundStyle(.blue)
                                    .padding(.horizontal, 4)
                                    .padding(.bottom, 7)
                                    .lineLimit(3)
                                HStack {
                                    //MARK:  DATE CREATED DATA LINE
                                    Text("Date Created: ")
                                        .foregroundStyle(.gray)
                                        .fontDesign(.serif)
                                    Image(systemName: "calendar.badge.clock")
                                        .font(.caption)
                                        .fontDesign(.serif)
                                        .foregroundStyle(.gray)
                                    Text(item.dateAdded.formatted(.dateTime))
                                        .fontDesign(.serif)
                                        .foregroundColor(.secondary)
                                }.padding(.top, 5)
                                    .padding(.bottom, 3)
                                HStack {
                                    if let thags = item.thags {
                                        ViewThatFits {
                                            ThagStackView(thags: thags)
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                ThagStackView(thags: thags)
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
            } actions: {
                Action(tint: .red, icon: "trash", action: {
                    context.delete(item)
                    //WidgetCentrer.shared.reloadAllTimneLines
                })
            }
        }
    }
}
#Preview {
    ItemCardView(item: Item())
}
