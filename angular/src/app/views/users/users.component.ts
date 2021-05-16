import {Component, OnInit, ViewChild} from '@angular/core';
import {FormBuilder, FormGroup, Validators} from '@angular/forms';
import { BsModalService, ModalDirective} from 'ngx-bootstrap';
import {RequestService} from '../../shared/Service/request.service';
import {environment} from '../../../environments/environment.prod';
import {AlertService} from 'ngx-alerts';
import {forkJoin, of} from "rxjs";
import {catchError} from "rxjs/operators";
import {ActivatedRoute} from "@angular/router";
enum CheckBoxTypeStatus { Inactive, Active, Blocked, NONE }
enum CheckBoxTypeVerify { No, Yes, NONE }

@Component({
  selector: 'app-users',
  templateUrl: './users.component.html',
  styleUrls: ['./users.component.scss']
})
export class UsersComponent implements OnInit {

  @ViewChild('autoShownModal') autoShownModal: ModalDirective;
  isModalShown: boolean = false;
  url: any = environment.users.get;
  usersData: any;
  requestType: any;
  idObject: any;
  image: any;
  userDetail: any;
  selectedList: any;
  myObject: any = Object;
  maritalList: any;
  passwordsGroup = this.fb.group({
    password: [''],
    password_confirmation: [''],
  }, {validator: this.checkPasswords});

  modalForm = this.fb.group({
    first_name: ['', Validators.compose([
      Validators.required,
      Validators.minLength(3)
    ])],
    last_name: ['', Validators.compose([
      Validators.required,
      Validators.minLength(3)
    ])],
    nickname: ['', Validators.compose([
      Validators.minLength(3)
    ])],
    phone: ['', Validators.compose([
      Validators.required,
      Validators.minLength(1),
      Validators.pattern(this.requestService.patterns.phone)
    ])],
    birthday: ['', Validators.compose([
      Validators.required
    ])],
    is_verifying_otp: [''],
    check_police: [''],
    location: [''],
    image: [''],
    marital_status: [''],
    passwordsGroup: this.passwordsGroup,
    status: [true]
  });
  emergency = this.fb.group({
    name: ['', Validators.compose([Validators.required])],
    phone: ['', Validators.compose([
      Validators.required,
      Validators.minLength(1),
      Validators.pattern(this.requestService.patterns.phone)
    ])]
  });
  searchForm = this.fb.group({
    first_name: ['', Validators.maxLength(70)],
    last_name: ['', Validators.maxLength(70)],
    phone: ['', Validators.maxLength(70)],
    location: ['', Validators.maxLength(70)],
    nickname: ['', Validators.maxLength(70)],
    status: [''],
    is_verifying_otp: [''],
  });
  emailForm = this.fb.group({
    email: ['', Validators.compose([
      Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/),
      Validators.required
    ])],
  });
  viewUsersData: any;
  imageValue: any;
  editImagePath: any;
  records: any;
  imagePath: any;
  counts: any;
  isSuperAdmin: any;
  consultant: any;

  clickSearch;
  currentPageNumber = 1;

  searchMessage;
  check_box_typeStatus = CheckBoxTypeStatus;
  currentlyCheckedStatus: CheckBoxTypeStatus;

  check_box_typeVerify = CheckBoxTypeVerify;
  currentlyCheckedVerify: CheckBoxTypeVerify;

  totalItems = 64;
  currentPage = 4;
  constructor(
    private alertService: AlertService,
    private fb: FormBuilder,
    private modalService: BsModalService,
    public activeRoute: ActivatedRoute,
    public requestService: RequestService) {
    this.requestService.activeCountryCode = this.activeRoute.snapshot.params['code'];  }

  ngOnInit() {
    this.isSuperAdmin = localStorage.getItem('is_super_admin');
    this.url = `${environment.endpoint}${this.requestService.activeCountryCode}${environment.users.get}`;
    let searchData = JSON.parse(localStorage.getItem('users_search'));
    if (searchData) {
      this.clickSearch = true;
      this.searchMessage = 'Search result';
      this.searchForm.patchValue({
        first_name: searchData['first_name'],
        last_name: searchData['last_name'],
        nickname: searchData['nickname'],
        location: searchData['location'],
        phone: searchData['phone'],
        check_police: searchData['check_police']
      });
      this.currentlyCheckedStatus = searchData['status'];
      this.currentlyCheckedVerify = searchData['is_verifying_otp'];
      this.searchRefresh(searchData)
    } else {
      this.getData(this.url);
    }
  }

  // get users data
  getData(url) {
    this.requestService.getData(url).subscribe((items) => {
      this.usersData = items['data'] ? items['data'] : items;
      this.requestService.paginationConfig.totalItems = !items['message'] ? items['total'] : 0;
      this.requestService.paginationConfig.perPage = !items['message'] ? items['per_page'] : 0;
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }

  // search status select
  selectCheckBox(targetType: CheckBoxTypeStatus) {
    if(this.currentlyCheckedStatus === targetType) {
      this.currentlyCheckedStatus = CheckBoxTypeStatus.NONE;
      return;
    }

    this.currentlyCheckedStatus = targetType;
  }

  // search verify select
  selectCheckBoxVerify(targetType: CheckBoxTypeVerify) {
    if(this.currentlyCheckedVerify === targetType) {
      this.currentlyCheckedVerify = CheckBoxTypeVerify.NONE;
      return;
    }

    this.currentlyCheckedVerify = targetType;
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

  // search user
  search(form) {
    this.currentPageNumber = 1;
    this.requestService.paginationConfig.totalItems =  0;
    this.requestService.paginationConfig.perPage =  0;
    form.status = this.currentlyCheckedStatus;
    form.is_verifying_otp = this.currentlyCheckedVerify;
    if (form.status == '3' || form.status == undefined) {
        delete form.status;
    }
    if (form.is_verifying_otp == '2' || form.is_verifying_otp == undefined) {
      delete form.is_verifying_otp;
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
    localStorage.setItem('users_search', JSON.stringify(form));
    if (obj_params.length > 0) {
      this.clickSearch = obj_params;
      const url = this.constructUrl(obj_params);
      this.getData(url);
    } else {
      this.getData(this.url);
      this.searchForm.reset();
      this.clickSearch = undefined;
      this.currentlyCheckedStatus = undefined;
      this.currentlyCheckedVerify = undefined;
      this.searchMessage = undefined;
      localStorage.removeItem('users_search');
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
    this.currentlyCheckedVerify = undefined;
    this.searchMessage = undefined;
    this.getData(this.url);
    localStorage.removeItem('users_search');
    this.searchForm.reset();
  }

  // pagination change function
  pageChanged(page) {
    this.currentPageNumber = page.page;
    let url = this.clickSearch === undefined ? this.url + '?page=' + this.currentPageNumber : this.url + '?' + this.clickSearch + '&page=' + this.currentPageNumber;
    this.getData(url);
  }

  // open model
  openModal(type, id?) {
    this.requestType = type;
    this.idObject = id;
    this.modalForm.reset();
    if (type === 'add') {
      this.getImageProfile(type);
    } else {
      this.isModalShown = true;
    }
  }

  // get image profile
  getImageProfile (type) {
    this.requestService.getData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.users.getImageProfile}`).subscribe((item) => {
      this.imagePath = item['url'];
      this.imageValue = undefined;
      this.editImagePath = undefined;
      if (this.isSuperAdmin == 'true') {
        this.passwordsGroup.get('password').setValidators([Validators.required, Validators.minLength(8)]);
        this.passwordsGroup.get('password_confirmation').setValidators([Validators.required, Validators.minLength(8)]);
        this.passwordsGroup.updateValueAndValidity();
      }
      this.getMaritalList();
    }, (error) => {
      this.requestService.StatusCode(error);
    })
  }

  // open Emergency Contacts modal
  openButtonsModal (type, data) {
    this.requestType = type;
    this.idObject = data.id;
    this.requestService.getData(`${this.url}/${data.id}`).subscribe((items) => {
      this.counts = items[0];
      this.isModalShown = true;
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }

  // get users for show or edit
  openModalWithClass(type, id?) {
    this.modalForm.reset();
    this.requestType = type;
    this.idObject = id;
    this.imageValue = undefined;
    this.requestService.getData(`${this.url}/${id}`).subscribe((item) => {
      let data = item[0];
      this.viewUsersData = data;
      if (this.isSuperAdmin == 'true') {
        this.passwordsGroup.get('password').setValidators([Validators.minLength(8)]);
        this.passwordsGroup.get('password_confirmation').setValidators([Validators.minLength(8)]);
        this.passwordsGroup.updateValueAndValidity();
      }
      if (type === 'edit') {
        this.getMaritalList();
        this.modalForm.patchValue({
          first_name: data['first_name'],
          last_name: data['last_name'],
          nickname: data['nickname'],
          birthday: data['birthday'],
          phone: data['phone'],
          location: data['location'] == null ? data['location'] : '',
          is_verifying_otp: data['is_verifying_otp'],
          check_police: data['check_police'],
          status: data['status'],
        });
      } else if (type === 'view') {
        this.isModalShown = true;
      }
      this.editImagePath =  data.image.url;
      this.isModalShown = true;
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }

  // get Marital list
  getMaritalList () {
    this.requestService.getData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.users.maritalStatusList}`).subscribe((items) => {
      this.maritalList = items;
      for (let i in items) {
        if (this.viewUsersData && this.requestType == 'edit') {
          if (this.viewUsersData.marital_status === items[i]['label']) {
            this.modalForm.patchValue({marital_status: items[i]['type']});
          }
        } else {
          this.modalForm.patchValue({marital_status: -1});
        }
      }
      this.isModalShown = true;
    }, (error) => {
      this.requestService.StatusCode(error);
    })
  }

  // delete user data
  delete() {
    this.requestService.delete(`${this.url}`, this.idObject).subscribe(res => {
      let search = JSON.parse(localStorage.getItem('users_search'));
      if(search) {
        this.searchRefresh(search);
      } else {
        this.getData(`${this.constructUrl()}`)
      }
      this.autoShownModal.hide();
      this.alertService.success(res['message']);
    }, error => {
      this.requestService.StatusCode(error);
    });
  }

  // send create or edit request
  formSubmit(value) {
    value.status = value.status ? 1 : 0;
    value.is_verifying_otp = value.is_verifying_otp ? 1 : 0;
    value.check_police = value.check_police ? 1 : 0;
    let newValue = new FormData();
    let convertedStartDate = new Date(value.birthday);
    let month = (+convertedStartDate.getMonth() + 1) < 10 ? '0' + (convertedStartDate.getMonth() + 1) : convertedStartDate.getMonth() + 1;
    let day = (+convertedStartDate.getDate()) < 10 ? '0' + (convertedStartDate.getDate()) : convertedStartDate.getDate();
    let year = convertedStartDate.getFullYear();
    let shortStartDate = day  + "/" + month + "/" + year;
    newValue.append('status', value.status);
    newValue.append('first_name', value.first_name);
    newValue.append('last_name', value.last_name);
    newValue.append('nickname', value.nickname == null ? '' : value.nickname);
    newValue.append('marital_status', value.marital_status);
    newValue.append('birthday', shortStartDate);
    newValue.append('phone', value.phone);
    newValue.append('location', value.location == null ? '' : value.location);
    newValue.append('is_verifying_otp', value.is_verifying_otp);
    newValue.append('check_police', value.check_police);
    if (value.passwordsGroup.password) {
      newValue.append('password', value.passwordsGroup.password);
      newValue.append('password_confirmation', value.passwordsGroup.password_confirmation);
    } else {
      newValue.delete('password');
      newValue.delete('password_confirmation');
    }
    if (value.image) {
      newValue.append('image', this.image);
    } else {
      newValue.delete('image');
    }
    if (this.requestType === 'add') {
      this.addItem(newValue);
    } else if (this.requestType === 'edit') {
      this.editItemData(newValue, this.idObject);
    }
  }

  // edit user id data
  editItemData(value, id) {
    value.append('_method', 'PUT');
    this.requestService.createData(this.url + '/' + id, value, false).subscribe((item) => {
      this.autoShownModal.hide();
      let search = JSON.parse(localStorage.getItem('users_search'));
      if(search) {
        this.searchRefresh(search);
      } else {
        this.getData(`${this.constructUrl()}`)
      }
      if (id == localStorage.getItem('id')) {
        this.getAuthUser(id);
      }
      this.alertService.success(item['message']);
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }

  // user add
  addItem(value) {
    this.requestService.createData(this.url, value, false).subscribe((item) => {
      this.autoShownModal.hide();
      let search = JSON.parse(localStorage.getItem('users_search'));
      if(search) {
        this.searchRefresh(search);
      } else {
        this.getData(`${this.constructUrl()}`)
      }
      this.alertService.success(item['message']);
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }

  // check passwords
  checkPasswords(group: FormGroup) {
    let pass = group.controls.password.value;
    let confirmPass = group.controls.password_confirmation.value;
    if ((pass == '' && confirmPass == null) || (confirmPass == '' && pass == null)) {
      pass = confirmPass;
    }

    return pass === confirmPass ? null : {notSame: true};

  }

  // file upload funtion
  fileUpload(e) {
    if (e.target.files[0]) {
      const fileName = e.target.files[0].name;
      if (/\.(jpe?g|png|bmp)$/i.test(fileName)) {
        const filesize = e.target.files[0].size;
        if (filesize > 15728640) {
          this.imageValue = undefined;
          this.modalForm.get('image').setErrors({size: 'Image max size 1mb'})
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

  // get user item
  getAuthUser(id) {
    this.requestService.getData(`${this.url}/${id}`).subscribe((response) => {
      let data = response[0];
      localStorage.setItem('name', data.name);
      localStorage.setItem('image', data.image.path);
      this.requestService.userInfo.name = data.name;
      this.requestService.userInfo.image = data.image.path;
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }

  // called when modal is closing
  onHidden(): void {
    this.isModalShown = false;
    this.modalForm.reset();
    this.emergency.reset();
    this.passwordsGroup.reset();
    this.passwordsGroup.get('password').clearValidators();
    this.passwordsGroup.get('password_confirmation').clearValidators();
    this.imageValue = undefined;
    this.editImagePath = undefined;
    this.modalForm.removeControl('remove_image');
  }

  // create emergency service
  createUserDetail (value) {
    let formData = {};
    let url = this.requestType === 'emergency-service' ? `${environment.endpoint}${this.requestService.activeCountryCode}${environment.users.addDetail}` :
              this.requestType === 'emergency-contact' ? `${environment.endpoint}${this.requestService.activeCountryCode}${environment.users.emergencyContacts}` : '';
    if (this.requestType == 'emergency-service') {
        formData['emergency_service_id'] = value.value;
      this.addUserDetail(`${url}/${this.idObject}`, formData, value);
    }
    else if (this.requestType == 'emergency-contact') {
      this.addUserDetail(`${url}/${this.idObject}`, value.value, value);
    }
  }

  // open user detail
  openUserDetail (type, id) {
    this.idObject = id;
    let url = type === 'emergency-service' ? `${environment.endpoint}${this.requestService.activeCountryCode}${environment.users.emergencyServiceList}` :
              type === 'emergency-contact' ? `${environment.endpoint}${this.requestService.activeCountryCode}${environment.users.getEmergencyContacts}` : '';

    let listUrl =
      type === 'emergency-service' ? `${environment.endpoint}${this.requestService.activeCountryCode}${environment.users.emergencyServiceSelectedList}` :
        type === 'emergency-contact' ? `${environment.endpoint}${this.requestService.activeCountryCode}${environment.users.getEmergencyContacts}` : '';
    forkJoin(
      this.requestService.getData(`${url}/${id}`).pipe(catchError(error => of(error))),
      this.requestService.getData(`${listUrl}/${id}`).pipe(catchError(error => of(error)))
    ).subscribe(([items1, items2]) => {
      this.selectedList = items1;
      this.userDetail = items2;
      this.requestType = type;
      this.isModalShown = true;
    }, ([error1, error2]) => {
      this.requestService.StatusCode(error1);
      this.requestService.StatusCode(error2)
    });
  }

  // delete user detail
  deleteUserDetail (id) {
    let url = this.requestType === 'emergency-service' ? `${environment.endpoint}${this.requestService.activeCountryCode}${environment.users.deleteDetail}` :
              this.requestType === 'emergency-contact' ? `${environment.endpoint}${this.requestService.activeCountryCode}${environment.users.deleteEmergencyContacts}` : '';
    this.requestService.delete(url, `${this.idObject}/${id}`).subscribe((item) => {
      this.openUserDetail (this.requestType, this.idObject);
      this.alertService.success(item['message']);
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }

  // open Records modal
  getRecords (type, id) {
    this.requestType = type;
    this.idObject = id;
    this.requestService.getData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.users.getRecords}/${id}`).subscribe((item) => {
      this.records = item;
      this.isModalShown = true;
    }, (error) => {
      this.requestService.StatusCode(error);
    })
  }

  // delete records
  deleteRecords (id) {
    this.requestService.delete(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.users.records}/${this.idObject}`, id).subscribe((item) => {
      this.getRecords (this.requestType, this.idObject);
      this.alertService.success(item['message']);
    }, (error) => {
      this.requestService.StatusCode(error);
    })

  }

  // create user detail
  addUserDetail (url, value, object) {
    this.requestService.createData(url, value).subscribe((item) => {
      this.openUserDetail (this.requestType, this.idObject);
      this.alertService.success(item['message']);
      object.reset();
    }, (error) => {
      this.requestService.StatusCode(error);
    })
  }

  // open Change to Consultant modal
  getConsultant (type, id) {
    this.requestType = type;
    this.idObject = id;
    this.requestService.getData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.users.getConsultantList}`).subscribe((item) => {
      this.consultant = item;
      this.isModalShown = true;
    }, (error) => {
      this.requestService.StatusCode(error);
    })
  }

  // add consultant
  addToConsultant (value) {
    let obj = {
      consultant_category_id: value.value,
      email: this.emailForm.value.email
    };
    this.requestService.createData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.users.changeConsultant}/${this.idObject}`, obj).subscribe((item) => {
      let search = JSON.parse(localStorage.getItem('users_search'));
      if(search) {
        this.search(search);
      } else {
        this.getData(`${this.constructUrl()}`)
      }
      this.autoShownModal.hide();
      this.emailForm.reset();
      value.reset();
      this.alertService.success(item['message']);
    }, (error) => {
      this.requestService.StatusCode(error);
    })
  }
}
