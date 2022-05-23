import {Component, OnInit, ViewChild} from '@angular/core';
import {animate, state, style, transition, trigger} from "@angular/animations";
import {HelperService} from "../../../shared/helper.service";
import {environment} from "../../../../environments/environment.prod";
import {ActivatedRoute} from "@angular/router";
import {RequestService} from "../../../shared/request.service";
import {DeleteModalComponent} from "../../../components/utils/delete-modal/delete-modal.component";
import {ReportModalComponent} from "../../../components/utils/report-modal/report-modal.component";

@Component({
  selector: 'app-sms',
  templateUrl: './sms.component.html',
  styleUrls: ['./sms.component.css'],
  animations: [
    trigger('openClose', [
      // ...
      state('open', style({
        width: '462px',
        opacity: 1,
        visibility: 'visible'
      })),
      state('closed', style({
        width: 0,
        opacity: 0,
        visibility: 'hidden',
      })),

      state('closedIf', style({
        opacity: 0,
        visibility: 'hidden',
        width: '0%',
        height: 0,
        padding: 0,
        // display: 'none'
      })),

      state('openIf', style({
        width: '20%'
      })),

      transition('openIf <=> closedIf', [
        animate('0.5s linear')
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
  ]
})
export class SmsComponent implements OnInit {
  isOpen = false;
  showFilter = false;
  @ViewChild(DeleteModalComponent) private modal!: DeleteModalComponent;
  @ViewChild(ReportModalComponent) private reportModal!: ReportModalComponent;
  isModalShown = false;
  allPageData: any;
  language: any;
  country: any;
  data: any;
  url: string = '';
  viewData: any;
  dateRangeFilter: string = '';

  constructor(public helperService: HelperService,
              public activateRoute: ActivatedRoute,
              public requestService: RequestService) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.sms.get}`
  }

  ngOnInit(): void {
    this.getData(this.url);
  }

  getData(url) {
    this.requestService.getData(url).subscribe((items) => {
      this.data = items['data'] ? items['data'] : items;
      this.allPageData = items;
    })
  }
  showViewPage (item) {
    this.viewData = item;
  }
  urlConstructor() {
    let url = `${this.url}?page=${this.allPageData?.current_page}${this.dateRangeFilter}`;
    return url;
  }

  deleteItem(id) {
    this.modal.modalRef.hide();
    this.requestService.delete(this.url, id).subscribe((item) => {
      this.getData(this.urlConstructor());
    })
  }

  close () {
    this.isOpen = false;
  }
  closeFilter() {
    this.showFilter = false
  }
  saveDateRange(data) {
    this.dateRangeFilter = data ? data[2] : '';
    this.allPageData.current_page = 1;
    this.getData(this.urlConstructor());
  }
  pageChanged(event) {
    this.allPageData.current_page = event.page;
    this.getData(this.urlConstructor());
  }
}
