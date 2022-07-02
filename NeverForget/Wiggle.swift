//
//  Wiggle.swift
//  NeverForget
//
//  Created by Carson Gross on 7/2/22.
//

//Link to animation:
//https://gist.github.com/markmals/075273b58a94db20917235fdd5cda3cc
import SwiftUI

extension View {
    func wiggling() -> some View {
        modifier(WiggleModifier())
    }
}

struct WiggleModifier: ViewModifier {
    @State private var isWiggling = false
    
    private static func randomize(interval: TimeInterval, withVariance variance: Double) -> TimeInterval {
        let random = (Double(arc4random_uniform(1000)) - 500.0) / 500.0
        return interval + variance * random
    }
    
    private let rotateAnimation = Animation
        .easeInOut(
            duration: WiggleModifier.randomize(
                interval: 0.11,
                withVariance: 0.025
            )
        )
        .repeatForever(autoreverses: true)
    
    private let bounceAnimation = Animation
        .easeInOut(
            duration: WiggleModifier.randomize(
                interval: 0.12,
                withVariance: 0.025
            )
        )
        .repeatForever(autoreverses: true)
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(isWiggling ? 2.0 : 0))
            .animation(rotateAnimation, value: isWiggling)
            .offset(x: 0, y: isWiggling ? 2.0 : 0)
            .animation(bounceAnimation, value: isWiggling)
            .onAppear() { isWiggling.toggle() }
    }
}
