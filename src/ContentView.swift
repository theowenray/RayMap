import SwiftUI
import ArcGIS

struct ContentView: View {
    @StateObject private var model = MapModel()

    var body: some View {
        MapViewReader { proxy in
            MapView(map: model.map, viewpoint: model.startViewpoint)
                .onSingleTapGesture { screenPoint, _ in
                    model.identify(on: proxy.mapView, at: screenPoint)
                }
                .ignoresSafeArea()
        }
        .overlay(alignment: .top) {
            SearchBar(text: $model.parcelQuery, onSubmit: model.searchParcel)
                .padding()
        }
        .sheet(item: $model.selectedParcel) { parcel in
            ParcelDetailSheet(parcel: parcel)
        }
    }
}
