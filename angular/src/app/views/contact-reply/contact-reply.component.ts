import {Component, OnInit, ViewChild} from '@angular/core';
import {BsModalService, ModalDirective} from "ngx-bootstrap";
import {FormBuilder, Validators} from "@angular/forms";
import {AlertService} from "ngx-alerts";
import {ActivatedRoute} from "@angular/router";
import {RequestService} from "../../shared/Service/request.service";
import {environment} from "../../../environments/environment.prod";

@Component({
  selector: 'app-contact-reply',
  templateUrl: './contact-reply.component.html',
  styleUrls: ['./contact-reply.component.scss']
})
export class ContactReplyComponent implements OnInit {

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
  messageForm = this.fb.group({
    message: ['', Validators.required],
  });

  modalForm = this.fb.group({
    translations: this.fb.array([]),
    message: ['', Validators.compose([Validators.required, Validators.minLength(1), Validators.maxLength(50)])],
    status: ['']
  });
  viewUsersData: any;
  imagePath: any;

  // open modal function
  showChildModal(): void {
    this.childModal.show();
  }

  //close modal function
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
    this.id = this.activeRoute.snapshot.params['id'];
    this.url = `${environment.endpoint}${this.requestService.activeCountryCode}${environment.contactUs.getContactList}/${this.id}`;
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

  // send contact us message function
  sendMessage(form) {
    this.requestService.createData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.contactUs.answerContactUs}/${this.id}`, form, false).subscribe(res => {
      this.getData(`${this.url}${this.constructUrl()}`);
      this.alertService.success(res['message']);
    }, error => {
      this.requestService.StatusCode(error);
    });
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
