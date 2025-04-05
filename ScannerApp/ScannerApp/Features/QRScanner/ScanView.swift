import SwiftUI
import ComposableArchitecture
import PhotosUI

struct ScanView: View {
    let store: StoreOf<ScanFeature>
    
    @EnvironmentObject var shake: ShakeMotionNotifier
    @StateObject private var camera = CameraService()
    @State private var isGalleryPresented = false
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                VStack(spacing: 0) {
                    CameraPreviewView(session: camera.session) { layer in
                        camera.previewLayer = layer
                    }.ignoresSafeArea()
                    
                    HStack(spacing: 40) {
                        Button {
                            isGalleryPresented = true
                        } label: {
                            VStack {
                                Image(systemName: "eye.fill")
                                    .foregroundStyle(.white)
                                    .frame(width: 24, height: 24)
                                Text("Gallery")
                                    .customText(size: 12)
                            }
                        }
                        
                        Divider()
                            .frame(width: 1, height: 36)
                            .background(Color.white)
                            .opacity(0.8)
                        
                        Button {
                            camera.toggleTorch()
                        } label: {
                            VStack {
                                Image(systemName: "flashlight.on.fill")
                                    .foregroundStyle(.white)
                                    .frame(width: 24, height: 24)
                                Text("Flashlight")
                                    .customText(size: 12)
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }
                
                ViewfinderOverlay()
            }
            .photosPicker(isPresented: $isGalleryPresented, selection: $selectedItem)
            .onChange(of: selectedItem) { newItem in
                guard let item = newItem else { return }
                Task {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        viewStore.send(.scanImage(image))
                    }
                }
            }
            .onReceive(shake.$didShake) { didShake in
                guard didShake else { return }
                viewStore.send(.scanned("8TZLxqVmNf3p9zAYnbtQgXpABC123XYZ"))
                shake.didShake = false
            }
            .onReceive(camera.$scannedCode.compactMap { $0 }) { code in
                viewStore.send(.scanned(code))
                camera.scannedCode = nil
            }
            .sheet(isPresented: viewStore.binding(
                get: \ .showAlert,
                send: .alertDismissed
            )) {
                VStack(spacing: 16) {
                    Text("This address is outside of Alien App")
                        .customText(size: 24)
                    Text("We don’t know who is the owner. Please, make sure that address is correct and proceed with caution")
                        .customText(color: .gray)
                    
                    CopyAddressView(address: viewStore.scannedAddress ?? "", needsCopy: false) { }
                    
                    Button {
                        viewStore.send(.alertDismissed)
                        viewStore.send(.updateCamera(true))
                    } label: {
                        Text("I understand").customButton()
                    }
                    
                    Button("Close") {
                        viewStore.send(.alertDismissed)
                        viewStore.send(.updateCamera(true))
                    }
                }
                .padding(.horizontal, 8)
                .presentationDragIndicator(.visible)
                .presentationDetents([.medium])
                .onAppear {
                    viewStore.send(.updateCamera(false))
                }
            }
            .task {
                if viewStore.isCameraActive && !camera.session.isRunning {
                    camera.startSessionIfNeeded()
                } else if !viewStore.isCameraActive && camera.session.isRunning {
                    camera.stopSessionIfNeeded()
                }
            }
        }
    }
}
