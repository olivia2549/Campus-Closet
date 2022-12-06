//
//  SustainabilityImpact.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 11/19/22.
//

import SwiftUI

struct SustainabilityImpact: View {
    var body: some View {
        var SustainabilityMessages:[String] = ["Did you know that the fashion industry is responsible for 10 % of global carbon emissions! By buying secondhand, you are helping the environment!","Did you know that in 2015, more than 21 billion pounds of clothing went to landfills? Thanks for preventing one more!", "Did you know that extending the average life of clothes by three months of active use gives a 5 - 10 % reduction in each item’s carbon, water and waste footprints?", "Fast Fashion is expected to grow by 20% over the next 10 years, in comparison to second-hand fashion which is expected to grow by 185%. You made the right choice!", "If everyone bought one used item instead of new this year, we would save 5.7B of CO2 emissions. Thanks for making a small step towards a better Earth."]

        
        ZStack {
            
            Color.black.opacity(0.35).edgesIgnoringSafeArea(.all)
            let randomInt = Int.random(in: 0..<5)
            VStack(alignment: .center, spacing: 0) {
               
                
                HStack{
                    Text("Thanks for your purchase!")
                    Image(systemName: "globe.americas.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25)
                }.frame(maxWidth: .infinity)
                    .frame(height: 50, alignment: .center)
                    .font(Font.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .background(Color.black.opacity(0.15))
                    .border(.white, width: 3)
                Text(SustainabilityMessages[randomInt])
                    .multilineTextAlignment(.center)
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 15, trailing: 20))
                    .font(Font.system(size: 19, weight: .semibold))
                    .foregroundColor(.white)
                    .background(Styles().themePink)
                
                    
                
            }
            .frame(maxWidth: 320)
            .background(Styles().themePink)
            .border(.white, width: 3)
        }
    }
    
    struct SustainabilityImpact_Previews: PreviewProvider {
        static var previews: some View {
            SustainabilityImpact()
        }
    }
}
