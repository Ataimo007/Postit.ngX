class GeocodingResponseEntity {
  GeocodingResponsePlusCode plusCode;
  List<GeocodingResponseResult> results;
  String status;

  GeocodingResponseEntity({this.plusCode, this.results, this.status});

  GeocodingResponseEntity.fromJson(Map<String, dynamic> json) {
    plusCode = json['plus_code'] != null
        ? new GeocodingResponsePlusCode.fromJson(json['plus_code'])
        : null;
    if (json['results'] != null) {
      results = new List<GeocodingResponseResult>();
      (json['results'] as List).forEach((v) {
        results.add(new GeocodingResponseResult.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.plusCode != null) {
      data['plus_code'] = this.plusCode.toJson();
    }
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }

  String getCountry() {
    return getAddressName('country');
  }

  String getCountryCode() {
    return getAddressName('country');
  }

  String getState() {
    return getAddressName('administrative_area_level_1');
  }

  String getCity() {
    return getAddressName('administrative_area_level_2');
  }

  String getAddressName(String name) {
    String location = "";
    if (results.isNotEmpty) {
      results[0].addressComponents.forEach((address) {
        if (address.types[0] == name) location = address.longName;
      });
    }
    return location;
  }

  String getAddressShortName(String name) {
    String location = "";
    if (results.isNotEmpty) {
      results[0].addressComponents.forEach((address) {
        if (address.types[0] == name) location = address.shortName;
      });
    }
    return location;
  }

  @override
  String toString() {
    return 'GeocodingResponseEntity{plusCode: $plusCode, results: $results, status: $status}';
  }
}

class GeocodingResponsePlusCode {
  String compoundCode;
  String globalCode;

  GeocodingResponsePlusCode({this.compoundCode, this.globalCode});

  GeocodingResponsePlusCode.fromJson(Map<String, dynamic> json) {
    compoundCode = json['compound_code'];
    globalCode = json['global_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['compound_code'] = this.compoundCode;
    data['global_code'] = this.globalCode;
    return data;
  }

  @override
  String toString() {
    return 'GeocodingResponsePlusCode{compoundCode: $compoundCode, globalCode: $globalCode}';
  }
}

class GeocodingResponseResult {
  String formattedAddress;
  List<String> types;
  GeocodingResponseResultsGeometry geometry;
  List<GeocodingResponseResultsAddressComponent> addressComponents;
  String placeId;

  GeocodingResponseResult(
      {this.formattedAddress,
      this.types,
      this.geometry,
      this.addressComponents,
      this.placeId});

  GeocodingResponseResult.fromJson(Map<String, dynamic> json) {
    formattedAddress = json['formatted_address'];
    types = json['types']?.cast<String>();
    geometry = json['geometry'] != null
        ? new GeocodingResponseResultsGeometry.fromJson(json['geometry'])
        : null;
    if (json['address_components'] != null) {
      addressComponents = new List<GeocodingResponseResultsAddressComponent>();
      (json['address_components'] as List).forEach((v) {
        addressComponents
            .add(new GeocodingResponseResultsAddressComponent.fromJson(v));
      });
    }
    placeId = json['place_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['formatted_address'] = this.formattedAddress;
    data['types'] = this.types;
    if (this.geometry != null) {
      data['geometry'] = this.geometry.toJson();
    }
    if (this.addressComponents != null) {
      data['address_components'] =
          this.addressComponents.map((v) => v.toJson()).toList();
    }
    data['place_id'] = this.placeId;
    return data;
  }

  @override
  String toString() {
    return 'GeocodingResponseResult{formattedAddress: $formattedAddress, types: $types, geometry: $geometry, addressComponents: $addressComponents, placeId: $placeId}';
  }
}

class GeocodingResponseResultsGeometry {
  GeocodingResponseResultsGeometryViewport viewport;
  GeocodingResponseResultsGeometryBounds bounds;
  GeocodingResponseResultsGeometryLocation location;
  String locationType;

  GeocodingResponseResultsGeometry(
      {this.viewport, this.bounds, this.location, this.locationType});

  GeocodingResponseResultsGeometry.fromJson(Map<String, dynamic> json) {
    viewport = json['viewport'] != null
        ? new GeocodingResponseResultsGeometryViewport.fromJson(
            json['viewport'])
        : null;
    bounds = json['bounds'] != null
        ? new GeocodingResponseResultsGeometryBounds.fromJson(json['bounds'])
        : null;
    location = json['location'] != null
        ? new GeocodingResponseResultsGeometryLocation.fromJson(
            json['location'])
        : null;
    locationType = json['location_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.viewport != null) {
      data['viewport'] = this.viewport.toJson();
    }
    if (this.bounds != null) {
      data['bounds'] = this.bounds.toJson();
    }
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    data['location_type'] = this.locationType;
    return data;
  }

  @override
  String toString() {
    return 'GeocodingResponseResultsGeometry{viewport: $viewport, bounds: $bounds, location: $location, locationType: $locationType}';
  }
}

class GeocodingResponseResultsGeometryViewport {
  GeocodingResponseResultsGeometryViewportSouthwest southwest;
  GeocodingResponseResultsGeometryViewportNortheast northeast;

  GeocodingResponseResultsGeometryViewport({this.southwest, this.northeast});

  GeocodingResponseResultsGeometryViewport.fromJson(Map<String, dynamic> json) {
    southwest = json['southwest'] != null
        ? new GeocodingResponseResultsGeometryViewportSouthwest.fromJson(
            json['southwest'])
        : null;
    northeast = json['northeast'] != null
        ? new GeocodingResponseResultsGeometryViewportNortheast.fromJson(
            json['northeast'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.southwest != null) {
      data['southwest'] = this.southwest.toJson();
    }
    if (this.northeast != null) {
      data['northeast'] = this.northeast.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'GeocodingResponseResultsGeometryViewport{southwest: $southwest, northeast: $northeast}';
  }
}

class GeocodingResponseResultsGeometryViewportSouthwest {
  double lng;
  double lat;

  GeocodingResponseResultsGeometryViewportSouthwest({this.lng, this.lat});

  GeocodingResponseResultsGeometryViewportSouthwest.fromJson(
      Map<String, dynamic> json) {
    lng = json['lng'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lng'] = this.lng;
    data['lat'] = this.lat;
    return data;
  }

  @override
  String toString() {
    return 'GeocodingResponseResultsGeometryViewportSouthwest{lng: $lng, lat: $lat}';
  }
}

class GeocodingResponseResultsGeometryViewportNortheast {
  double lng;
  double lat;

  GeocodingResponseResultsGeometryViewportNortheast({this.lng, this.lat});

  GeocodingResponseResultsGeometryViewportNortheast.fromJson(
      Map<String, dynamic> json) {
    lng = json['lng'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lng'] = this.lng;
    data['lat'] = this.lat;
    return data;
  }

  @override
  String toString() {
    return 'GeocodingResponseResultsGeometryViewportNortheast{lng: $lng, lat: $lat}';
  }
}

class GeocodingResponseResultsGeometryBounds {
  GeocodingResponseResultsGeometryBoundsSouthwest southwest;
  GeocodingResponseResultsGeometryBoundsNortheast northeast;

  GeocodingResponseResultsGeometryBounds({this.southwest, this.northeast});

  GeocodingResponseResultsGeometryBounds.fromJson(Map<String, dynamic> json) {
    southwest = json['southwest'] != null
        ? new GeocodingResponseResultsGeometryBoundsSouthwest.fromJson(
            json['southwest'])
        : null;
    northeast = json['northeast'] != null
        ? new GeocodingResponseResultsGeometryBoundsNortheast.fromJson(
            json['northeast'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.southwest != null) {
      data['southwest'] = this.southwest.toJson();
    }
    if (this.northeast != null) {
      data['northeast'] = this.northeast.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'GeocodingResponseResultsGeometryBounds{southwest: $southwest, northeast: $northeast}';
  }
}

class GeocodingResponseResultsGeometryBoundsSouthwest {
  double lng;
  double lat;

  GeocodingResponseResultsGeometryBoundsSouthwest({this.lng, this.lat});

  GeocodingResponseResultsGeometryBoundsSouthwest.fromJson(
      Map<String, dynamic> json) {
    lng = json['lng'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lng'] = this.lng;
    data['lat'] = this.lat;
    return data;
  }

  @override
  String toString() {
    return 'GeocodingResponseResultsGeometryBoundsSouthwest{lng: $lng, lat: $lat}';
  }
}

class GeocodingResponseResultsGeometryBoundsNortheast {
  double lng;
  double lat;

  GeocodingResponseResultsGeometryBoundsNortheast({this.lng, this.lat});

  GeocodingResponseResultsGeometryBoundsNortheast.fromJson(
      Map<String, dynamic> json) {
    lng = json['lng'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lng'] = this.lng;
    data['lat'] = this.lat;
    return data;
  }

  @override
  String toString() {
    return 'GeocodingResponseResultsGeometryBoundsNortheast{lng: $lng, lat: $lat}';
  }
}

class GeocodingResponseResultsGeometryLocation {
  double lng;
  double lat;

  GeocodingResponseResultsGeometryLocation({this.lng, this.lat});

  GeocodingResponseResultsGeometryLocation.fromJson(Map<String, dynamic> json) {
    lng = json['lng'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lng'] = this.lng;
    data['lat'] = this.lat;
    return data;
  }

  @override
  String toString() {
    return 'GeocodingResponseResultsGeometryLocation{lng: $lng, lat: $lat}';
  }
}

class GeocodingResponseResultsAddressComponent {
  List<String> types;
  String shortName;
  String longName;

  GeocodingResponseResultsAddressComponent(
      {this.types, this.shortName, this.longName});

  GeocodingResponseResultsAddressComponent.fromJson(Map<String, dynamic> json) {
    types = json['types']?.cast<String>();
    shortName = json['short_name'];
    longName = json['long_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['types'] = this.types;
    data['short_name'] = this.shortName;
    data['long_name'] = this.longName;
    return data;
  }

  @override
  String toString() {
    return 'GeocodingResponseResultsAddressComponent{types: $types, shortName: $shortName, longName: $longName}';
  }
}
