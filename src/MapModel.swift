import Foundation
import ArcGIS
import SwiftUI

final class MapModel: ObservableObject {
    // Public layer endpoint (no token needed).
    private let parcelURL = URL(string: "https://services2.arcgis.com/VqPd1Ybcc46AvijK/arcgis/rest/services/Parcels_Service121324/FeatureServer/0")!

    let map: Map
    let startViewpoint: Viewpoint
    private let featureLayer: FeatureLayer
    private let featureTable: ServiceFeatureTable

    @Published var selectedParcel: Parcel?
    @Published var parcelQuery: String = ""

    init() {
        map = Map(basemapStyle: .arcGISImagery)
        featureLayer = FeatureLayer(url: parcelURL)
        featureTable = ServiceFeatureTable(url: parcelURL)

        // Center on Shelby County, IL (approximate Web Mercator point).
        startViewpoint = Viewpoint(center: Point(x: -9485600, y: 4607000, spatialReference: .webMercator()), scale: 20_000)

        map.addOperationalLayer(featureLayer)
    }

    func identify(on mapView: MapViewProxy, at screenPoint: CGPoint) {
        Task {
            do {
                let result = try await mapView.identify(
                    layer: featureLayer,
                    screenPoint: screenPoint,
                    tolerance: 12,
                    maximumResults: 1,
                    returnPopupsOnly: false
                )

                if let feature = result.geoElements.first as? ArcGISFeature {
                    await MainActor.run {
                        selectedParcel = Parcel(from: feature)
                    }
                }
            } catch {
                // In a production app, present a user-visible error instead of printing.
                print("Identify failed: \(error.localizedDescription)")
            }
        }
    }

    func searchParcel() {
        let trimmed = parcelQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let params = QueryParameters()
        params.whereClause = "PARCEL_ID = '\(escapeSingleQuotes(trimmed))'"
        params.outFields = ["Name", "PARCEL_ID"]
        params.maxFeatures = 1

        Task {
            do {
                let result = try await featureTable.queryFeatures(using: params)
                var iterator = result.makeIterator()
                if let feature = iterator.next() as? ArcGISFeature {
                    await MainActor.run {
                        selectedParcel = Parcel(from: feature)
                    }
                } else {
                    await MainActor.run {
                        selectedParcel = Parcel(owner: "Not found", parcelID: trimmed)
                    }
                }
            } catch {
                print("Query failed: \(error.localizedDescription)")
            }
        }
    }

    private func escapeSingleQuotes(_ value: String) -> String {
        value.replacingOccurrences(of: "'", with: "''")
    }
}
