import {Component, AfterViewInit, OnInit, Input} from '@angular/core';

import * as L from 'leaflet';
import {HttpClient} from "@angular/common/http";

@Component({

  selector: 'app-map',

  templateUrl: './map.component.html',

  styleUrls: ['./map.component.css']

})

export class MapComponent implements AfterViewInit, OnInit {
  @Input() idItem;
  @Input() data;
  @Input() type;
  private map: any = {};
  private json: any;

  private initMap(): void {

    let latitude = (this.data && this.type == 'single-view') ? this.data.latitude : 40.937685;
    let longitude = (this.data && this.type == 'single-view') ? this.data.longitude : 43.893433;

    this.map[this.idItem] = L.map(this.idItem, {

      center: [ latitude, longitude ],

      zoom: this.type == 'single-view' ? 10 : 7,

    });
    const myIcon = L.icon({
      iconUrl: 'assets/images/icons/icon-pin.png',
      iconSize: [32, 32],
      iconAnchor: [16,32],
      popupAnchor: [-3, -76],
      shadowAnchor: [22, 94]
    });
    if (this.data && this.type == 'single-view') {
      L.marker([+this.data.latitude, +this.data.longitude], {icon: myIcon}).addTo(this.map[this.idItem]);
      // console.log(this.data);
      // for (let i = 0; i < this.data.length; i++) {
      //   L.marker([+this.data[i].latitude, +this.data[i].longitude], {icon: myIcon}).addTo(this.map[this.idItem]);
      // }
    }
    if(this.data && this.type == 'all') {
      for (let i = 0; i < this.data.length; i++) {
        L.marker([+this.data[i].latitude, +this.data[i].longitude], {icon: myIcon}).addTo(this.map[this.idItem]);
      }
    }
    const tiles  = L.tileLayer('https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}{r}.png?api_key=5689a47c-fbb1-4fe2-b838-a13755f54f50', {
      maxZoom: 20,
      noWrap: true,
      attribution: '&copy; <a href="https://stadiamaps.com/">Stadia Maps</a>, &copy; <a href="https://openmaptiles.org/">OpenMapTiles</a> &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors',

    });
    tiles.addTo(this.map[this.idItem]);

  }

  constructor(public http: HttpClient) {

  }
  ngOnInit(): void {
    this.http.get('assets/map/countries.json').subscribe((json: any) => {
      this.json = json;
      L.geoJSON(this.json,{
        style: function () {
          return {
            'weight': 1,
            'color': 'black',
            'fillColor': '#e37f94'
          }
        }
      }).addTo(this.map[this.idItem]);
    });
  }
  ngAfterViewInit(): void {

    this.initMap();

  }

}
