//
//  SettingView.swift
//  CalibreMobile
//
//  Created by 顾艳华 on 2023/2/19.
//

import SwiftUI
import StoreKit

struct SettingView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        NavigationStack {
            Form{
                Section(){
                    Button{
                        #if os(iOS)
                        if let url = URL(string: "https://github.com/buhe/CalibreMobile/blob/main/Support.md") {
                            UIApplication.shared.open(url)
                        }
                        #endif
                    } label: {
                        Text("Feedback")
                    }.buttonStyle(PlainButtonStyle())
                    Button{
                        requestReview()
                    } label: {
                        Text("Rate")
                    }.buttonStyle(PlainButtonStyle())
                   
                    HStack{
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.releaseVersionNumber!)
                    }
                    HStack{
                        Text("License")
                        Spacer()
                        Text("GPLv3")
                    }
                }
                
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
