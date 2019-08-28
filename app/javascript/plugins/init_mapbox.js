import MapboxGeocoder from '@mapbox/mapbox-gl-geocoder';
import mapboxgl from 'mapbox-gl';

const mapElement = document.getElementById('map');

const buildMap = () => {
  mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
  return new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/streets-v10'
  });
};

const addMarkersToMap = (map, markers, location) => {

  markers.forEach((marker) => {
    const popup = new mapboxgl.Popup().setHTML(marker.infoWindow);

    new mapboxgl.Marker()
      .setLngLat([ marker.lng, marker.lat ])
      .setPopup(popup)
      .addTo(map);
  });

  var el = document.createElement('div');
  el.className = 'marker';

  Array.prototype.forEach.call(location, (marker) => {
    const popup = new mapboxgl.Popup().setHTML(marker.infoWindow);

    new mapboxgl.Marker(el)
      .setLngLat([ marker.lng, marker.lat ])
      .setPopup(popup)
      .addTo(map);
  });
};

const fitMapToMarkers = (map, markers, location) => {
  const bounds = new mapboxgl.LngLatBounds();
  markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
  Array.prototype.forEach.call(location, (marker => bounds.extend([ marker.lng, marker.lat ])));
  map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
};

const initMapbox = () => {
  if (mapElement) {
    const map = buildMap();
    const markers = JSON.parse(mapElement.dataset.markers);
    const location = JSON.parse(mapElement.dataset.location)
    addMarkersToMap(map, markers, location);
    fitMapToMarkers(map, markers, location);
  }
};

export { initMapbox };
