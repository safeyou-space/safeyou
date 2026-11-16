import {Component, OnInit, ViewChild} from '@angular/core';
import {BsModalService, ModalDirective} from "ngx-bootstrap";
import {environment} from "../../../environments/environment.prod";
import {FormArray, FormBuilder, Validators} from "@angular/forms";
import {AlertService} from "ngx-alerts";
import {RequestService} from "../../shared/Service/request.service";
import {ActivatedRoute} from "@angular/router";

@Component({
  selector: 'app-pages',
  templateUrl: './contents.component.html',
  styleUrls: ['./contents.component.scss']
})
export class ContentsComponent implements OnInit {

  @ViewChild('autoShownModal') autoShownModal: ModalDirective;
  isModalShown: boolean = false;
  url: any;
  tableData: any;
  requestType: any;
  idObject: any;
  image: any;
  modalForm = this.fb.group({
    title: ['', Validators.required],
    content: this.fb.array([]),
  });
  objectKeys = Object.keys;
  get translationsForm() {
    return this.modalForm.get('content') as FormArray;
  }
  viewUsersData: any;
  imageValue: any;
  editImagePath: any;
  languageTranslations: any;

  constructor(
    private alertService: AlertService,
    private fb: FormBuilder,
    public activeRoute: ActivatedRoute,
    private modalService: BsModalService,
    public requestService: RequestService) {
    this.requestService.activeCountryCode = this.activeRoute.snapshot.params['code'];
  }

  ngOnInit() {
    this.url = `${environment.endpoint}${this.requestService.activeCountryCode}${environment.content.get}`;
    this.getData(this.url);
  }

  // get all content data
  getData(url) {
    this.requestService.getData(url).subscribe((items) => {
      this.tableData = items['data'] ? items['data'] : items;
      this.requestService.paginationConfig.totalItems = !items['message'] ? items['total'] : 0;
      this.requestService.paginationConfig.perPage = !items['message'] ? items['per_page'] : 0;
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }

  // open add
  openModal(type, id?) {
    this.requestType = type;
    this.idObject = id;
    this.modalForm.reset();
    if (type === 'add') {
      this.imageValue = undefined;
    }
    this.isModalShown = true;
  }

  // open view or edit modal
  openModalWithClass(type, id?) {
    this.modalForm.reset();
    this.requestType = type;
    this.idObject = id;
    this.imageValue = undefined;
    this.requestService.getData(`${this.url}/${id}`).subscribe((item) => {
      let data = item[0];
      this.viewUsersData = item;
      if (type === 'edit') {
        this.modalForm.patchValue( {
          title: data['title']
        });
        this.getLanguageList(type, data['translations']); // get language list
      } else {
        this.isModalShown = true;
      }
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }

  // delete content function
  delete() {
    this.requestService.delete(`${this.url}`, this.idObject).subscribe(res => {
      this.getData(`${this.url}${this.constructUrl()}`);
      this.autoShownModal.hide();
      this.alertService.success(res['message']);
    }, error => {
      this.requestService.StatusCode(error);
    });
  }

  // get language list
  getLanguageList (type, value?) {
    this.requestService.getData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.categoryConsultants.getLanguageList}`).subscribe((item: any) => {
      let data = item;
      this.languageTranslations = item;
      while (this.translationsForm.length) {
        this.translationsForm.removeAt(0);
      }
      for (let i = 0; i < data.length; i++) {
        let a = {};
        a[data[i]['code']] = [value ? value[i]['content'] : '', Validators.required];
        this.translationsForm.push(this.fb.group(a));
      }
      this.isModalShown = true;
      this.requestType = type;
    }, (error) => {
      this.requestService.StatusCode(error);
    })
  }

  // send create or edit request
  formSubmit(form) {
    let newData = {};
    for (let i in form) {
      if (i == 'content') {
        let object = {};
        for (let index = 0; index < form['content'].length; index++) {
          object[Object.keys(form['content'][index])[0]]  = Object.values(form['content'][index])[0]
        }
        newData['content'] = object
      } else {
        newData[i] = form[i];
      }
    }
    let data = new FormData();
    if (this.requestType === 'add') {
      this.addItem(form);
    } else if (this.requestType === 'edit') {
      this.editItemData(newData, this.idObject);
    }
  }

  // send edit request
  editItemData(value, id) {
    this.requestService.updateData(`${this.url}`, value, id).subscribe((item) => {
      this.autoShownModal.hide();
      this.getData(`${this.url}${this.constructUrl()}`);
      this.alertService.success(item['message']);
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }

  // send add request
  addItem(value) {
    this.requestService.createData(this.url, value, false).subscribe((item) => {
      this.autoShownModal.hide();
      this.getData(`${this.url}${this.constructUrl()}`);
      this.alertService.success(item['message']);
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }

  // called when modal is closing
  onHidden(): void {
    this.isModalShown = false;
    setTimeout(() => {
      this.modalForm.reset();
    },10);
    this.imageValue = undefined;
    this.editImagePath = undefined;
  }

  // collect url parameters
  constructUrl () {
    let url = '';
    let urlParams = [];
    urlParams.push(`page=${this.requestService.paginationConfig.currentPage}`);
    url = `?${urlParams.join('&')}`;
    return encodeURI(url);
  }

  // pagination change function
  pageChanged(event) {
    this.requestService.paginationConfig.currentPage = event.page;
    this.getData(`${this.url}${this.constructUrl()}`);
  }

}
