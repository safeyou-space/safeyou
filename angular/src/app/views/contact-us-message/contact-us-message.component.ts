import {Component, OnInit, ViewChild} from '@angular/core';
import {BsModalService, ModalDirective} from "ngx-bootstrap";
import {FormBuilder, Validators} from "@angular/forms";
import {AlertService} from "ngx-alerts";
import {ActivatedRoute} from "@angular/router";
import {RequestService} from "../../shared/Service/request.service";
import {environment} from "../../../environments/environment.prod";

@Component({
  selector: 'app-contact-us-message',
  templateUrl: './contact-us-message.component.html',
  styleUrls: ['./contact-us-message.component.scss']
})
export class ContactUsMessageComponent implements OnInit {

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
    message: ['', Validators.compose([Validators.required, Validators.minLength(1), Validators.maxLength(50)])],
  });
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
    this.url = `${environment.endpoint}${this.requestService.activeCountryCode}${environment.contactUs.getContactList}`;
    this.getData(`${this.url}`);
  }

  // get all table data
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
    this.requestService.paginationConfig.currentPage = page.page;
    this.getData(`${this.url}${this.constructUrl()}`);
  }

  // open Show Add or Edit modal function
  showModal(type, id?) {
    this.id = id;
    if (type === 'view') {
      this.requestService.getData(`${this.url}/` + id).subscribe(res => {
        this.viewData = res;
        this.requestType = type;
        this.showChildModal();
      }, (error) => {
        this.requestService.StatusCode(error);
      });
    } else if (type === 'edit') {
      this.showChildModal();
      this.requestType = type;
    } else if (type === 'delete') {
      this.id = id;
      this.showChildModal();
      this.requestType = type;
    } else if (type == 'add') {
    }
  }

  // send create or edit request
  formSubmit(form) {
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
      this.requestService.createData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.contactUs.answerContactUs}/${this.id}`, newData).subscribe(res => {
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

  // delete contact us message
  delete() {
    this.requestService.delete(`${this.url}`, this.id).subscribe(res => {
      this.hideChildModal();
      this.getData(`${this.url}${this.constructUrl()}`);
      this.alertService.success(res['message']);
    }, error => {
      this.requestService.StatusCode(error);
    });
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
