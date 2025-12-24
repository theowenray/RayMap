## RayMap (iOS)

SwiftUI app that shows Shelby County, IL parcels from the public ArcGIS FeatureServer. No token or login required. Tapping a parcel or searching by parcel ID shows the owner name.

### Service details
- Parcel layer: `https://services2.arcgis.com/VqPd1Ybcc46AvijK/arcgis/rest/services/Parcels_Service121324/FeatureServer/0`
- Owner field: `Name`
- Parcel ID field: `PARCEL_ID`
- Address field: `Address1`

### How to set up in Xcode
1) Create a new iOS App project in Xcode named `RayMap` using SwiftUI + Swift, iOS 17 target (or later).
2) Add the ArcGIS Maps SDK for Swift via Swift Package Manager:  
   - File → Add Package Dependencies…  
   - URL: `https://github.com/Esri/arcgis-maps-sdk-swift`  
   - Use the latest version. Add the `ArcGIS` product.
3) Replace the app sources with the files in `src/`:
   - `RayMapApp.swift`
   - `ContentView.swift`
   - `MapModel.swift`
   - `Parcel.swift`
   - `SearchBar.swift`
4) Run on a simulator or device with internet access. Pan/zoom the map, tap parcels to see owner + parcel ID, or search by parcel ID.

### Notes
- The app uses an imagery basemap and centers on Shelby County, IL. Adjust `startViewpoint` in `MapModel` if you want a different zoom.
- `MapModel` uses `identify` on tap and a server-side `whereClause` for parcel ID search. Add more fields (taxes, zoning, etc.) by extending `Parcel` and the query outFields.
