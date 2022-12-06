//
//  DropDownMenu.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 11/17/22.
//

import SwiftUI

struct DropDownMenu: View {
    var body: some View {
        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Menu {
            Button {
                // do something
            } label: {
                Text("New")
                //Image(systemName: "arrow.down.right.circle")
            }
            Button {
                // do something
            } label: {
                Text("Lightly Used")
                //Image(systemName: "arrow.up.and.down.circle")
            }
            Button {
                // do something
            } label: {
                Text("Used")
                //Image(systemName: "arrow.up.and.down.circle")
            }
        } label: {
             Image( systemName: "clock" )
             Text("Condition")
             //Image(systemName: "tag.circle")
        }
    }
}
