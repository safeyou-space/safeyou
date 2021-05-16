import {Component, OnInit, ViewChild} from '@angular/core';
import {BsModalService, ModalDirective} from "ngx-bootstrap";
import {FormBuilder, Validators} from "@angular/forms";
import {AlertService} from "ngx-alerts";
import {ActivatedRoute} from "@angular/router";
import {RequestService} from "../../shared/Service/request.service";
import {environment} from "../../../environments/environment.prod";

@Component({
  selector: 'app-settings',
  templateUrl: './settings.component.html',
  styleUrls: ['./settings.component.scss']
})
export class SettingsComponent implements OnInit {

  @ViewChild('childModal') childModal: ModalDirective;
  isModalShown: boolean = false;
  url: any;
  tableData: any = [];
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
    value: [null, Validators.required],
    description: ['', Validators.compose([Validators.required, Validators.minLength(1)])],
    status: ['']
  });
  policeForm = this.fb.group({
    value: [null, Validators.compose([Validators.required, Validators.pattern(this.requestService.patterns.phone)])],
    description: ['', Validators.compose([Validators.required, Validators.minLength(1)])],
    status: ['']
  });
  languageList: any = [];
  viewUsersData: any;
  imagePath: any;

  showChildModal(): void {
    this.childModal.show();
  }

  hideChildModal(): void {
    this.childModal.hide();
  }



  constructor(
    private alertService: AlertService,
    private fb: FormBuilder,
    private modalService: BsModalService,
    public activeRoute: ActivatedRoute,
    public requestService: RequestService) {
    this.requestService.activeCountryCode = this.activeRoute.snapshot.params['code'];
  }

  ngOnInit() {
    this.url = `${environment.endpoint}${this.requestService.activeCountryCode}${environment.settings.get}`;
    this.getData(`${this.url}`);
  }

  // get settings data
  getData(url) {
    this.requestService.getData(url).subscribe(res => {
      this.tableData.splice(0);
      this.tableData.push(res['default_help_message'][0]);
      this.tableData.push(res['default_support_language'][0]);
      this.tableData.push(res['police_phone_number'][0]);
      this.requestService.paginationConfig.totalItems = !res['message'] ? res['total'] : 0;
      this.requestService.paginationConfig.perPage = !res['message'] ? res['per_page'] : 0;
    }, error => {
      this.requestService.StatusCode(error);
    });
  }

  // pagination change function
  pageChanged(page) {
    this.requestService.paginationConfig.currentPage = page.page;
    this.getData(`${this.url}${this.constructUrl()}`);
  }

  // get setting for show or edit
  showModal(type, id?) {
    if (type === 'view') {
      this.requestService.getData(`${this.url}/` + id).subscribe(res => {
        this.viewData = res['setting'];
        this.requestType = type;
        this.showChildModal();
      }, (error) => {
        this.requestService.StatusCode(error);
      });
    } else if (type === 'edit') {
      this.requestService.getData(`${this.url}/` + id).subscribe(res => {
        this.modalForm.reset();
        if (id == 'police_phone_number') {
          this.policeForm.patchValue({
            value: res['setting'].value,
            description: res['setting'].description,
            status: res['setting'].status
          });
          this.id = id;
          this.requestType = 'police';
        } else {
          let selectList = id == 'default_support_language' ? res['languages'] : res['help_messages'];
          this.languageList.splice(0);
          for (let i = 0; i < selectList.length; i++) {
            this.languageList.push({
              id: selectList[i].id,
              value: id == 'default_support_language' ? selectList[i].title : selectList[i].message
            })
          }
          this.viewData = res['setting'];
          let data = res['setting'];
          this.modalForm.patchValue({
            description: data.description,
            value: data.value,
            status: data.status
          });
          this.id = id;
          this.requestType = type;
        }
        this.showChildModal();
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
    form.status = this.requestType == 'police' ? form.status ? 1 : 0 : 1;

    if (this.requestType == 'add') {
      this.requestService.createData(`${this.url}`, form, false).subscribe(res => {
        this.getData(`${this.url}${this.constructUrl()}`);
        this.hideChildModal();
        this.alertService.success(res['message']);
      }, error => {
        this.requestService.StatusCode(error);
      });
    } else if (this.requestType == 'edit' || this.requestType == 'police') {
      this.requestService.createData(`${this.url}/` + this.id, form, false).subscribe(res => {
        this.hideChildModal();
        this.getData(`${this.url}${this.constructUrl()}`);
        this.alertService.success(res['message']);
      }, error => {
        this.requestService.StatusCode(error);
      });
    }
  }

  // collect url parameters
  constructUrl () {
    let url = '';
    let urlParams = [];
    urlParams.push(`page=${this.requestService.paginationConfig.currentPage}`);
    url = `?${urlParams.join('&')}`;
    return encodeURI(url);
  }

  // setting delete function
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
    this.requestService.getData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.settings.getLanguageList}`).subscribe((item: any) => {
      let data = item;
      this.languageList.splice(0);
      for (let i = 0; i < data.length; i++) {
        this.languageList.push({
          id: data[i].id,
          value: data[i].title
        })
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
