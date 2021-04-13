//
//  Home.swift
//  PulseAnimation
//
//  Created by Maxim Macari on 13/4/21.
//

import SwiftUI

struct Home: View {
    
    @State var startAnimation = false
    
    @State var pulse1 = false
    @State var pulse2 = false
    
    //found ppl, max = 5, remaining will show in the bottomSheet
    @State var foundPeople: [People] = []
    
    @State var finishAnimation = false
    
    var body: some View {
        VStack{
            
            //Nav bar
            HStack(spacing: 10){
                Button(action: {
                    
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.black)
                })
                
                Text(finishAnimation ? "\(peoples.count) found" : "NearBy Search")
                    .font(.title2)
                    .fontWeight(.bold)
                    .animation(.none)
                
                Spacer()
                
                Button(action: {
                    verifyAndAddPeople()
                }, label: {
                   //showing refresh button if finish animation toggled
                    if finishAnimation {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.black)
                    }else{
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.black)
                    }
                })
                .animation(.none)
            }
            .padding()
            .padding(.top, getSafeArea().top)
            .background(Color.white)
            
            ZStack{
                
                Circle()
                    .stroke(Color.gray.opacity(0.6))
                    .frame(width: 130, height: 130)
                    .scaleEffect(pulse1 ? 3.3 : 0)
                    .opacity(pulse1 ? 0 : 1)
                
                Circle()
                    .stroke(Color.gray.opacity(0.6))
                    .frame(width: 130, height: 130)
                    .scaleEffect(pulse2 ? 3.3 : 0)
                    .opacity(pulse2 ? 0 : 1)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 130, height: 130)
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: 5, y: 5)
                
                Circle()
                    .stroke(Color.blue, lineWidth: 1.4)
                    .frame(width: finishAnimation ? 70 : 30, height:finishAnimation ? 70 : 30)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                            .opacity(finishAnimation ? 1 : 0)
                    )
                
                ZStack{
                    ZStack{
                        Circle()
                            .trim(from: 0, to: 0.4)
                            .stroke(Color.blue, lineWidth: 1.4)
                        
                        Circle()
                            .trim(from: 0, to: 0.4)
                            .stroke(Color.blue, lineWidth: 1.4)
                            .rotationEffect(.init(degrees: -180))
                    }
                }
                .frame(width: 70, height: 70)
                .rotationEffect(.init(degrees: startAnimation ? 360 : 0))
                
                //showing found people
                ForEach(foundPeople){ people in
                    
                    
                    Image("\(people.image)")
                        .resizable()
                        .foregroundColor(Color.random)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding(4)
                        .background(Color.white.opacity(0.15).clipShape(Circle()))
                        .offset(people.offset)
                    
                }
            }
            .frame(maxHeight: .infinity)
            
            if finishAnimation {
                //Bottom sheet
                VStack {
                    //pull up indicator
                    Capsule()
                        .fill(Color.gray.opacity(0.7))
                        .frame(width: 50, height: 4)
                        .padding(.vertical, 10)
                    
                    ScrollView(.horizontal, showsIndicators: false, content: {
                        HStack(spacing: 15){
                            ForEach(peoples){ people in
                                VStack(spacing: 15){
                                    Image(people.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                    
                                    Text("\(people.name)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Button(action: {}, label: {
                                        Text("Choose")
                                            .fontWeight(.semibold)
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 40)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    })
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding()
                        .padding(.bottom, getSafeArea().bottom)
                    })
                }
                .background(Color.white)
                .cornerRadius(25)
                //Bottom slide
                .transition(.move(edge: Edge.bottom))
            }
            
        }
        .ignoresSafeArea()
        .background(Color.blue.opacity(0.05).ignoresSafeArea())
        .onAppear(){
            animateView()
        }
    }
    
    func animateView(){
        withAnimation(Animation.linear(duration: 1.7).repeatForever(autoreverses: false)){
            startAnimation.toggle()
        }
        
        //it will start neext round 0.1 earlier
        withAnimation(Animation.linear(duration: 1.7).delay(-0.1).repeatForever(autoreverses: false)){
            pulse1.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(Animation.linear(duration: 1.7).delay(-0.1).repeatForever(autoreverses: false)){
                pulse2.toggle()
            }
        }
    }
    
    func verifyAndAddPeople(){
        if foundPeople.count < 5 {
            //adding ppl
            withAnimation{
                var people = peoples[foundPeople.count]
                people.offset = CGSize.random
                foundPeople.append(people)
            }
           
        } else {
            withAnimation(Animation.linear(duration: 0.6)){
                finishAnimation.toggle()
                
                startAnimation = false
                pulse1 = false
                pulse2 = false
            }
            
            //Cheking if animation finished
            if !finishAnimation {
                withAnimation{
                    foundPeople.removeAll()
                    animateView()
                }
            }
            
        }
    }
}

//extending view to get safearea and screensize
extension View {
    func getSafeArea() -> UIEdgeInsets {
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func getRect() -> CGRect {
        UIScreen.main.bounds
    }
}


extension Color {
    static var random: Color {
        return Color(red: Double.random(in: 0...1),
                     green: Double.random(in: 0...1),
                     blue: Double.random(in: 0...1))
    }
}

//random offset
extension CGSize {
    static var random: CGSize {
        return CGSize(width: CGFloat.random(in: -130...120),
                      height: CGFloat.random(in: -130...120))
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
