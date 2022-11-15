//
//  Spotlight.swift
//  SUIsample
//
//  Created by kook on 2022/10/05.
//

import SwiftUI

extension View {
    // MARK: New Modifier For Adding Elements for Spotlight Preview
    @ViewBuilder
    func addSpotlight(_ id: Int, shape: SpotlightShape = .rectangle,
                      roundedRadius: CGFloat = 0, text: String = "") -> some View {
        self
        // MARK: Using Anchor Preference For Retreiving View's Bounds Region
            .anchorPreference(key: BoundsKey.self, value: .bounds) {
                [id: BoundsKeyProperties(shape: shape, anchor: $0, text: text, radius: roundedRadius )]
            }
    }
    
    // MARK: Modifier to Displaying Spotlight Content
    // NOTE: Add to Root View
    @ViewBuilder
    func addSpotlightOverlay(show: Binding<Bool>, currentSpot: Binding<Int>) -> some View {
        self
            .overlayPreferenceValue(BoundsKey.self) { values in
                GeometryReader { proxy in
                    if let preference = values.first(where: { item in
                        item.key == currentSpot.wrappedValue
                    }) {
                        let screenSize = proxy.size
                        let anchor = proxy[preference.value.anchor]
                        
                        // MARK: Spotlight View
                        // SpotlightHelperView(screenSize: screenSize, rect: anchor)
                    }
                }
                .ignoresSafeArea()
                .animation(.easeInOut, value: show.wrappedValue)
                .animation(.easeInOut, value: currentSpot.wrappedValue)
            }
    }
    
    // MARK: Helper View
    @ViewBuilder
    func SpotlightHelperView(screenSize: CGSize, rect: CGRect,
                             show: Binding<Bool>, currentSpot: Binding<Int>,
                             properties: BoundsKeyProperties) -> some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .environment(\.colorScheme, .dark)
            .opacity(show.wrappedValue ? 1 : 0)
            // MARK: Spotlight Text
            .overlay(content: {
                Text(properties.text)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    // MARK: Extracting Text Size
                    .opacity(0)
                    .overlay(alignment: .topLeading) {
                        GeometryReader { proxy in
                            let textSize = proxy.size
                            
                            Text(properties.text)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .offset(x: rect.minX, y: rect.maxY)
                        }
                    }
            })
            // MARK: Reverse Masking the Current Spot
            // By Doing this, The Currently Spotlighted View will be Looking like Highlighted
            .mask {
                Rectangle()
                    .overlay(alignment: .topLeading) {
                        let radius = properties.shape == .circle ? (rect.width / 2) : (properties.shape == .rectangle ? 0 : properties.radius)
                        RoundedRectangle(cornerRadius: radius, style: .continuous)
                            .frame(width: rect.width, height: rect.height)
                            .offset(x: rect.minX, y: rect.minY)
                            .blendMode(.destinationOut)
                    }
            }
        
    }
}

// MARK: Spotlight Shape
enum SpotlightShape {
    case circle, rectangle, rounded
}

// MARK: Bounds Preference Key
struct BoundsKey: PreferenceKey {
    static var defaultValue: [Int: BoundsKeyProperties] = [:]
    
    static func reduce(value: inout [Int : BoundsKeyProperties], nextValue: () -> [Int : BoundsKeyProperties]) {
        value.merge(nextValue()) { $1 }
    }
    
    
}

// MARK: Bounds Preference Key Properties
struct BoundsKeyProperties {
    var shape: SpotlightShape
    var anchor: Anchor<CGRect>
    var text: String = ""
    var radius: CGFloat = 0
}
