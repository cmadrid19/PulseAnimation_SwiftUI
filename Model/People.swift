//
//  People.swift
//  PulseAnimation
//
//  Created by Maxim Macari on 13/4/21.
//

import SwiftUI

struct People: Identifiable {
    var id = UUID().uuidString
    var image: String
    var name: String
    //offset will be eused to show user's pic in pulse animation
    var offset: CGSize = CGSize(width: 0, height: 0)
}

var peoples = [
    People(image: "pi1", name: "Alexander Carrillo"),
    People(image: "pic2", name: "Ane Arnau"),
    People(image: "pic3", name: "Emilio Exposito"),
    People(image: "pic4", name: "Ian Torrejon"),
    People(image: "pic5", name: "Juan Manuel Ruano"),
    People(image: "pic6", name: "Jose Miguel")
]
