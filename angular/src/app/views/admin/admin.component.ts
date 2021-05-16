import {Component, OnInit, ViewChild} from '@angular/core';
import {BsModalService, ModalDirective} from "ngx-bootstrap";
import {environment} from "../../../environments/environment.prod";
import {FormBuilder, FormGroup, Validators} from "@angular/forms";
import {AlertService} from "ngx-alerts";
import {RequestService} from "../../shared/Service/request.service";
import {ActivatedRoute} from "@angular/router";

@Component({
  selector: 'app-admin',
  templateUrl: './admin.component.html',
  styleUrls: ['./admin.component.scss']
})
export class AdminComponent implements OnInit {

  @ViewChild('autoShownModal') autoShownModal: ModalDirective;
  isModalShown: boolean = false;
  url: any;
  usersData: any;
  requestType: any;
  idObject: any;
  image: any;

  passwordsGroup = this.fb.group({
    password: [''],
    password_confirmation: [''],
  }, {validator: this.checkPasswords});

  userForm = this.fb.group({
    first_name: ['', Validators.compose([
      Validators.required,
      Validators.minLength(3),
      Validators.maxLength(250)
    ])],
    last_name: ['', Validators.compose([
      Validators.required,
      Validators.minLength(3),
      Validators.maxLength(250)
    ])],
    email: ['', Validators.compose([
      Validators.required,
      Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/)
    ])],
    role: [null, Validators.required],
    phone: ['', Validators.compose([
      Validators.required,
      Validators.minLength(1),
      Validators.pattern(this.requestService.patterns.phone)
    ])],
    image: [''],
    passwordsGroup: this.passwordsGroup,
    status: [true]
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
    this.url = `${environment.endpoint}${this.requestService.activeCountryCode}${environment.administration.get}`;
    this.getData(this.url);
  }

  // get Admin users list
  getData(url) {
    this.requestService.getData(url).subscribe((items) => {
      this.usersData = items['data'] ? items['data'] : items;
      this.requestService.paginationConfig.totalItems = !items['message'] ? items['total'] : 0;
      this.requestService.paginationConfig.perPage = !items['message'] ? items['per_page'] : 0;
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }

  // pagination change function
  pageChanged(page) {
    this.requestService.paginationConfig.currentPage = page.page;
    this.getData(`${this.url}${this.constructUrl()}`);
  }

  // open add or edit modal and get default profile image
  openModal(type, id?) {
    this.requestType = type;
    this.idObject = id;
    this.userForm.reset();
    if (type === 'add') {
      this.getImageProfile(type);
    } else {
      this.isModalShown = true;
    }
  }

  // get profile image
  getImageProfile (type) {
    this.requestService.getData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.administration.getImageProfile}`).subscribe((item) => {
      this.imagePath = item['url'];
      this.imageValue = undefined;
      this.editImagePath = undefined;
      this.passwordsGroup.get('password').setValidators([Validators.required, Validators.minLength(8)]);
      this.passwordsGroup.get('password_confirmation').setValidators([Validators.required, Validators.minLength(8)]);
      this.passwordsGroup.updateValueAndValidity();
      this.isModalShown = true;
    }, (error) => {
      this.requestService.StatusCode(error);
    })
  }

  // get user information for show or edit
  openModalWithClass(type, id?) {
    this.userForm.reset();
    this.requestType = type;
    this.idObject = id;
    this.imageValue = undefined;
    this.requestService.getData(`${this.url}/${id}`).subscribe((item) => {
      let data = item[0];
      this.viewUsersData = data;
      this.passwordsGroup.get('password').setValidators([Validators.minLength(8)]);
      this.passwordsGroup.get('password_confirmation').setValidators([Validators.minLength(8)]);
      this.passwordsGroup.updateValueAndValidity();
      if (type === 'edit') {
        this.userForm.patchValue({
          first_name: data['first_name'],
          last_name: data['last_name'],
          email: data['email'],
          phone: data['phone'],
          status: data['status'],
          role: data['role'].toLowerCase()
        });
      }
      this.editImagePath = data.image.url;
      this.isModalShown = true;
    }, (error) => {
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

  // delete user function
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
  formSubmit(value) {
    value.status = value.status ? 1 : 0;
    let newValue = new FormData();
    newValue.append('status', value.status);
    newValue.append('first_name', value.first_name);
    newValue.append('last_name', value.last_name);
    newValue.append('email', value.email);
    newValue.append('phone', value.phone);
    newValue.append('role', value.role);
    if (value.passwordsGroup.password) {
      newValue.append('password', value.passwordsGroup.password);
      newValue.append('password_confirmation', value.passwordsGroup.password_confirmation);
    } else {
      newValue.delete('password');
      newValue.delete('password_confirmation');
    }
    if (value.image) {
      newValue.append('image', this.image);
    }
    if (this.requestType === 'add') {
      this.addItem(newValue);
    } else if (this.requestType === 'edit') {
      this.editItemData(newValue, this.idObject);
    }
  }
 // send edit request
  editItemData(value, id) {
    value.append('_method', 'PUT');
    this.requestService.createData(this.url + '/' + id, value, false).subscribe((item) => {
      this.autoShownModal.hide();
      this.getData(`${this.url}${this.constructUrl()}`);
      if (id == localStorage.getItem('id')) {
        this.getAuthUser(id);
      }
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

  // check is password and confirm password equal
  checkPasswords(group: FormGroup) {
    let pass = group.controls.password.value;
    let confirmPass = group.controls.password_confirmation.value;
    if ((pass == '' && confirmPass == null) || (confirmPass == '' && pass == null)) {
      pass = confirmPass;
    }

    return pass === confirmPass ? null : {notSame: true};

  }

  // image validation function
  fileUpload(e) {
    if (e.target.files[0]) {
      const fileName = e.target.files[0].name;
      if (/\.(jpe?g|png|bmp)$/i.test(fileName)) {
        const filesize = e.target.files[0].size;
        if (filesize > 15728640) {
          this.imageValue = undefined;
          this.userForm.get('image').setErrors({size: 'Image max size 1mb'})
        } else {
          let reader = new FileReader();
          reader.readAsDataURL(e.target.files[0]);
          reader.onload = () => {
            this.imageValue = reader.result;
          };
          this.image = e.target.files[0];
          this.userForm.get('image').setErrors(null);
        }
      } else {
        this.imageValue = undefined;
        this.userForm.get('image').setErrors({type: 'pleace enter valid image'});
      }
    } else {
      this.imageValue = undefined;
      this.userForm.get('image').setErrors(null);
    }
  }

  // Update auth user information
  getAuthUser(id) {
    this.requestService.getData(`${this.url}/${id}`).subscribe((response) => {
      let data = response[0];
      localStorage.setItem('name', data.first_name + ' ' + data.last_name);
      localStorage.setItem('image', data.image.url);
      this.requestService.userInfo.name = data.first_name + ' ' + data.last_name;
      this.requestService.userInfo.image = data.image.url;
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }

  // called when modal is closing
  onHidden(): void {
    this.isModalShown = false;
    this.userForm.reset();
    this.passwordsGroup.reset();
    this.passwordsGroup.get('password').clearValidators();
    this.passwordsGroup.get('password_confirmation').clearValidators();
    this.imageValue = undefined;
    this.editImagePath = undefined;
    this.userForm.removeControl('remove_image');
  }

}
