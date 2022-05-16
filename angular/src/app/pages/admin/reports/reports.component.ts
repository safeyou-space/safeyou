import {Component, OnInit, ViewChild} from '@angular/core';
import {animate, state, style, transition, trigger} from "@angular/animations";
import {HelperService} from "../../../shared/helper.service";
import {ActivatedRoute} from "@angular/router";
import {RequestService} from "../../../shared/request.service";
import {environment} from "../../../../environments/environment.prod";
import {DeleteModalComponent} from "../../../components/utils/delete-modal/delete-modal.component";
import {ReportModalComponent} from "../../../components/utils/report-modal/report-modal.component";

@Component({
  selector: 'app-reports',
  templateUrl: './reports.component.html',
  styleUrls: ['./reports.component.css'],
  animations: [
    trigger('openClose', [
      state('open', style({
        width: '462px',
        opacity: 1,
        visibility: 'visible'
      })),
      state('closed', style({
        width: 0,
        opacity: 0,
        visibility: 'hidden'
      })),

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
      transition('hideColumn => showColumn', [
        animate('0.2s ease-out')
      ]),

      transition('open <=> closed', [
        animate('0.6s ease-in-out')
      ]),
    ]),
    trigger('showFilter', [
      // ...
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
    trigger('showCategory', [
      state('open', style({
        width: '560px',
        opacity: 1,
        visibility: 'visible',
      })),
      state('closed', style({
        width: 0,
        opacity: 0,
        visibility: 'hidden',
        position: 'relative'
      })),

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
      transition('hideColumn => showColumn', [
        animate('0.2s ease-out')
      ]),

      transition('open <=> closed', [
        animate('0.6s ease-in-out')
      ]),
    ]),
  ]
})
export class ReportsComponent implements OnInit {
  isOpen = true;
  showFilter = false;
  showCategory = true;
  @ViewChild(DeleteModalComponent) private modal!: DeleteModalComponent;
  @ViewChild(ReportModalComponent) private reportModal!: ReportModalComponent;
  allPageData: any;
  language: any;
  country: any;
  data: any;
  knottedList: any;
  knottedAllPageData: any;
  url: string = '';
  viewData: any;
  type: number = 1;
  dateRangeFilter: string = '';
  static instance: ReportsComponent;

  constructor(public helperService: HelperService,
              public activateRoute: ActivatedRoute,
              public requestService: RequestService) {
    ReportsComponent.instance = this;
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.report.get}`
  }

  ngOnInit(): void {
    this.getData(this.url);
  }

  showViewPage (item) {
    this.isOpen = false;
    this.showFilter = false;
    this.showCategory = true;
    this.viewData = item;
  }
  urlConstructor() {
    let url = `${this.url}?page=${this.allPageData?.current_page}${this.dateRangeFilter}`;
    return url;
  }
  knottedUrlConstructor() {
    let url = `${this.url}?resolved=1&page=${this.knottedAllPageData?.current_page}${this.dateRangeFilter}`;
    return url;
  }

  deleteItem(id) {
    this.modal.modalRef.hide();
    this.requestService.delete(this.url, id).subscribe((item) => {
      this.allPageData.current_page = (this.allPageData.current_page > 1 && this.allPageData.data.length == 1) ?  this.allPageData.current_page - 1 : this.allPageData.current_page;
      this.getData(this.urlConstructor());
    })
  }

  getData(url) {
    this.requestService.getData(url).subscribe((items) => {
      this.data = items['data'] ? items['data'] : items;
      this.allPageData = items
    })
  }

  getKnottedList(url) {
    this.requestService.getData(url).subscribe((items) => {
      this.knottedList = items['data'] ? items['data'] : items;
      this.knottedAllPageData = items
    })
  }

  close () {
    this.isOpen = true;
    this.showCategory = true;
  }
  closeFilter() {
    this.showFilter = false
  }
  saveDateRange(data) {
    this.dateRangeFilter = data ? data[2] : '';
    if (this.type == 1) {
      this.allPageData.current_page = 1;
      this.getData(this.urlConstructor());
    } else {
      this.knottedAllPageData.current_page = 1;
      this.getKnottedList(this.knottedUrlConstructor());
    }
  }

  pageChanged(event) {
    if (this.type == 1) {
      this.allPageData.current_page = event.page;
      this.getData(this.urlConstructor());
    } else {
      this.knottedAllPageData.current_page = event.page;
      this.getKnottedList(this.knottedUrlConstructor());
    }
    // this.getData(`${this.url}?page=${event.page}`);
  }

  changeTab(type) {
    this.type = type;
    if (type == 1) {
      this.allPageData.current_page = 1;
      this.getData(this.url);
    } else {
      this.knottedAllPageData ? this.knottedAllPageData.current_page = 1 : 1;
      this.getKnottedList(`${this.url}?resolved=1`);
    }
  }

  changeStatus(item, status) {
    let value = {resolved: status};
    this.requestService.updateData(`${this.url}`, value, item.id).subscribe((item) => {
      this.getData(this.urlConstructor());
    })
  }
}
