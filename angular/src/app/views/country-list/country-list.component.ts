import { Component, OnInit } from '@angular/core';
import {RequestService} from "../../shared/Service/request.service";
import {environment} from "../../../environments/environment.prod";
import {ActivatedRoute, Router} from "@angular/router";

@Component({
  selector: 'app-country-list',
  templateUrl: './country-list.component.html',
  styleUrls: ['./country-list.component.scss']
})
export class CountryListComponent implements OnInit {

  url: any;
  countryList: any;

  constructor(public router: Router,
              public activeRoute: ActivatedRoute,
              public requestService: RequestService) {
    this.requestService.activeCountryCode = this.activeRoute.snapshot.params['code'];
  }

  ngOnInit() {
    this.url = `${environment.endpoint}${environment.countryList.get}`;
    this.getData(`${this.url}`);
  }

  // get country list function
  getData(url) {
    this.requestService.getData(url).subscribe(res => {
      this.countryList = res
    }, error => {
      this.requestService.StatusCode(error);
    });
  }

  // change country function
  selectCountry (code) {
    this.requestService.activeCountryCode = code;
    this.requestService.getMenuList();
    this.router.navigate([`administrator/${this.requestService.activeCountryCode}/dashboard`]);
  }

}
