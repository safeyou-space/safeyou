import {Component, OnInit, ViewChild} from '@angular/core';
import {BsModalService, ModalDirective} from "ngx-bootstrap";
import {FormArray, FormBuilder, Validators} from "@angular/forms";
import {AlertService} from "ngx-alerts";
import {ActivatedRoute} from "@angular/router";
import {RequestService} from "../../../shared/Service/request.service";
import {environment} from "../../../../environments/environment.prod";

@Component({
  selector: 'app-consultant-requests',
  templateUrl: './consultant-requests.component.html',
  styleUrls: ['./consultant-requests.component.scss']
})
export class ConsultantRequestsComponent implements OnInit {

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
  suggestedCategory: any;

  modalForm = this.fb.group({
    translations: this.fb.array([]),
    message: ['', Validators.compose([Validators.required, Validators.minLength(1), Validators.maxLength(50)])],
    status: ['']
  });

  categoryForm = this.fb.group({
    translations: this.fb.array([]),
    profession: ['', Validators.compose([Validators.required, Validators.minLength(3)])],
    status: ['']
  });
  languageTranslations: any;
  viewUsersData: any;
  imagePath: any;

  // get translations forms values and methods
  get translationsForm() {
    return this.modalForm.get('translations') as FormArray;
  }

  // get translations forms values and methods from categoryForm
  get translationsCategoryForm() {
    return this.categoryForm.get('translations') as FormArray;
  }

  // modal open function
  showChildModal(): void {
    this.childModal.show();
  }

  // close modal function
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
    this.url = `${environment.endpoint}${this.requestService.activeCountryCode}${environment.consultantsRequest.get}`;
    this.getData(`${this.url}`);
  }

  getData(url) {
    // get all consultant-requests table data
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
    this.requestService.paginationConfig.currentPage = page.page;
    this.getData(`${this.url}${this.constructUrl()}`);
  }

  // open view edit or add modal
  showModal(type, id?) {
    if (type === 'view') {
      this.requestService.getData(`${this.url}/` + id).subscribe(res => {
        this.viewData = res[0];
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

  // collect url parameters
  constructUrl () {
    let url = '';
    let urlParams = [];
    urlParams.push(`page=${this.requestService.paginationConfig.currentPage}`);
    url = `?${urlParams.join('&')}`;
    return encodeURI(url);
  }

  // delete consultant-request function
  delete() {
    this.requestService.delete(`${this.url}`, this.id).subscribe(res => {
      this.hideChildModal();
      this.getData(`${this.url}${this.constructUrl()}`);
      this.alertService.success(res['message']);
    }, error => {
      this.requestService.StatusCode(error);
    });
  }

  // get all language list
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

  // change approve or reject function
  aproveOrReject (value, data) {
    this.id = data.id;
    if (value == 1) {
      if (data.suggested_category && !data.category) {
        this.getLanguageListFromCategory('category');
        this.suggestedCategory = data.suggested_category;
      } else {
        this.sendApproveOrReject(value, data.id);
      }
    } else {
      this.sendApproveOrReject(value, data.id);
    }
  }

  // send approve or reject request
  sendApproveOrReject (value, id) {
    let Obj = {
      status: value
    };
    this.requestService.updateData(this.url, Obj, id).subscribe(res => {
      this.hideChildModal();
      this.getData(`${this.url}${this.constructUrl()}`);
      this.alertService.success(res['message']);
    }, error => {
      this.requestService.StatusCode(error);
    });
  }

  //create new category
  createCategory (form) {
    form.status = 1;
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
    this.requestService.createData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.categoryConsultants.get}`, newData, false).subscribe((res: any) => {
      let Obj = {
        status: 1,
        category_id: res['category_id']
      };
      this.requestService.updateData(this.url, Obj, this.id).subscribe(res => {
        this.hideChildModal();
        this.getData(`${this.url}${this.constructUrl()}`);
        this.alertService.success(res['message']);
      }, error => {
        this.requestService.StatusCode(error);
      });
      this.hideChildModal();
      this.alertService.success(res['message']);
    }, error => {
      this.requestService.StatusCode(error);
    });
  }

  // get all language list
  getLanguageListFromCategory (type, value?) {
    this.requestService.getData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.categoryConsultants.getLanguageList}`).subscribe((item: any) => {
      let data = item;
      this.languageTranslations = item;
      while (this.translationsCategoryForm.length) {
        this.translationsCategoryForm.removeAt(0);
      }
      for (let i = 0; i < data.length; i++) {
        let a = {};
        a[data[i]['code']] = [value ? value[data[i]['code']] : '', Validators.required];
        this.translationsCategoryForm.push(this.fb.group(a));
      }
      this.showChildModal();
      this.requestType = type;
    }, (error) => {
      this.requestService.StatusCode(error);
    })
  }

}
