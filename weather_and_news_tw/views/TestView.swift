//
//  TestView.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2022/1/14.
//

import SwiftUI

struct TestView: View {
    var str:String
    var body: some View {
        Text(str)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView(str: "HHHH")
    }
}
