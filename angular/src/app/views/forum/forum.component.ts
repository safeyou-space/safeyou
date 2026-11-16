import {Component, OnInit, ViewChild} from '@angular/core';
import {BsModalService, ModalDirective} from "ngx-bootstrap";
import {environment} from "../../../environments/environment.prod";
import {FormBuilder, FormGroup, Validators} from "@angular/forms";
import {AlertService} from "ngx-alerts";
import {RequestService} from "../../shared/Service/request.service";
import {ActivatedRoute} from "@angular/router";
enum CheckBoxTypeStatus { Inactive, Active, NONE }

@Component({
  selector: 'app-forum',
  templateUrl: './forum.component.html',
  styleUrls: ['./forum.component.scss']
})
export class ForumComponent implements OnInit {

  @ViewChild('childModal') childModal: ModalDirective;
  url: any;
  tableData;
  totalItems;
  current_page = 1;
  objectKeys = Object.keys;
  viewData;
  requestType;
  id;
  imageValue: any;
  editImagePath: any;
  img;
  languageTranslations: any;

  modalForm = this.fb.group({
    translations: this.fb.group({}),
    image: [''],
    status: ['']
  });
  searchForm = this.fb.group({
    title: ['', Validators.maxLength(70)],
    sub_title: ['', Validators.maxLength(70)],
    description: ['', Validators.maxLength(70)],
    short_description: ['', Validators.maxLength(70)],
    status: [''],
  });

  titleKeys: any = {
    title: 'Title',
    sub_title: 'Sub Title',
    description: 'Description',
    short_description: 'Short Description',
  };
  imagePath: any;
  access: any = ['create', 'view', 'edit', 'delete'];
  clickSearch;
  currentPageNumber = 1;
  searchMessage;
  check_box_typeStatus = CheckBoxTypeStatus;
  currentlyCheckedStatus: CheckBoxTypeStatus;

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
    if (localStorage.getItem('access')) {
      this.access = JSON.parse(localStorage.getItem('access'))['forum'] ? JSON.parse(localStorage.getItem('access'))['forum'] : [];
    }
    this.url = `${environment.endpoint}${this.requestService.activeCountryCode}${environment.forum.get}`;
    let searchData = JSON.parse(localStorage.getItem('forum_search'));
    if (searchData) {
      this.clickSearch = true;
      this.searchMessage = 'Search result';
      this.searchForm.patchValue({
        title: searchData['title'],
        sub_title: searchData['sub_title'],
        description: searchData['description'],
        short_description: searchData['short_description'],
      });
      this.currentlyCheckedStatus = searchData['status'];
      this.searchRefresh(searchData)
    } else {
      this.getData(this.url);
    }
  }

  // get forum list
  getData(url) {
    this.requestService.getData(url).subscribe(res => {
      this.tableData = res['data'] ? res['data'] : res;
      this.requestService.paginationConfig.totalItems = !res['message'] ? res['total'] : 0;
      this.requestService.paginationConfig.perPage = !res['message'] ? res['per_page'] : 0;
    }, error => {
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

  // open search layout
  openLayout() {
    let element = document.getElementById("div");
    if(document.querySelector(".ui-theme-settings").classList.contains("settings-open")) {
      element.classList.remove("settings-open");
    } else {
      element.classList.add("settings-open");
    }
  }

  // search forum
  search(form) {
    this.currentPageNumber = 1;
    this.requestService.paginationConfig.totalItems =  0;
    this.requestService.paginationConfig.perPage =  0;
    form.status = this.currentlyCheckedStatus;
    if (form.status == '2' || form.status == undefined) {
      delete form.status;
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
    localStorage.setItem('forum_search', JSON.stringify(form));
    if (obj_params.length > 0) {
      this.clickSearch = obj_params;
      const url = this.constructUrl(obj_params);
      this.getData(url);
    } else {
      this.getData(this.url);
      this.searchForm.reset();
      this.clickSearch = undefined;
      this.currentlyCheckedStatus = undefined;
      this.searchMessage = undefined;
      localStorage.removeItem('forum_search');
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
    this.searchMessage = undefined;
    this.getData(this.url);
    localStorage.removeItem('forum_search');
    this.searchForm.reset();
  }

  // pagination change function
  pageChanged(page) {
    this.currentPageNumber = page.page;
    let url = this.clickSearch === undefined ? this.url + '?page=' + this.currentPageNumber : this.url + '?' + this.clickSearch + '&page=' + this.currentPageNumber;
    this.getData(url);
  }

  // get forum for show or edit
  showModal(type, id?) {
    if (type === 'view') {
      this.requestService.getData(`${this.url}/` + id).subscribe(res => {
        this.showChildModal();
        this.viewData = res[0];
        this.requestType = type;
      }, (error) => {
        this.requestService.StatusCode(error);
      });
    }  else if (type === 'edit') {
      this.requestService.getData(`${this.url}/` + id).subscribe(res => {
        this.viewData = res[0];
        let data  = res[0];
        this.editImagePath = this.viewData.image ? this.viewData.image.url : '';
        let trans = {};
        for (let key in data['translations']) {
          trans[data['translations'][key]['language']['code']] = {
            title: data['translations'][key].title,
            sub_title: data['translations'][key].sub_title,
            description: data['translations'][key].description,
            short_description: data['translations'][key].short_description,
          }
        }
        this.modalForm.patchValue({
          status: data.status
        });
        this.id = id;
        this.requestType = type;
        this.getLanguageList(type, trans);
        this.modalForm.get('image').clearValidators();
        this.modalForm.get('image').updateValueAndValidity();
      }, (error) => {
        this.requestService.StatusCode(error);
      });
      this.requestType = type;
    } else if (type === 'delete') {
      this.id = id;
      this.showChildModal();
      this.requestType = type;
    } else if (type == 'add') {
      this.getImageProfile(type);
    }
  }

  // get image profile data
  getImageProfile (type) {
    this.requestService.getData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.forum.getImageProfile}`).subscribe((item) => {
      this.imagePath = item['url'];
      this.modalForm.reset();
      this.getLanguageList(type);
      this.requestType = type;
      this.modalForm.get('image').setValidators([Validators.required]);
      this.modalForm.get('image').updateValueAndValidity();
    }, (error) => {
      this.requestService.StatusCode(error);
    })
  }

  // send create or edit request
  formSubmit(form) {
    form['status'] = form['status'] ? 1 : 0;
    let data = new FormData();
    for (let key in form) {
      if (key == 'image') {
        if (form['image']) {
          data.append(key, this.img);
        }
      } else if (key == 'translations') {
        for (let item in form['translations']) {
          for (let res in form['translations'][item]) {
            data.append(`translations[${res}][${item}]`, form['translations'][item][res]);
          }
        }

      } else {
        data.append(key, form[key]);
      }
    }

    if (this.requestType == 'add') {
      this.requestService.createData(`${this.url}`, data, false).subscribe(res => {
        let search = JSON.parse(localStorage.getItem('forum_search'));
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
      data.append('_method', 'PUT');
      this.requestService.createData(`${this.url}/${this.id}`, data, false).subscribe(res => {
        this.hideChildModal();
        let search = JSON.parse(localStorage.getItem('forum_search'));
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

  // forum delete function
  delete() {
    this.requestService.delete(`${this.url}`, this.id).subscribe(res => {
      this.hideChildModal();
      let search = JSON.parse(localStorage.getItem('forum_search'));
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

  // file change function
  onFileChanged(event) {
    if (event.target.files[0]) {
      this.img = event.target.files[0];
      let file = event.target.files[0];
      let _this = this;
      let reader = new FileReader();
      reader.onloadend = function () {
        _this.imageValue = reader.result;
      };
      reader.readAsDataURL(file);
    } else {
      this.imageValue = undefined;
      this.img = undefined;
    }

  }


  // get language list
  getLanguageList (type, value?) {
    this.requestService.getData(`${environment.endpoint}${this.requestService.activeCountryCode}${environment.emergencyServiceCategory.getLanguageList}`).subscribe((item: any) => {
      let data = item;
      this.languageTranslations = item;
      let translations = this.modalForm.get('translations') as FormGroup;
      for (let j in this.titleKeys) {
        let a = {};
        for (let i = 0; i < data.length; i++) {
          let str = '';
          if (value) {
            str = value[data[i]['code']] ? value[data[i]['code']][j] : ''
          }
          a[data[i]['code']] = [str, Validators.compose([Validators.required, Validators.minLength(3)])];
        }
        translations.setControl(j, this.fb.group(a));
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
    setTimeout(() => {
      this.modalForm.reset();
      this.childModal.hide();
      this.modalForm = this.fb.group({
        translations: this.fb.group({}),
        image: [''],
        status: ['']
      });
    }, 10);
  }

}
