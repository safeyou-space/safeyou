import {Component, OnInit, ViewChild} from '@angular/core';
import {animate, state, style, transition, trigger} from "@angular/animations";
import {ModalDirective} from "ngx-bootstrap/modal";
import {FormBuilder, Validators} from "@angular/forms";
import {RequestService} from "../../../../shared/request.service";
import {environment} from "../../../../../environments/environment.prod";
import {ActivatedRoute} from "@angular/router";
import {AppUserEditCreateComponent} from "./app-user-edit-create/app-user-edit-create.component";
import {HelperService} from "../../../../shared/helper.service";
import {DeleteModalComponent} from "../../../../components/utils/delete-modal/delete-modal.component";
import {ReportModalComponent} from "../../../../components/utils/report-modal/report-modal.component";

@Component({
  selector: 'app-users-users',
  templateUrl: './app-users.component.html',
  styleUrls: ['./app-users.component.css'],
  animations: [
    trigger('openClose', [
      // ...
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

      state('openButton', style({})),
      state('closedButton', style({
        opacity: 0,
        visibility: 'hidden'
      })),

      transition('openButton <=> closedButton', [
        animate('0.5s linear')
      ]),

      state('openAnimations', style({})),
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

      transition('openIf <=> closedIf', [
        animate('0.5s linear')
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
        animate('0.6s ease-in-out')
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
export class AppUsersComponent implements OnInit {
  url: any;
  users: any = [];
  language: any;
  country: any;
  @ViewChild('autoShownModal', {static: false}) autoShownModal: any = ModalDirective;
  @ViewChild('staticModal') private consultantModal;
  @ViewChild(DeleteModalComponent) private modal!: DeleteModalComponent;
  @ViewChild(ReportModalComponent) private reportModal!: ReportModalComponent;
  isModalShown = false;
  bool = false;
  chatOpen = false;
  professionsList = false;
  bids = false;
  openAddOrCreate = false;
  itemList: any;
  consultantList: any;
  selectedItems: any;
  settings = {};
  showFilter = false;
  pageType: any;
  message: any;
  viewId: any;
  allPageData: any;
  static instance: AppUsersComponent;
  toConsultantForm = this.fb.group({
    email: ['', Validators.compose([Validators.required, Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,10}$/)])],
    consultant_category_id: ['', Validators.required]
  });
  itemObject: any;
  sortingValue: any = {};
  dateRangeFilter: string = '';
  filterUrl: any = '';
  searchParams: string = '';

  constructor(public requestService: RequestService,
              public activateRoute: ActivatedRoute,
              public fb: FormBuilder,
              public helperService: HelperService) {
    AppUsersComponent.instance = this;
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
  }

  ngOnInit(): void {
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.appUsers.get}`;
    this.getData(this.url);
    setTimeout(() => {
      this.settings = {
        text:this.helperService.translation?.select_profession,
        selectAllText:'Select All',
        unSelectAllText:'UnSelect All',
        enableSearchFilter: true,
        classes:"myclass custom-class",
        showCheckbox: true,
        singleSelection: true,
        autoPosition: false,
      };
    },0)
  }

  getData(url) {
    this.requestService.getData(url).subscribe((res) => {
      this.users = res['data'] ? res['data'] : res;
      this.allPageData = res;
    })
  }


  callSubmit(type, id?) {
    if (type == 'create') {
      AppUserEditCreateComponent.instance.onSubmit('1');
    } else if (type == 'close') {
      AppUserEditCreateComponent.instance.close();
      this.close()
    } else if (type == 'save') {
      AppUserEditCreateComponent.instance.onSubmit('0');
    } else if(type == 'Edit'){
      this.pageType = 'edit';
      this.bool = false;
      this.openAddOrCreate = true;
      this.showFilter = false;
      AppUserEditCreateComponent.instance.ngOnInit();
      AppUserEditCreateComponent.instance.getDataById(id);
    } else if(type == 'add'){
      this.pageType = 'create';
      AppUserEditCreateComponent.instance.ngOnInit();
    }
  }

  viewData(data) {
    this.viewId = data;
    this.bool = true;
  }

  pageChanged(event) {
    this.allPageData.current_page = event.page;
    this.getData(this.urlConstructor());
  }


  closeDropdown(dropdownRef) {
    dropdownRef.closeDropdown();
  }

  close() {
    this.openAddOrCreate = false;
    this.bool = false;
    this.professionsList = false;
    this.bids = false;
  }

  closeFilter() {
    this.showFilter = false;
  }

  saveDateRange(data) {
    this.dateRangeFilter = data ? data[2] : '';
    this.allPageData.current_page = 1;
    this.getData(this.urlConstructor());
  }


  deleteItem(id) {
    this.modal.modalRef.hide();
    let url = this.itemObject.is_consultant == 1 ? `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.consultants.get}` : `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.appUsers.get}`;
    this.requestService.delete(url, id).subscribe((res) => {
      this.allPageData.current_page = (this.allPageData.current_page > 1 && this.allPageData.data.length == 1) ?  this.allPageData.current_page - 1 : this.allPageData.current_page;
      this.getData(this.urlConstructor());
    })
  }

  changeStatus(item, status) {
    let value = {status: status == 1 ? 0 : 1};
    let url = item.is_consultant == 1 ? `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.consultants.changeStatus}` : `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.appUsers.changeStatus}`;
    this.requestService.updateData(url, value, item.id).subscribe((item) => {
      this.getData(this.urlConstructor());
    })
  }

  changeToConsultant() {
    let id = this.toConsultantForm.value.consultant_category_id[0].userId;
    let value = {
      consultant_category_id: this.toConsultantForm.value.consultant_category_id[0].id,
      email: this.toConsultantForm.value.email
    }
    this.requestService.createData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.appUsers.changeToConsultant}/${id}`,value).subscribe((items) => {
      this.consultantModal.hide();
    })
  }

  showConsultantModal(id) {
    this.requestService.getData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.consultants.getProfessionList}/list`).subscribe((items) => {
      let arr = [] as any;
      for (let i in items) {
        arr.push({
          id: i,
          itemName: items[i],
          userId: id
        })
      }
      this.consultantModal.show();
      this.consultantList = [...arr];
    })
  }

  urlConstructor() {
    let sorting =  Object.keys(this.sortingValue).length == 0 ? '' : `&sorts=${JSON.stringify(this.sortingValue)}`;
    let search = this.searchParams.trim().length > 0 ? `&search=${this.searchParams.trim()}` : '';
    let url = `${this.url}?page=${this.allPageData?.current_page}${encodeURI(sorting)}${this.dateRangeFilter}${encodeURI(this.filterUrl)}${search}`;
    return url;
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
   this.getData(this.urlConstructor());
  }

  filter(e) {
    this.filterUrl = e;
    this.allPageData.current_page = 1;
    this.getData(this.urlConstructor())
  }
  search(e) {

    this.allPageData.current_page = 1;
    this.searchParams = typeof e.search == 'string' ? e.search : '';
    this.getData(this.urlConstructor());
  }
}
