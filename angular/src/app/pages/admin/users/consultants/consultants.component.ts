import {Component, OnInit, ViewChild} from '@angular/core';
import {animate, state, style, transition, trigger} from "@angular/animations";
import {ModalDirective} from "ngx-bootstrap/modal";
import {HelperService} from "../../../../shared/helper.service";
import { FormBuilder} from "@angular/forms";
import {ActivatedRoute} from "@angular/router";
import {RequestService} from "../../../../shared/request.service";
import {environment} from "../../../../../environments/environment.prod";
import {DeleteModalComponent} from "../../../../components/utils/delete-modal/delete-modal.component";
import {ConsultantsEditCreateComponent} from "./consultants-edit-create/consultants-edit-create.component";
import {ReportModalComponent} from "../../../../components/utils/report-modal/report-modal.component";

@Component({
  selector: 'app-consultants',
  templateUrl: './consultants.component.html',
  styleUrls: ['./consultants.component.css'],
  animations: [
    trigger('openClose', [
      state('open', style({
        width: 590,
        opacity: 1,
        visibility: 'visible'
      })),
      state('closed', style({
        width: 0,
        opacity: 0,
        visibility: 'hidden'
      })),

      state('openButton', style({
      })),
      state('closedButton', style({
        opacity: 0,
        visibility: 'hidden'
      })),

      transition('openButton <=> closedButton', [
        animate('0.5s linear')
      ]),

      state('openAnimations', style({
      })),
      state('closedAnimations', style({
        opacity: 0,
        margin: 0,
        padding: 0,
        visibility: 'hidden'
      })),

      transition('openAnimations <=> closedAnimations', [
        animate('0.5s ease-out')
      ]),

      state('closedIf', style({
        opacity: 0,
        visibility: 'hidden',
        width: '0%',
        height: 0,
        padding: 0,
      })),

      state('openIf', style({
        width: '14.5%'
      })),

      transition('open <=> closed', [
        animate('0.6s ease-in-out')
      ]),

      state('chatClose', style({
        visibility: 'hidden',
        opacity: 0
      })),

      state('chatOpen', style({
        opacity: 1
      })),

      transition('chatOpen <=> chatClose', [
        animate('0.5s ease-in')
      ]),

      transition('open <=> closed', [
        animate('0.5s linear')
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
  ],
})
export class ConsultantsComponent implements OnInit {
  @ViewChild('autoShownModal', { static: false }) autoShownModal: any = ModalDirective;
  @ViewChild(DeleteModalComponent) private modal!: DeleteModalComponent;
  @ViewChild(ReportModalComponent) private reportModal!: ReportModalComponent;
  isModalShown = false;
  bool = false;
  chatOpen = false;
  professionsList = false;
  bids = false;
  openAddOrCreate = false;
  showFilter = false;
  language: any;
  country: any;
  data: any;
  allPageData: any;
  url: string = '';
  viewData: any;
  consultantRequest: any;
  consultantBidsItem: any;
  allConsultantRequest: any;
  tabIndex: any = false;
  changeToUserId: any;
  pageType: any;
  static instance: ConsultantsComponent;
  sortingValue: any = {};
  dateRangeFilter: string = '';
  filterUrl: any = '';

  constructor(public helperService: HelperService,
              public activateRoute: ActivatedRoute,
              public requestService: RequestService,
              public fb: FormBuilder) {
    ConsultantsComponent.instance = this;
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.consultants.get}`
  }

  ngOnInit(): void {
    this.getData(this.url);
  }

  getData(url) {
    this.requestService.getData(url).subscribe((res) => {
      this.data = res['data'] ? res['data'] : res;
      this.allPageData = res
    })
  }


  closeDropdown (dropdownRef) {
    dropdownRef.closeDropdown();
  }

  addConsultant() {
    this.pageType = 'create';
    this.chatOpen = false;
    this.bool = false;
    this.openAddOrCreate = true;
    this.showFilter = false;
    ConsultantsEditCreateComponent.instance.ngOnInit();
  }

  close(type?) {
    if (type == 'chat') {
      this.chatOpen = false;
    } else if (type == 'openAddOrCreate') {
      this.openAddOrCreate = false;
      this.chatOpen = false;
      this.bool = false;
    }
    else {
      this.bool = false;
      this.professionsList = false;
      this.bids = false;
    }
  }

  saveDateRange(data) {
    this.dateRangeFilter = data ? data[2] : '';
    this.allPageData.current_page = 1;
    this.getData(this.urlConstructor());
  }

  isGetRequest(e) {
    this.changeTab(this.tabIndex);
  }

  closeFilter() {
    this.showFilter = false;
  }

  pageChanged(event) {
    this.allPageData.current_page = event.page;
    this.getData(this.urlConstructor());
  }

  deleteItem(id) {
    this.modal.modalRef.hide();
    if (this.tabIndex === false) {
      this.deleteConsultant(id);
    } else {
      this.deleteConsultantRequest(id);
    }
  }

  deleteConsultant(id) {
    this.requestService.delete(this.url, id).subscribe((item) => {
      this.allPageData.current_page = (this.allPageData.current_page > 1 && this.allPageData.data.length == 1) ?  this.allPageData.current_page - 1 : this.allPageData.current_page;
      this.getData(this.urlConstructor());
    })
  }

  showViewPage (item) {
    this.viewData = item;
    this.showFilter = false;
  }

  changeStatus(id, status) {
    let value = {status: status == 1 ? 0 : 1};
    this.requestService.updateData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.consultants.changeStatus}`, value, id).subscribe((item) => {
     this.getData(this.urlConstructor());
    })
  }

  changeToAppUser(id, modal) {
    let value = {
      status: 2
    }
    modal.hide();
    this.requestService.createData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.consultants.changeToAppUser}/${id}`, value).subscribe((item) => {
      this.getData(this.urlConstructor());
    })
  }

  changeTab (type?) {
    this.tabIndex = type;
    if (type !== false) {
      let url = type ? `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.consultants.consultantRequest}?type=${type}` :
        `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.consultants.consultantRequest}`;
      this.getConsultantRequest(url, type);
    }
  }

  getConsultantRequest(url, type?) {
    this.requestService.getData(url).subscribe((res) => {
      this.consultantRequest = res['data'] ? res['data'] : res;
      this.allConsultantRequest = res;
      this.allConsultantRequest['type'] = type;
    })
  }

  pageChangedRequest(event, type?) {
    let url = type ? `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.consultants.consultantRequest}?type=${type}?page=${event.page}` :
      `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.consultants.consultantRequest}?page=${event.page}`;
    this.getConsultantRequest(url, type)
  }

  urlConstructor() {
    let sorting =  Object.keys(this.sortingValue).length == 0 ? '' : `&sorts=${JSON.stringify(this.sortingValue)}`;
    let url = `${this.url}?page=${this.allPageData?.current_page ? this.allPageData?.current_page : 1}${encodeURI(sorting)}${this.dateRangeFilter}${encodeURI(this.filterUrl)}`;
    return url;
  }

  showConsultantBids (item) {
    this.consultantBidsItem = item;
    this.showFilter = false;
  }

  callSubmit(type, id?) {
    if (type == 'create') {
      ConsultantsEditCreateComponent.instance.onSubmit('1');
    } else if (type == 'close') {
      ConsultantsEditCreateComponent.instance.close();
      this.close()
    } else if (type == 'save') {
      ConsultantsEditCreateComponent.instance.onSubmit('0');
    } else if(type == 'Edit'){
      this.pageType = 'edit';
      this.bool = false;
      this.openAddOrCreate = true;
      ConsultantsEditCreateComponent.instance.ngOnInit();
      ConsultantsEditCreateComponent.instance.getDataById(id);
    } else if(type == 'add'){
      ConsultantsEditCreateComponent.instance.ngOnInit();
    }
  }

  deleteConsultantRequest(id) {
    this.modal.modalRef.hide();
    let url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.consultants.consultantRequest}`;
    this.requestService.delete(url, id).subscribe((item) => {
      let geturl = this.allConsultantRequest['type'] ? `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.consultants.consultantRequest}?type=${this.allConsultantRequest['type']}` :
        `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.consultants.consultantRequest}`;
      this.getConsultantRequest(geturl);
    })
  }

  sorting(value, type?) {
    if (this.sortingValue[value]) {
      this.sortingValue[value] = this.sortingValue[value] == 'ASC' ? 'DESC' : !delete this.sortingValue[value];
    } else {
      this.sortingValue = {};
      this.sortingValue[value] = type;
    }
    if(this.sortingValue[value] == false) {
      this.sortingValue = {};
    }
    this.getData(this.urlConstructor())
  }

  filter(e) {
    this.filterUrl = e;
    this.allPageData.current_page = 1;
    this.getData(this.urlConstructor())
  }

  blockedUser (userId: number, type: number) {
    let data = {
      "user_id": userId,
      "user_block": type
    }
    this.requestService.createData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.appUsers.blocked}`, data).subscribe((item) => {
      this.getData(this.urlConstructor());
    })
  }

}
