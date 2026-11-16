import {Component, OnInit, ViewChild} from '@angular/core';
import {BsModalService, ModalDirective} from "ngx-bootstrap";
import {FormBuilder, FormGroup, Validators} from "@angular/forms";
import {AlertService} from "ngx-alerts";
import {ActivatedRoute} from "@angular/router";
import {RequestService} from "../../../shared/Service/request.service";
import {environment} from "../../../../environments/environment.prod";
import {forkJoin} from "rxjs";
enum CheckBoxTypeStatus { Inactive, Active, Blocked, NONE }
enum CheckBoxTypeVerify { No, Yes, NONE }

@Component({
  selector: 'app-consultants',
  templateUrl: './consultants.component.html',
  styleUrls: ['./consultants.component.scss']
})
export class ConsultantsComponent implements OnInit {

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
    location: [''],
    consultant_category_id: [null, Validators.required],
    is_verifying_otp: [''],
    check_police: [''],
    image: [''],
    marital_status: [''],
    passwordsGroup: this.passwordsGroup,
    status: [true]
  });
  emergency = this.fb.group({
    name: ['', Validators.compose([Validators.required])],
    phone: ['', Validators.compose([Validators.required])]
  });
  searchForm = this.fb.group({
    consultant_category_id: [null],
    first_name: ['', Validators.maxLength(70)],
    last_name: ['', Validators.maxLength(70)],
    phone: ['', Validators.maxLength(70)],
    location: ['', Validators.maxLength(70)],
    nickname: ['', Validators.maxLength(70)],
    status: [''],
    is_verifying_otp: [''],
  });
  viewUsersData: any;
  imageValue: any;
  editImagePath: any;
  records: any;
  imagePath: any;
  counts: any;
  consultantCategoryList: any = [];
  isSuperAdmin: any;

  clickSearch;
  currentPageNumber = 1;

  searchMessage;
  check_box_typeStatus = CheckBoxTypeStatus;
  currentlyCheckedStatus: CheckBoxTypeStatus;

  check_box_typeVerify = CheckBoxTypeVerify;
  currentlyCheckedVerify: CheckBoxTypeVerify;

  constructor(
    private alertService: AlertService,
    private fb: FormBuilder,
    private modalService: BsModalService,
    public activeRoute: ActivatedRoute,
    public requestService: RequestService) {
    this.requestService.activeCountryCode = this.activeRoute.snapshot.params['code'];  }

  ngOnInit() {
    this.isSuperAdmin = localStorage.getItem('is_super_admin');
    this.url = `${environment.endpoint}${this.requestService.activeCountryCode}${environment.consultants.get}`;
    let searchData = JSON.parse(localStorage.getItem('consultants_search'));
    if (searchData) {
      this.clickSearch = true;
      this.searchMessage = 'Search result';
      this.searchForm.patchValue({
        first_name: searchData['first_name'],
        last_name: searchData['last_name'],
        phone: searchData['phone'],
        location: searchData['location'],
        nickname: searchData['nickname'],
        consultant_category_id: searchData['consultant_category_id'],
      });
      this.currentlyCheckedStatus = searchData['status'];
      this.currentlyCheckedVerify = searchData['is_verifying_otp'];
      this.searchRefresh(searchData)
    } else {
      this.getData(this.url);
    }
  }

  // get all consultants table data
  getData(url) {
    this.requestService.getData(url).subscribe((items) => {
      this.usersData = items['data'] ? items['data'] : items;
      this.requestService.paginationConfig.totalItems = !items['message'] ? items['total'] : 0;
      this.requestService.paginationConfig.perPage = !items['message'] ? items['per_page'] : 0;
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }

  //change checkbox status
  selectCheckBox(targetType: CheckBoxTypeStatus) {
    if(this.currentlyCheckedStatus === targetType) {
      this.currentlyCheckedStatus = CheckBoxTypeStatus.NONE;
      return;
    }

    this.currentlyCheckedStatus = targetType;
  }

  //change checkbox status
  selectCheckBoxVerify(targetType: CheckBoxTypeVerify) {
    if(this.currentlyCheckedVerify === targetType) {
      this.currentlyCheckedVerify = CheckBoxTypeVerify.NONE;
      return;
    }

    this.currentlyCheckedVerify = targetType;
  }

  // open search block
  openLayout() {
    let element = document.getElementById("div");
    if(document.querySelector(".ui-theme-settings").classList.contains("settings-open")) {
      element.classList.remove("settings-open");
    } else {
      element.classList.add("settings-open");
      this.requestService.getData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.consultants.getConsultantCategoryList}`).subscribe((item) => {
        this.consultantCategoryList.splice(0);
        for (let i in item) {
          this.consultantCategoryList.push({
            id: i,
            value: item[i]
          });
        }
      }, (error) => {
        this.requestService.StatusCode(error);
      })
    }
  }

  // send search request
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
    localStorage.setItem('consultants_search', JSON.stringify(form));
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
      localStorage.removeItem('consultants_search');
    }
  }

  // update search parameters
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

  // clear  search parameters
  searchReset() {
    this.currentPageNumber = 1;
    this.requestService.paginationConfig.totalItems =  0;
    this.requestService.paginationConfig.perPage =  0;
    this.clickSearch = undefined;
    this.currentlyCheckedStatus = undefined;
    this.currentlyCheckedVerify = undefined;
    this.searchMessage = undefined;
    this.getData(this.url);
    localStorage.removeItem('consultants_search');
    this.searchForm.reset();
  }

  // pagination change function
  pageChanged(page) {
    this.currentPageNumber = page.page;
    let url = this.clickSearch === undefined ? this.url + '?page=' + this.currentPageNumber : this.url + '?' + this.clickSearch + '&page=' + this.currentPageNumber;
    this.getData(url);
  }

  // open add modal
  openModal(type, id?) {
    this.requestType = type;
    this.idObject = id;
    this.modalForm.reset();
    if (type === 'add') {
      this.getDefaultImage(type);
    } else {
      this.isModalShown = true;
    }
  }

  // get default consultant image
  getDefaultImage (type) {
    this.requestService.getData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.consultants.getImageProfile}`).subscribe((item) => {
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

  // open edit or view modal
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
          location: data['location'],
          consultant_category_id: data['consultant_category_id'],
          is_verifying_otp: data['is_verifying_otp'],
          check_police: data['check_police'],
          status: data['status'],
        });
      } else if (type === 'view') {
        this.isModalShown = true;
      }
      this.editImagePath =  data.image ? data.image.url : '';
      this.isModalShown = true;
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }

  // get Marital Status list
  getMaritalList () {
    return new Promise((res) => {
      forkJoin(
        this.requestService.getData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.consultants.maritalStatusList}`),
        this.requestService.getData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.consultants.getConsultantCategoryList}`),
      ).subscribe(([response1, response2] : any) => {
        if (!response1['message']) {
          this.maritalList = response1;
          for (let i in response1) {
            if (this.viewUsersData && this.requestType == 'edit') {
              if (this.viewUsersData.marital_status === response1[i]['label']) {
                this.modalForm.patchValue({marital_status: response1[i]['type']});
              }
            } else {
              this.modalForm.patchValue({marital_status: -1});
            }
          }
        }
        if (!response2['message']) {
          this.consultantCategoryList.splice(0);
          for (let i in response2) {
            this.consultantCategoryList.push({
              id: i,
              value: response2[i]
            });
          }
        }
        this.isModalShown = true;
        res();
      }, (error) => {
        this.requestService.StatusCode(error);
        res();
      });
    });
  }

  // delete consultant function
  delete() {
    this.requestService.delete(`${this.url}`, this.idObject).subscribe(res => {
      let search = JSON.parse(localStorage.getItem('consultants_search'));
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
    newValue.append('location', value.location == null ? '' : value.location);
    newValue.append('marital_status', value.marital_status);
    newValue.append('consultant_category_id', value.consultant_category_id);
    newValue.append('birthday', shortStartDate);
    newValue.append('phone', value.phone);
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

  // send edit request
  editItemData(value, id) {
    value.append('_method', 'PUT');
    this.requestService.createData(this.url + '/' + id, value, false).subscribe((item) => {
      this.autoShownModal.hide();
      let search = JSON.parse(localStorage.getItem('consultants_search'))
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

  // send add request
  addItem(value) {
    this.requestService.createData(this.url, value, false).subscribe((item) => {
      this.autoShownModal.hide();
      let search = JSON.parse(localStorage.getItem('consultants_search'));
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

  // change consultant status
  reject (value) {
    let Obj = {
      status: value
    };
    this.requestService.createData(this.url + '/reject/' + this.idObject, Obj).subscribe(res => {
      this.autoShownModal.hide();
      let search = JSON.parse(localStorage.getItem('consultants_search'));
      if(search) {
        this.search(search);
      } else {
        this.getData(`${this.constructUrl()}`)
      }
      this.alertService.success(res['message']);
    }, error => {
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

}
