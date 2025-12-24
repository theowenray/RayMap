import Foundation
import ArcGIS
import SwiftUI

struct Parcel: Identifiable {
    let id = UUID()
    let owner: String?
    let parcelID: String?
    let address: String?

    init(owner: String?, parcelID: String?, address: String? = nil) {
        self.owner = owner
        self.parcelID = parcelID
        self.address = address
    }

    init(from feature: ArcGISFeature) {
        let attributes = feature.attributes
        owner = attributes["Name"] as? String
        parcelID = attributes["PARCEL_ID"] as? String
        address = attributes["Address1"] as? String
    }
}

struct ParcelDetailSheet: View {
    let parcel: Parcel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(parcel.owner ?? "Unknown owner")
                .font(.title3.weight(.semibold))
            if let parcelID = parcel.parcelID {
                Label(parcelID, systemImage: "number")
            }
            if let address = parcel.address {
                Label(address, systemImage: "mappin.and.ellipse")
            }
            Spacer()
        }
        .padding()
        .presentationDetents([.medium, .large])
    }
}
