//
//  ContentView.swift
//  TestDrag
//
//  Created by Alan on 4/27/24.
//

//
//  ContentView.swift
//  LookingGlass
//
//  Created by Alan on 9/27/22.
//

import SwiftUI
import SceneKit

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var hSizeClass
    @Environment(\.verticalSizeClass) var vSizeClass
    
    @State private var isPortrait = false
    
    @GestureState private var dragState = DragState.inactive
    @State private var viewHeight: CGFloat = 100
    
    var body: some View {
        let container1Layout = (vSizeClass == .compact) ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
        let panelFrameHeight = (vSizeClass == .compact) ? .infinity : 233
        let panelFrameWidth = (vSizeClass == .compact) ? 233: .infinity
        
        
        GeometryReader { geometry in
            ZStack {
                container1Layout {
                    Spacer()
                    ControlPanelView()
                        .frame(maxWidth: panelFrameWidth, maxHeight: panelFrameHeight)
                }
                
                // Draggable ICMSView
                container1Layout {
                    ICMSView()
                        .background(Color.white.opacity(0.6))
                        .cornerRadius(10)
                        .frame(width: (vSizeClass == .compact ? viewHeight : geometry.size.width),
                               height: (vSizeClass == .compact) ? geometry.size.height : viewHeight)
                        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.blue/*@END_MENU_TOKEN@*/)
                    Spacer()
                    }
                
                    
                container1Layout {
                        Spacer()
                        .frame(width: (vSizeClass == .compact ? (viewHeight - 40) : geometry.size.width),
                               height: (vSizeClass == .compact) ? geometry.size.height : (viewHeight - 60) )
                        
                        HandleBar()
                        .frame(width: (vSizeClass == .compact ? 30 : 80),  height: (vSizeClass == .compact ? 80 : 30))
                            .background(Color.gray.opacity(0.2))
                            .gesture(DragGesture()
                                .onChanged { gesture in
                                    let newHeight = viewHeight + ((vSizeClass == .compact) ? gesture.translation.width: gesture.translation.height)
                                    let theHeightLimit = (vSizeClass == .compact ? geometry.size.width : geometry.size.height)
                                    let theRange: ClosedRange = (theHeightLimit-(233+8)...theHeightLimit)
                                    viewHeight = newHeight.clamped(to: theRange)// Ensure the panel isn't too small or too large
                                }
                            )
                        Spacer()
                        
                }
               
                }
                .onAppear() {
                    viewHeight = geometry.size.height
                }
            }
            .ignoresSafeArea( edges: .all)

            .background(Image("WoodBackground_v")
                .resizable()
                .ignoresSafeArea( edges: .all))
        }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }

}

extension CGFloat {
    func clamped(to limits: ClosedRange <CGFloat>) -> CGFloat {
        if (self < limits.lowerBound) {
            return limits.lowerBound
        } else if (limits.upperBound < self) {
            return limits.upperBound
        }
        return self
    }
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)
}

struct HandleBar: View {
    @Environment(\.verticalSizeClass) var vSizeClass

    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: (vSizeClass == .compact ? 5 : 80), height: (vSizeClass == .compact ? 80 : 5))
            .foregroundColor(.gray)
    }
}

struct ICMSView: View {
    var scene = SCNScene(named: "PA-Main.scn", inDirectory: "SceneKitAssetCatalog.scnassets", options: nil)
    var cameraNode: SCNNode? {
        scene?.rootNode.childNode(withName: "camera", recursively: false)
    }

    var body: some View {
        SceneView(
            scene: scene,
            pointOfView: cameraNode,
            options: []
        )
    }
}

struct ControlPanelView: View {
    var body: some View {
        Text("Don't Panic")
    }
}
