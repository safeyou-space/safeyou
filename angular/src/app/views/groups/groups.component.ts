import {Component, OnInit, ViewChild} from '@angular/core';
import {BsModalService, ModalDirective} from "ngx-bootstrap";
import {environment} from "../../../environments/environment.prod";
import {FormBuilder, Validators} from "@angular/forms";
import {AlertService} from "ngx-alerts";
import {RequestService} from "../../shared/Service/request.service";
import {ActivatedRoute} from "@angular/router";

@Component({
  selector: 'app-groups',
  templateUrl: './groups.component.html',
  styleUrls: ['./groups.component.scss']
})
export class GroupsComponent implements OnInit {

  @ViewChild('autoShownModal') autoShownModal: ModalDirective;
  @ViewChild('smModal') showDeleteModal: ModalDirective;
  isModalShown: boolean = false;
  url: any;
  usersData: any;
  requestType: any;
  idObject: any;
  image: any;
  viewUsersData: any;
  modalForm = this.fb.group({
    title: ['', Validators.required],
    description: ['', Validators.required]
  });
  removeMessageId: any;
  timeOut: any = null;
  searchMessageForm = this.fb.group({
    search: ['']
  });
  searchGroupForm = this.fb.group({
    search: ['']
  });
  paginationConfig: any = {
    totalItems: '',
    perPage: '',
    paginationMaxSize: 10,
    currentPage: 1,
  };

  constructor(
    private alertService: AlertService,
    private fb: FormBuilder,
    private modalService: BsModalService,
    public activeRoute: ActivatedRoute,
    public requestService: RequestService) {
    this.requestService.activeCountryCode = this.activeRoute.snapshot.params['code'];
  }

  ngOnInit() {
    this.url = `${environment.endpoint}${this.requestService.activeCountryCode}${environment.groups.get}`;
    this.searchMessageForm.get('search').valueChanges.subscribe((item) => {
      if (this.isModalShown) {
        this.searchValue('messageForm');
      }
    });
    this.searchGroupForm.get('search').valueChanges.subscribe((item) => {
      this.searchValue();
    });
    this.getData(this.url);
  }

  getData(url) {
    this.requestService.getData(url).subscribe((items) => {
      this.usersData = items['data'] ? items['data'] : items;
      this.requestService.paginationConfig.totalItems = !items['message'] ? items['total'] : 0;
      this.requestService.paginationConfig.perPage = !items['message'] ? items['per_page'] : 0;
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }

  openModal(type, id?) {
    this.requestType = type;
    this.idObject = id;
    this.isModalShown = true;
  }

  openModalWithClass(type, id?, url = '') {
    this.requestType = type;
    this.idObject = id;
    this.requestService.getData(`${environment.groups.getAllMessages}/${id}${url}`).subscribe((item) => {
      let data = item['data'];
      this.paginationConfig.totalItems = !item['message'] ? item['total'] : 0;
      this.paginationConfig.perPage = !item['message'] ? item['per_page'] : 0;
      this.viewUsersData = data;
      this.isModalShown = true;
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }

  delete() {
    this.requestService.delete(`${this.url}`, this.idObject).subscribe(res => {
      this.getData(`${this.url}${this.constructUrl()}`);
      this.autoShownModal.hide();
      this.alertService.success(res['message']);
    }, error => {
      this.requestService.StatusCode(error);
    });
  }

  formSubmit(form) {
    form.status = form.status ? 1 : 0;
    if (this.requestType === 'add') {
      this.addItem(form);
    } else if (this.requestType === 'edit') {
      this.editItemData(form, this.idObject);
    }
  }

  editItemData(value, id) {
    value.append('_method', 'PUT');
    this.requestService.createData(`${this.url}/${id}`, value, false).subscribe((item) => {
      this.autoShownModal.hide();
      this.getData(`${this.url}${this.constructUrl()}`);
      this.alertService.success(item['message']);
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }

  addItem(value) {
    this.requestService.createData(this.url, value, false).subscribe((item) => {
      this.autoShownModal.hide();
      this.getData(`${this.url}${this.constructUrl()}`);
      this.alertService.success(item['message']);
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }


  onHidden(): void {
    this.isModalShown = false;
    this.searchMessageForm.reset();
    this.modalForm.reset();
  }

  constructUrl (type?, page?) {
    let url = '';
    let urlParams = [];
    let searchValues = type == 'messageForm' ? this.searchMessageForm.value : this.searchGroupForm.value;
    let currentPage = type == 'messageForm' ? this.paginationConfig.currentPage : this.requestService.paginationConfig.currentPage;
    for (let key in searchValues) {
      if (searchValues[key]) {
        urlParams.push(key + '=' + searchValues[key]);
      }
    }
    urlParams.push(`page=${currentPage}`);
    url = `?${urlParams.join('&')}`;
    return encodeURI(url);
  }

  pageChanged(event, type?) {
    if (type == 'messageForm' && this.isModalShown) {
      this.paginationConfig.currentPage = event.page;
      this.openModalWithClass('view', this.idObject, this.constructUrl('messageForm'));
    } else {
      this.requestService.paginationConfig.currentPage = event.page;
      this.getData(`${this.url}${this.constructUrl()}`);
    }
  }

  modalBackdrop(id) {
    this.removeMessageId = id;
    let data = document.getElementsByClassName('modal-backdrop');
    if (data[1]) {
      data[1]['style'].zIndex = 1050;
    }
  }

  deleteMessage () {
    this.requestService.delete(`${environment.groups.deleteChatMessages}`, this.removeMessageId).subscribe(res => {
      this.openModalWithClass('view', this.idObject);
      this.showDeleteModal.hide();
      this.alertService.success(res['message']);
    }, error => {
      this.requestService.StatusCode(error);
    });
  }

  searchValue(type?) {
    clearTimeout(this.timeOut);
    this.timeOut = setTimeout(() => {
      if (type == 'messageForm') {
        this.openModalWithClass('view', this.idObject, this.constructUrl('messageForm'));
      } else {
        this.getData(`${this.url}${this.constructUrl()}`);
      }
    }, 500);
  }

}
