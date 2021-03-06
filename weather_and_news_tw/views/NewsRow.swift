//
//  NewsRow.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2021/12/18.
//

import SwiftUI

struct NewsRow: View {
    let arcticle:Article
    
    
    var body: some View {
        VStack{
            
            
            if let imageUrl = arcticle.urlToImage{
                AsyncImage(url: URL(string: imageUrl)!) { image in
                    VStack{
                        image
                            .resizable()
                            .scaledToFit()
                    }
                    
                } placeholder: {
                    //Color.purple.opacity(0.1)
                    Image(systemName: "newspaper").resizable().padding()
                }.frame(width:300,height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                .clipped()
            }
            if let tempStr = arcticle.lTitle{
                Text(tempStr.components(separatedBy: "-").dropLast().joined(separator: "-")+"\n").font(.title2).foregroundColor(.black).lineLimit(2)
            }else{
                Text(arcticle.title.components(separatedBy: "-").dropLast().joined(separator: "-")+"\n").font(.title2).foregroundColor(.black).lineLimit(2)
            }
            
            
        }.frame(width:((UIScreen.screenWidth<400) ? (UIScreen.screenWidth*0.9): 400)).padding().background(Color(red: 224.0/255, green: 224.0/255, blue: 235.0/255)).clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

//struct NewsRow_Previews: PreviewProvider {
//    static var previews: some View {
//        NewsRow()
//    }
//}
