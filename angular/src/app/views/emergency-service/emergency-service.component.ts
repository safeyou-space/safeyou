import {Component, OnInit, ViewChild} from '@angular/core';
import {BsModalService, ModalDirective} from "ngx-bootstrap";
import {FormArray, FormBuilder, FormGroup, Validators} from "@angular/forms";
import {AlertService} from "ngx-alerts";
import {ActivatedRoute} from "@angular/router";
import {RequestService} from "../../shared/Service/request.service";
import {environment} from "../../../environments/environment.prod";
import {forkJoin} from "rxjs";
enum CheckBoxTypeStatus { Inactive, Active, Blocked, NONE }
enum CheckBoxTypeSms { No, Yes, NONE }

@Component({
  selector: 'app-emergency-service',
  templateUrl: './emergency-service.component.html',
  styleUrls: ['./emergency-service.component.scss']
})
export class EmergencyServiceComponent implements OnInit {

  @ViewChild('childModal') childModal: ModalDirective;
  @ViewChild('secondModal') secondModal: ModalDirective;
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
  emergencyCategoryList: any = [];

  passwordsGroup = this.fb.group({
    password: [''],
    confirm_password: [''],
  }, {validator: this.checkPasswords});
  modalForm = this.fb.group({
    title: ['', Validators.compose([Validators.required, Validators.minLength(1)])],
    description: ['', Validators.compose([Validators.required, Validators.minLength(3)])],
    location: ['', Validators.compose([Validators.required, Validators.minLength(3)])],
    latitudeAndLongitude: ['', Validators.compose([Validators.required,
      Validators.pattern(this.requestService.patterns.latitudeAndLongitude)])],
    email: ['', Validators.compose([
      Validators.required,
      Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/)
    ])],
    phone: ['', Validators.compose([Validators.required, Validators.minLength(1), Validators.pattern(this.requestService.patterns.phone)])],
    web_address: ['', Validators.compose([Validators.minLength(1), Validators.pattern(this.requestService.patterns.url)])],
    address: ['', Validators.compose([Validators.minLength(6)])],
    emergency_service_category: [null, Validators.required],
    social_links: this.fb.group({}),
    image: [''],
    passwordsGroup: this.passwordsGroup,
    status: [''],
    is_send_sms: ['']
  });

  socialForm = this.fb.group({});
  searchForm = this.fb.group({
    title: ['', Validators.maxLength(70)],
    description: ['', Validators.maxLength(70)],
    email: ['', Validators.maxLength(70)],
    phone: ['', Validators.maxLength(70)],
    address: ['', Validators.maxLength(70)],
    emergency_service_category_id: [null],
    status: [''],
    is_send_sms: [''],
  });
  socialImages: any = [];
  socialImagespath: any = [];
  selectedSocilLinks: any = [];
  viewUsersData: any;
  imagePath: any;
  isSuperAdmin: any;
  clickSearch;
  currentPageNumber = 1;
  selectedSocialIcons: any = [];
  searchMessage;
  check_box_typeStatus = CheckBoxTypeStatus;
  currentlyCheckedStatus: CheckBoxTypeStatus;

  check_box_typeSms = CheckBoxTypeSms;
  currentlyCheckedSms: CheckBoxTypeSms;
  secondModalType: any;
  index: any;

  // get translations forms values and methods
  get translationsForm() {
    return this.modalForm.get('translations') as FormArray;
  }
  // get Social form values and methods
  get getSocialForm () {
    return this.socialForm as FormGroup
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
    this.isSuperAdmin = localStorage.getItem('is_super_admin');
    this.url = `${environment.endpoint}${this.requestService.activeCountryCode}${environment.emergencyService.get}`;
    let searchData = JSON.parse(localStorage.getItem('emergency_search'));
    if (searchData) {
      this.clickSearch = true;
      this.searchMessage = 'Search result';
      this.searchForm.patchValue({
        title: searchData['title'],
        description: searchData['description'],
        email: searchData['email'],
        phone: searchData['phone'],
        address: searchData['address'],
        emergency_service_category_id: searchData['emergency_service_category_id'],
      });
      this.currentlyCheckedStatus = searchData['status'];
      this.currentlyCheckedSms = searchData['is_send_sms'];
      this.searchRefresh(searchData)
    } else {
      this.getData(this.url);
    }
  }

  // get all emergency table data
  getData(url) {
    this.requestService.getData(url).subscribe(res => {
      this.tableData = res['data'] ? res['data'] : res;
      this.requestService.paginationConfig.totalItems = !res['message'] ? res['total'] : 0;
      this.requestService.paginationConfig.perPage = !res['message'] ? res['per_page'] : 0;
    }, error => {
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
  selectCheckBoxSms(targetType: CheckBoxTypeSms) {
    if(this.currentlyCheckedSms === targetType) {
      this.currentlyCheckedSms = CheckBoxTypeSms.NONE;
      return;
    }

    this.currentlyCheckedSms = targetType;
  }

  // open search block
  openLayout() {
    let element = document.getElementById("div");
    if(document.querySelector(".ui-theme-settings").classList.contains("settings-open")) {
      element.classList.remove("settings-open");
    } else {
      this.requestService.getData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.emergencyService.emergencyServiceCategoryList}`).subscribe(item => {
        this.emergencyCategoryList.splice(0);
        for (let i in item) {
          this.emergencyCategoryList.push({
            id: i,
            value: item[i]
          });
        }
      }, error => {
        this.requestService.StatusCode(error);
      });
      element.classList.add("settings-open");
    }
  }

  // send search request
  search(form) {
    this.currentPageNumber = 1;
    this.requestService.paginationConfig.totalItems =  0;
    this.requestService.paginationConfig.perPage =  0;
    form.status = this.currentlyCheckedStatus;
    form.is_send_sms = this.currentlyCheckedSms;
    if (form.status == '3' || form.status == undefined) {
      delete form.status;
    }
    if (form.is_send_sms == '2' || form.is_send_sms == undefined) {
      delete form.is_send_sms;
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
    localStorage.setItem('emergency_search', JSON.stringify(form));
    if (obj_params.length > 0) {
      this.clickSearch = obj_params;
      const url = this.constructUrl(obj_params);
      this.getData(url);
    } else {
      this.getData(this.url);
      this.searchForm.reset();
      this.clickSearch = undefined;
      this.currentlyCheckedStatus = undefined;
      this.currentlyCheckedSms = undefined;
      this.searchMessage = undefined;
      localStorage.removeItem('emergency_search');
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
    this.currentlyCheckedSms = undefined;
    this.searchMessage = undefined;
    this.getData(this.url);
    localStorage.removeItem('emergency_search');
    this.searchForm.reset();
  }

  // pagination change function
  pageChanged(page) {
    this.currentPageNumber = page.page;
    let url = this.clickSearch === undefined ? this.url + '?page=' + this.currentPageNumber : this.url + '?' + this.clickSearch + '&page=' + this.currentPageNumber;
    this.getData(url);
  }

  // open view delete add and edit modal
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
      this.requestService.getData(`${this.url}/` + id).subscribe((res): any => {
        this.modalForm.reset();
        this.viewData = res[0];
        let data = res[0];
        this.selectedSocialIcons.splice(0);
        for (let i = 0; i < data.social_links.length; i++) {
          this.selectedSocilLinks.push({
            title: data.social_links[i].title,
            url: data.social_links[i].url,
            icon: data.social_links[i].icon,
            name: data.social_links[i].icon,
          });
          this.selectedSocialIcons.push(data.social_links[i].icon);
        }
        this.editImagePath =  data.user_detail.image ? data.user_detail.image.url: '';
        this.modalForm.patchValue({
          title: data.title,
          description: data.description,
          location: data.user_detail.location,
          latitudeAndLongitude: `${data.latitude}, ${data.longitude}`,
          email: data.user_detail.email,
          phone: data.user_detail.phone,
          web_address: data.web_address,
          address: data.address,
          emergency_service_category: data.emergency_service_category_id,
          status: data.status,
          is_send_sms: data.is_send_sms
        });
        this.getList(type);
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
      this.getList(type);
    }
  }

  // send create or edit request
  formSubmit(form) {
    form.is_send_sms = form.is_send_sms ? 1 : 0;
    form.status = form.status ? 1 : 0;
    form.address == null ? '' : form.address;
    let newData = {};
    let formData = new FormData();
    for (let i in form) {
      if (form[i] == null) {
        form[i] = '';
      }
      if (i == 'latitudeAndLongitude') {
        newData['latitude'] = form.latitudeAndLongitude.split(',')[0].trim();
        newData['longitude'] = form.latitudeAndLongitude.split(',')[1].trim();
      } else  if (i == 'social_links') {
        let socialLink = {};
        for (let i = 0; i < this.selectedSocilLinks.length; i++) {
          socialLink[i] = this.selectedSocilLinks[i];
        }
        if (this.selectedSocilLinks.length) {
          newData['social_links'] = socialLink;
        }
      } else  if (i == 'passwordsGroup') {
        if (form.passwordsGroup.password) {
          newData['password'] = form.passwordsGroup.password;
          newData['confirm_password'] = form.passwordsGroup.confirm_password;
        }
      }else {
        newData[i] = form[i];
      }
    }
    for (let i in newData) {
      if (i == 'image') {
        if (newData['image']) {
          formData.append('image', this.img);
        }
      } else if (i == 'social_links') {
        for (let j in newData['social_links']) {
          for (let k in newData['social_links'][j]) {
            formData.append('social_links['+ j +']['+ k +']', newData['social_links'][j][k]);
          }
        }
      } else {
        formData.append(i, newData[i]);
      }
    }
    if (this.requestType == 'add') {
      this.requestService.createData(`${this.url}`, formData, false).subscribe(res => {
        let search = JSON.parse(localStorage.getItem('emergency_search'));
        if(search) {
          this.searchRefresh(search);
        } else {
          this.getData(`${this.constructUrl()}`)
        }
        this.hideChildModal();
        this.alertService.success(res['message']);
      }, error => {
        this.requestService.StatusCode(error);
      });
    } else if (this.requestType == 'edit') {
      formData.append('_method', 'PUT');
      this.requestService.createData(this.url+ '/' + this.id, formData).subscribe(res => {
        this.hideChildModal();
        let search = JSON.parse(localStorage.getItem('emergency_search'));
        if(search) {
          this.searchRefresh(search);
        } else {
          this.getData(`${this.constructUrl()}`)
        }
        this.alertService.success(res['message']);
      }, error => {
        this.requestService.StatusCode(error);
      });
    }
  }

  // check is password and confirm password equal
  checkPasswords(group: FormGroup) {
    let pass = group.controls.password.value;
    let confirmPass = group.controls.confirm_password.value;
    if ((pass == '' && confirmPass == null) || (confirmPass == '' && pass == null)) {
      pass = confirmPass;
    }
    return pass === confirmPass ? null : {notSame: true};
  }

  // delete emergency
  delete() {
    this.requestService.delete(`${this.url}`, this.id).subscribe(res => {
      this.hideChildModal();
      let search = JSON.parse(localStorage.getItem('emergency_search'));
      if(search) {
        this.searchRefresh(search);
      } else {
        this.getData(`${this.constructUrl()}`)
      }
      this.alertService.success(res['message']);
    }, error => {
      this.requestService.StatusCode(error);
    });
  }


  // get icons profile image and category list
  getList (type, value?) {
    return new Promise((res) => {
      forkJoin(
        this.requestService.getData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.emergencyService.getIconsList}`),
        this.requestService.getData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.emergencyService.emergencyServiceCategoryList}`),
        this.requestService.getData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.emergencyService.getImageProfile}`),
      ).subscribe(([response1, response2, response3] : any) => {
        if (!response1['message']) {
          this.socialImages.splice(0);
          this.socialImagespath = response1;
          let j = 0;
          for (let i in response1) {
            this.socialImages.push({
              name: i,
              path: response1[i]
            });
            this.getSocialForm.registerControl(j.toString(), this.fb.group({
              title: [''],
              url: ['', Validators.pattern(this.requestService.patterns.url)],
              icon: [i],
              name: [i]
            }));
            j++
          }
        }
        if (!response2['message']) {
          this.emergencyCategoryList.splice(0);
          for (let i in response2) {
            this.emergencyCategoryList.push({
              id: i,
              value: response2[i]
            });
          }
        }
        if (!response3['message'] && type === 'add') {
          this.imagePath = response3['url'];
          this.imageValue = undefined;
          this.editImagePath = undefined;
        }
        if (type == 'add') {
          this.passwordsGroup.get('password').setValidators([Validators.required, Validators.minLength(8)]);
          this.passwordsGroup.get('confirm_password').setValidators([Validators.required, Validators.minLength(8)]);
        } else if (type == 'edit' && this.isSuperAdmin == 'true') {
          this.passwordsGroup.get('password').setValidators([Validators.minLength(8)]);
          this.passwordsGroup.get('confirm_password').setValidators([Validators.minLength(8)]);
        }
        this.requestType = type;
        this.showChildModal();
        res();
      }, (error) => {
        this.requestService.StatusCode(error);
        res();
      });
    });
  }


  // add values in social form
  addSocialLinks (value, type?) {
    this.selectedSocilLinks.splice(0);
    this.selectedSocialIcons.splice(0);
    for (let i in value) {
      if (value[i].title && value[i].url) {
        this.selectedSocilLinks.push(value[i]);
        this.selectedSocialIcons.push(value[i].icon);
      }
    }
    this.secondModal.hide();
    this.socialForm.reset();
  }

  // set values social forms
  selectedList () {
    this.secondModalType = 'add';
    let j = 0;
    this.selectedSocialIcons.splice(0);
    this.socialForm = this.fb.group({});
    for (let i in  this.socialImagespath) {
      let a = true;
      for (let k = 0; k < this.selectedSocilLinks.length; k++) {
        if (i == this.selectedSocilLinks[k].icon) {
          this.getSocialForm.registerControl(j.toString(), this.fb.group({
            title: [this.selectedSocilLinks[k].title],
            url: [this.selectedSocilLinks[k].url, Validators.pattern(this.requestService.patterns.url)],
            icon: [i],
            name: [i]
          }));
          this.selectedSocialIcons.push(i);
          a = false;
        }
      }
      if (a) {
        this.getSocialForm.registerControl(j.toString(), this.fb.group({
          title: [''],
          url: ['', Validators.pattern(this.requestService.patterns.url)],
          icon: [i],
          name: [i]
        }));
      }
      j++
    }
    this.secondModal.show();
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
          this.img = e.target.files[0];
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

  // change send sms function
  isSendSms (id, value) {
    let object = {
      is_send_sms: value ? 0 : 1
    };
    this.requestService.createData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.emergencyService.isSendSms}/${id}`, object).subscribe((item) => {
      let search = JSON.parse(localStorage.getItem('emergency_search'));
      if(search) {
        this.searchRefresh(search);
      } else {
        this.getData(`${this.constructUrl()}`)
      }
      this.alertService.success(item['message']);
    }, (error) => {
      this.requestService.StatusCode(error);
    })
  }

  // called when modal is closing
  onHidden(): void {
    this.selectedSocilLinks.splice(0);
    this.selectedSocialIcons.splice(0);
    this.imageValue = undefined;
    this.editImagePath = undefined;
    this.img = undefined;
    this.modalForm.reset();
    this.passwordsGroup.reset();
    this.passwordsGroup.get('password').clearValidators();
    this.passwordsGroup.get('confirm_password').clearValidators();
    this.childModal.hide();
  }

}
