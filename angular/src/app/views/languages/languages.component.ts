import {Component, OnInit, ViewChild} from '@angular/core';
import {BsModalService, ModalDirective} from "ngx-bootstrap";
import {environment} from "../../../environments/environment.prod";
import {FormBuilder, Validators} from "@angular/forms";
import {AlertService} from "ngx-alerts";
import {RequestService} from "../../shared/Service/request.service";
import {ActivatedRoute} from "@angular/router";

@Component({
  selector: 'app-languages',
  templateUrl: './languages.component.html',
  styleUrls: ['./languages.component.scss']
})
export class LanguagesComponent implements OnInit {

  @ViewChild('autoShownModal') autoShownModal: ModalDirective;
  isModalShown: boolean = false;
  url: any;
  tableData: any;
  requestType: any;
  idObject: any;
  image: any;

  modalForm = this.fb.group({
    title: ['', Validators.compose([Validators.required, Validators.minLength(2)])],
    code: ['', Validators.compose([Validators.required, Validators.minLength(2), Validators.maxLength(3)])],
    image: [''],
    status: [true],
  });
  viewUsersData: any;
  imageValue: any;
  editImagePath: any;
  imagePath: any;

  constructor(
    private alertService: AlertService,
    private fb: FormBuilder,
    private modalService: BsModalService,
    public activeRoute: ActivatedRoute,
    public requestService: RequestService) {
    this.requestService.activeCountryCode = this.activeRoute.snapshot.params['code'];
  }

  ngOnInit() {
    this.url = `${environment.endpoint}${this.requestService.activeCountryCode}${environment.languages.get}`;
    this.getData(this.url);
  }

  // get all language table data
  getData(url) {
    this.requestService.getData(url).subscribe((items) => {
      this.tableData = !items['message'] ? items['data'] : items['message'];
      this.requestService.paginationConfig.totalItems = !items['message'] ? items['total'] : 0;
      this.requestService.paginationConfig.perPage = !items['message'] ? items['per_page'] : 0;
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }

  // open view or edit modal
  openModalWithClass(type, id?) {
    this.modalForm.reset();
    this.requestType = type;
    this.idObject = id;
    this.imageValue = undefined;
    this.requestService.getData(`${this.url}/${id}`).subscribe((item) => {
      let data = item[0];
      this.viewUsersData = data;
      if (type === 'edit') {
        this.modalForm.patchValue({
          title: data['title'],
          code: data['code'],
          status: data['status'],
        });
      }
      this.editImagePath = data.image.url;
      this.isModalShown = true;
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }

  // delete language function
  delete() {
    this.requestService.delete(`${this.url}`, this.idObject).subscribe(res => {
      this.getData(`${this.url}${this.constructUrl()}`);
      this.autoShownModal.hide();
      this.alertService.success(res['message']);
    }, error => {
      this.requestService.StatusCode(error);
    });
  }

  // send create or edit request
  formSubmit(form) {
    form.status = form.status ? 1 : 0;
    let data = new FormData();
    for (let key in form) {
      if (key == 'image') {
        if (this.image) {
          data.append(key, this.image);
        }
      }else if (key == 'status') {
        if (this.requestType === 'edit') {
          data.append(key, form[key]);
        }
      }
      else {
        data.append(key, form[key]);
      }
    }
    if (this.requestType === 'add') {
      this.addItem(data);
    } else if (this.requestType === 'edit') {
      this.editItemData(data, this.idObject);
    }
  }

  // send edit request
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

  // image validation function
  fileUpload(e) {
    if (e.target.files[0]) {
      const fileName = e.target.files[0].name;
      if (/\.(jpe?g|png|bmp)$/i.test(fileName)) {
        const filesize = e.target.files[0].size;
        if (filesize > 15728640) {
          this.imageValue = undefined;
          this.modalForm.get('image').setErrors({size: 'Image max size 1mb'});
        } else {
          let reader = new FileReader();
          reader.readAsDataURL(e.target.files[0]);
          reader.onload = () => {
            this.imageValue = reader.result;
          };
          this.image = e.target.files[0];
          this.modalForm.get('image').setErrors(null);
        }
      } else {
        this.imageValue = undefined;
        this.modalForm.get('image').setErrors({type: 'pleace enter valid image'});
      }
    } else {
      this.imageValue = undefined;
      this.modalForm.get('image').setErrors(null);
    }
  }

  // called when modal is closing
  onHidden(): void {
    this.isModalShown = false;
    this.modalForm.reset();
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
