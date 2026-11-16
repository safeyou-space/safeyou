import {Component, OnInit, ViewChild} from '@angular/core';
import {ModalDirective} from "ngx-bootstrap";
import {FormArray, FormBuilder, Validators} from "@angular/forms";
import {AlertService} from "ngx-alerts";
import {ActivatedRoute} from "@angular/router";
import {RequestService} from "../../shared/Service/request.service";
import {environment} from "../../../environments/environment.prod";
enum CheckBoxTypeStatus { No, Yes, NONE }

@Component({
  selector: 'app-sms',
  templateUrl: './sms.component.html',
  styleUrls: ['./sms.component.scss']
})
export class SmsComponent implements OnInit {

  @ViewChild('childModal') childModal: ModalDirective;
  isModalShown: boolean = false;
  url: any;
  tableData: any;
  totalItems;
  current_page = 1;
  objectKeys = Object.keys;
  viewData;
  requestType;
  id;
  imageValue: any;
  editImagePath: any;
  img;

  modalForm = this.fb.group({
    translations: this.fb.array([]),
    message: ['', Validators.compose([Validators.required, Validators.minLength(1), Validators.maxLength(50)])],
    status: ['']
  });
  viewUsersData: any;
  imagePath: any;
  searchMessage;
  clickSearch;
  searchForm = this.fb.group({
    phone: ['', Validators.maxLength(70)],
    first_name: ['', Validators.maxLength(70)],
    last_name: ['', Validators.maxLength(70)],
    verifying_otp_code: ['', Validators.maxLength(70)],
    service_sms_id: ['', Validators.maxLength(70)],
    message: ['', Validators.maxLength(70)],
    check: [''],
  });
  check_box_typeStatus = CheckBoxTypeStatus;
  currentlyCheckedStatus: CheckBoxTypeStatus;
  currentPageNumber = 1;

  get translationsForm() {
    return this.modalForm.get('translations') as FormArray;
  }

  showChildModal(): void {
    this.childModal.show();
  }

  hideChildModal(): void {
    this.childModal.hide();
  }



  constructor(
    private alertService: AlertService,
    private fb: FormBuilder,
    public activeRoute: ActivatedRoute,
    public requestService: RequestService) {
    this.requestService.activeCountryCode = this.activeRoute.snapshot.params['code'];
  }

  ngOnInit() {
    this.url = `${environment.endpoint}${this.requestService.activeCountryCode}${environment.sms.get}`;
    let searchData = JSON.parse(localStorage.getItem('sms_search'));
    if (searchData) {
      this.clickSearch = true;
      this.searchMessage = 'Search result';
      this.searchForm.patchValue({
        phone: searchData['phone'],
        first_name: searchData['first_name'],
        last_name: searchData['last_name'],
        verifying_otp_code: searchData['verifying_otp_code'],
        service_sms_id: searchData['service_sms_id'],
        message: searchData['message'],
      });
      this.currentlyCheckedStatus = searchData['check'];
      this.searchRefresh(searchData)
    } else {
      this.getData(this.url);
    }
  }

  // open search layout
  openLayout() {
    let element = document.getElementById("div");
    if(document.querySelector(".ui-theme-settings").classList.contains("settings-open")) {
      element.classList.remove("settings-open");
    } else {
      element.classList.add("settings-open");
    }
  }

  // search status select
  selectCheckBox(targetType: CheckBoxTypeStatus) {
    if(this.currentlyCheckedStatus === targetType) {
      this.currentlyCheckedStatus = CheckBoxTypeStatus.NONE;
      return;
    }

    this.currentlyCheckedStatus = targetType;
  }

  // search sms
  search(form) {
    this.currentPageNumber = 1;
    this.requestService.paginationConfig.totalItems =  0;
    this.requestService.paginationConfig.perPage =  0;
    form.check = this.currentlyCheckedStatus;
    if (form.check == '2' || form.check == undefined) {
      delete form.check;
    }
    const obj_params = [];

    for (const res in form) {
      if (form[res] == null) {
        form[res] = ''
      }
      if (form[res].toString() && Array.isArray(form[res]) && form[res].length) {
        obj_params.push(`${res}=${encodeURIComponent(form[res][0].itemName)}`);
      } else if (form[res].toString() && !Array.isArray(form[res].toString())) {
        this.searchMessage = 'Search result';
        obj_params.push(`${res}=${encodeURIComponent(form[res])}`);
      } else {
        continue;
      }
    }
    localStorage.setItem('sms_search', JSON.stringify(form));
    if (obj_params.length > 0) {
      this.clickSearch = obj_params;
      const url = this.constructUrl(obj_params);
      this.getData(url);
    } else {
      this.getData(this.url);
      this.searchForm.reset();
      this.clickSearch = undefined;
      this.currentlyCheckedStatus = undefined;
      this.searchMessage = undefined;
      localStorage.removeItem('sms_search');
    }
  }

  // update search params
  searchRefresh(form) {
    const obj_params = [];
    for (const res in form) {

      if (form[res].toString() && Array.isArray(form[res]) && form[res].length) {
        obj_params.push(`${res}=${encodeURIComponent(form[res][0].itemName)}`);
      } else if (form[res].toString() && !Array.isArray(form[res].toString())) {
        obj_params.push(`${res}=${encodeURIComponent(form[res])}`);
      } else {
        continue;
      }
    }
    if (obj_params.length > 0) {
      this.clickSearch = obj_params;
      const url = this.constructUrl(obj_params);
      this.getData(url);
    }
  }

  // collect url parameters
  constructUrl(obj_params?: string[]) {
    const args = [];
    obj_params && args.push(...obj_params);
    this.currentPageNumber && args.push(`page=${this.currentPageNumber}`);
    const urlParams = args.length ? `?${args.join('&')}` : '';

    return `${this.url}${urlParams}`;
  }

  // search reset
  searchReset() {
    this.currentPageNumber = 1;
    this.requestService.paginationConfig.totalItems =  0;
    this.requestService.paginationConfig.perPage =  0;
    this.clickSearch = undefined;
    this.currentlyCheckedStatus = undefined;
    this.searchMessage = undefined;
    this.getData(this.url);
    localStorage.removeItem('sms_search');
    this.searchForm.reset();
  }

  // get setting data
  getData(url) {
    this.requestService.getData(url).subscribe(res => {
      this.tableData = res['data'] ? res['data'] : res;
      this.requestService.paginationConfig.totalItems = !res['message'] ? res['total'] : 0;
      this.requestService.paginationConfig.perPage = !res['message'] ? res['per_page'] : 0;
    }, error => {
      this.requestService.StatusCode(error);
    });
  }

  // pagination change function
  pageChanged(page) {
    this.currentPageNumber = page.page;
    let url = this.clickSearch === undefined ? this.url + '?page=' + this.currentPageNumber : this.url + '?' + this.clickSearch + '&page=' + this.currentPageNumber;
    this.getData(url);
  }

  // get setting for show or edit
  showModal(type, id?) {
    if (type === 'view') {
      this.requestService.getData(`${this.url}/` + id).subscribe(res => {
        this.viewData = res;
        this.requestType = type;
        this.showChildModal();
      }, (error) => {
        this.requestService.StatusCode(error);
      });
    } else if (type === 'edit') {
      this.requestService.getData(`${this.url}/` + id).subscribe(res => {
        this.modalForm.reset();
        this.viewData = res[0];
        let data = res[0];
        let trans = [];
        let value = {};
        for (let i = 0; i < data['translations'].length; i++) {
          let a = {};
          value[data['translations'][i]['language']['code']] = data['translations'][i]['translation'];
          a[data['translations'][i]['language']['code']] = data['translations'][i]['translation'];
          trans.push(a);
        }
        this.modalForm.patchValue({
          message: data.message,
          translations: trans,
          status: data.status
        });
        this.getLanguageList(type, value);
        this.id = id;
        this.requestType = type;
      }, (error) => {
        this.requestService.StatusCode(error);
      });
      this.requestType = type;
    } else if (type === 'delete') {
      this.id = id;
      this.showChildModal();
      this.requestType = type;
    } else if (type == 'add') {
      this.getLanguageList(type);
    }
  }

  // send create or edit request
  formSubmit(form) {
    form.status = form.status ? 1 : 0;
    let newData = {};
    for (let i in form) {
      if (i == 'translations') {
        let object = {};
        for (let index = 0; index < form['translations'].length; index++) {
          object[Object.keys(form['translations'][index])[0]]  = Object.values(form['translations'][index])[0]
        }
        newData['translations'] = object
      } else {
        newData[i] = form[i];
      }
    }

    if (this.requestType == 'add') {
      this.requestService.createData(`${this.url}`, newData, false).subscribe(res => {
        this.getData(`${this.url}${this.constructUrl()}`);
        this.hideChildModal();
        this.alertService.success(res['message']);
      }, error => {
        this.requestService.StatusCode(error);
      });
    } else if (this.requestType == 'edit') {
      this.requestService.updateData(this.url, newData, this.id).subscribe(res => {
        this.hideChildModal();
        this.getData(`${this.url}${this.constructUrl()}`);
        this.alertService.success(res['message']);
      }, error => {
        this.requestService.StatusCode(error);
      });
    }
  }

  // forum delete function
  delete() {
    this.requestService.delete(`${this.url}`, this.id).subscribe(res => {
      this.hideChildModal();
      this.getData(`${this.url}${this.constructUrl()}`);
      this.alertService.success(res['message']);
    }, error => {
      this.requestService.StatusCode(error);
    });
  }

  // get language list
  getLanguageList (type, value?) {
    this.requestService.getData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.helpMessages.getLanguageList}`).subscribe((item: any) => {
      let data = item;
      while (this.translationsForm.length) {
        this.translationsForm.removeAt(0);
      }
      for (let i = 0; i < data.length; i++) {
        let a = {};
        a[data[i]['code']] = [value ? value[data[i]['code']] : '', Validators.required];
        this.translationsForm.push(this.fb.group(a));
      }
      this.showChildModal();
      this.requestType = type;
    }, (error) => {
      this.requestService.StatusCode(error);
    })
  }

  // called when modal is closing
  onHidden(): void {
    this.imageValue = undefined;
    this.editImagePath = undefined;
    this.img = undefined;
    this.modalForm.reset();
    this.childModal.hide();
  }
}
