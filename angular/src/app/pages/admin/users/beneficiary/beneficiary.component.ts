import {Component, OnInit, ViewChild} from '@angular/core';
import {animate, state, style, transition, trigger} from "@angular/animations";
import {HelperService} from "../../../../shared/helper.service";
import {ReportModalComponent} from "../../../../components/utils/report-modal/report-modal.component";
import {ActivatedRoute} from "@angular/router";
import {RequestService} from "../../../../shared/request.service";
import {environment} from "../../../../../environments/environment.prod";

@Component({
  selector: 'app-beneficiary',
  templateUrl: './beneficiary.component.html',
  styleUrls: ['./beneficiary.component.css'],
  animations: [
    trigger('openClose', [
      state('open', style({
        width: '500px',

      })),
      state('closed', style({
        width: 0,
      })),
      transition('open <=> closed', [
        animate('0.8s ease-in-out')
      ]),
      state('showColumn', style({
        opacity: 1,
      })),
      state('hideColumn', style({
        zIndex: -5,
        opacity: 0,
        position: 'absolute',
      })),
      transition('showColumn => hideColumn', [
        animate('0.2s ease-out')
      ]),
    ]),
    trigger('showFilter', [
      state('open', style({
        width: '398px',
        opacity: 1,
        visibility: 'visible'
      })),
      state('closed', style({
        width: 0,
        opacity: 0,
        visibility: 'hidden'
      })),
      transition('open <=> closed', [
        animate('0.6s ease-in-out')
      ]),
    ]),
    trigger('showMap', [
      state('open', style({
        'max-width': '464px',
        'width': '100%'
      })),
      state('closed', style({
        width: 0,
      })),
      transition('open <=> closed', [
        animate('1s ease-in-out')
      ]),
    ])
  ]
})
export class BeneficiaryComponent implements OnInit {
  showFilter = true;
  isModalShown = false;
  isMapShown: any;
  @ViewChild(ReportModalComponent) private reportModal!: ReportModalComponent;
  allPageData: any;
  allPotencialData: any;
  language: any;
  country: any;
  data: any;
  potencialData: any;
  url: string = '';
  viewData: any;
  type: any = 2;
  isOpen = false;
  userListLocation: any;
  dateRangeFilter: string = '';

  constructor(public helperService: HelperService,
              public activateRoute: ActivatedRoute,
              public requestService: RequestService) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.beneficiary.get}`;
  }

  ngOnInit(): void {
    this.getData(`${this.url}?type=help`);
  }

  closeFilter() {
    this.showFilter = true
  }

  urlConstructor() {
    let url = `${this.url}?type=help&page=${this.allPageData?.current_page}${this.dateRangeFilter}`;
    return url;
  }
  potencialUrlConstructor() {
    let url = `${this.url}?type=potential&page=${this.allPotencialData?.current_page}${this.dateRangeFilter}`;
    return url;
  }

  getData(url) {
    this.isMapShown = false;
    this.requestService.getData(url).subscribe((items) => {
      this.data = items['data'] ? items['data'] : items;
      this.allPageData = items;
      this.showMapUsers();
    })
  }

  getPotencialList (url) {
    this.requestService.getData(url).subscribe((items) => {
      this.potencialData = items['data'] ? items['data'] : items;
      this.allPotencialData = items;
      this.showMapUsers();
    })
  }

  saveDateRange(data) {
    this.dateRangeFilter = data ? data[2] : '';
    if (this.type == 2) {
      this.allPageData.current_page = 1;
      this.getData(this.urlConstructor());
    } else {
      this.allPotencialData.current_page = 1;
      this.getPotencialList(this.potencialUrlConstructor());
    }
  }

  pageChanged(event) {
    if (this.type == 1) {
      this.allPotencialData.current_page = event.page;
      this.getPotencialList(this.potencialUrlConstructor());
    } else {
      this.allPageData.current_page = event.page;
      this.getData(this.urlConstructor());
    }
  }

  changeTab(type) {
    this.type = type;
    this.dateRangeFilter = '';
     if (type == 1) {
       this.getPotencialList(`${this.url}?type=potential`);
     } else {
       this.getData(`${this.url}?type=help`);
    }
  }

  close() {
    this.isOpen = false;
    setTimeout(() => {
      this.isMapShown = true;
    }, 600);
  }

  showViewPage(item) {
    this.viewData = item;
    this.isOpen = true;
    this.isMapShown = false;
  }

  showMapUsers () {
    if (this.data) {
      this.userListLocation = [];
      for (let i = 0; i < this.data.length; i++) {
        this.userListLocation.push(...this.data[i].help_sms);
      }
      this.isMapShown = true;
    }
  }

}
