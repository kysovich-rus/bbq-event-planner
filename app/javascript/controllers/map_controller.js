import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    ymaps.ready(this.init);
  }
  init(){
    let address = document.getElementById('map').getAttribute('data-address');

    let myMap = new ymaps.Map("map", {
      center: [55.76, 37.64],
      zoom: 10
    });

    let myGeocoder = ymaps.geocode(address);

    myGeocoder.then(
      function (res) {
        let coordinates = res.geoObjects.get(0).geometry.getCoordinates();

        myMap.geoObjects.add(
          new ymaps.Placemark(
            coordinates,
            {iconContent: address},
            {preset: 'islands#blueStretchyIcon'}
          )
        );

        myMap.setCenter(coordinates);
        myMap.setZoom(15);
      }, function (err) {
        alert('Ошибка при определении местоположения метки');
      }
    );
  }

}
