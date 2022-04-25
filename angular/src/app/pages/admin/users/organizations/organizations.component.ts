import {Component, Input, OnInit, ViewChild} from '@angular/core';
import {animate, state, style, transition, trigger} from "@angular/animations";
import {HelperService} from "../../../../shared/helper.service";
import {ModalDirective} from "ngx-bootstrap/modal";
import { FormBuilder, FormGroup, Validators} from "@angular/forms";
import {ActivatedRoute} from "@angular/router";
import {RequestService} from "../../../../shared/request.service";
import {environment} from "../../../../../environments/environment.prod";
import {DeleteModalComponent} from "../../../../components/utils/delete-modal/delete-modal.component";
import {ReportModalComponent} from "../../../../components/utils/report-modal/report-modal.component";
import {ToastrService} from "ngx-toastr";
import {LocationStrategy} from "@angular/common";
import * as customBuild from '../../../../shared/ckCustomBuild/build/ckeditor.js';
import {ChangeEvent} from "@ckeditor/ckeditor5-angular";


@Component({
  selector: 'app-organizations',
  templateUrl: './organizations.component.html',
  styleUrls: ['./organizations.component.css'],
  animations: [
    trigger('openClose', [
      // ...
      state('open', style({
        width: 590,
        opacity: 1,
        visibility: 'visible'
      })),
      state('closed', style({
        width: 0,
        opacity: 0,
        visibility: 'hidden'
      })),

      state('openButton', style({
      })),
      state('closedButton', style({
        opacity: 0,
        visibility: 'hidden'
      })),

      transition('openButton <=> closedButton', [
        animate('0.5s linear')
      ]),

      state('openAnimations', style({
      })),
      state('closedAnimations', style({
        opacity: 0,
        margin: 0,
        padding: 0,
        visibility: 'hidden'
      })),

      transition('openAnimations <=> closedAnimations', [
        animate('0.5s ease-out')
      ]),

      state('closedIf', style({
        opacity: 0,
        visibility: 'hidden',
        width: '0%',
        height: 0,
        padding: 0,
        // display: 'none'
      })),

      state('openIf', style({
        width: '14.5%'
      })),

      transition('openIf <=> closedIf', [
        animate('0.5s linear')
      ]),

      state('chatClose', style({
        visibility: 'hidden',
        opacity: 0
      })),

      state('chatOpen', style({
        opacity: 1
      })),

      transition('chatOpen <=> chatClose', [
        animate('0.5s ease-in')
      ]),

      transition('open <=> closed', [
        animate('0.6s ease-in-out')
      ]),
    ]),
    trigger('page', [
      // ...
      state('open', style({
        opacity: '1',
        visibility: 'visible',
      })),
      state('closed', style({
        opacity: 0,
        visibility: 'hidden',
      })),
      transition('open <=> closed', [
        animate('0.8s ease-in-out')
      ]),
    ]),
    trigger('showFilter', [
      state('open', style({
        width: '398px',
        opacity: 1,
        visibility: 'visible'
      })),
      state('closed', style({
        width: 0,
        opacity: 0,
        visibility: 'hidden'
      })),
      transition('open <=> closed', [
        animate('0.6s ease-in-out')
      ]),
    ]),
  ],
})
export class OrganizationsComponent implements OnInit {
  @ViewChild('autoShownModal', { static: false }) autoShownModal: any = ModalDirective;
  @ViewChild(DeleteModalComponent) private modal!: DeleteModalComponent;
  isModalShown = false;
  bool = false;
  chatOpen = false;
  professionsList = false;
  openAddOrCreate = false;


  public Editor = customBuild;
  @Input() config = {

    toolbar: ['heading', 'bold', 'italic', 'link', 'outdent','blockQuote','insertTable', 'indent', 'numberedList', 'bulletedList', 'imageUpload', 'undo', 'redo','mediaEmbed' ],
    image: {
      // Configure the available styles.
      styles: [
        'alignLeft', 'alignCenter', 'alignRight'
      ],

      // Configure the available image resize options.
      resizeOptions: [
        {
          name: 'resizeImage:original',
          label: 'Original',
          value: null
        },
        {
          name: 'resizeImage:50',
          label: '25%',
          value: '25'
        },
        {
          name: 'resizeImage:50',
          label: '50%',
          value: '50'
        },
        {
          name: 'resizeImage:75',
          label: '75%',
          value: '75'
        }
      ],

      // You need to configure the image toolbar, too, so it shows the new style
      // buttons as well as the resize buttons.
      toolbar: [
        'imageStyle:alignLeft', 'imageStyle:alignCenter', 'imageStyle:alignRight',
        '|',
        'ImageResize',
        '|',
        'imageTextAlternative'
      ]
    },
    mediaEmbed: {
      toolbar: [
        'imageStyle:alignLeft', 'imageStyle:alignCenter', 'imageStyle:alignRight',
        '|',
        'ImageResize',
        '|',
        'imageTextAlternative'
      ]
    },
    language: 'en',
  };

  files: any[] = [];
  languageCollapse = {};
  boolStaff = false;
  openAddOrCreateStaff = false;
  chatOpenStaff = false;
  itemListCategory: any;
  settingsCategory = {};
  @ViewChild(ReportModalComponent) private reportModal!: ReportModalComponent;
  form:any =FormGroup;
  showFilter = false;
  language: any;
  country: any;
  data: any;
  allPageData: any;
  url: string = '';
  urlCategory: string = '';
  viewData: any;
  objectKeys = Object.keys;
  languageTranslations: any;
  pageType: any;
  id: any;
  imageValue: any;
  editImagePath: any;
  imagePath: any;
  image: any;
  file: any;
  type:boolean = false;
  staffView:boolean = false;
  static instance: OrganizationsComponent;
  dateRangeFilter: string = '';
  sortingValue: any = {};
  wordCount: any= {};
  letterCount: any= {};

  constructor(public helperService: HelperService,
              public activateRoute: ActivatedRoute,
              public requestService: RequestService,
              private fb: FormBuilder,
              private toastr: ToastrService,
              private location: LocationStrategy) {
    OrganizationsComponent.instance = this;
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];

    // history.pushState(null,  window.location.href);
    // this.location.onPopState(() => {
    //   history.pushState(null,  window.location.href);
    //   this.close();
    // });
  }

  ngOnInit(): void {
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.organization.get}`;
    this.urlCategory = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.organization.getCategoryList}`;
    this.requestService.getData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.organization.getAllCategoryList}`).subscribe((res) => {
      this.itemListCategory = [];
      for (let i in res) {
        this.itemListCategory.push(
          {"id": +i, "itemName": res[i]},
        )
      }
    });

    setTimeout(() => {
      this.settingsCategory = {
        text:this.helperService.translation?.select_category,
        selectAllText:'Select All',
        unSelectAllText:'UnSelect All',
        enableSearchFilter: true,
        classes:"myclass custom-class",
        showCheckbox: true,
        singleSelection: true,
        autoPosition: false,
      };
    },0);
    this.getData(this.url);
    this.formGet();
  }

  onChangeEditor( { editor }: ChangeEvent, lang, ) {
    if (editor != undefined) {
      this.wordCount[lang] = this.helperService._getWords(editor.model.document.getRoot());
      this.letterCount[lang] = this.helperService._getCharacters(editor.model.document.getRoot());
    }
  }


  formGet() {
    this.form = this.fb.group({
      image: ['', Validators.required],
      latitudeAndLongitude: ['', Validators.compose([Validators.required,Validators.minLength(7), Validators.pattern(/^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?),\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$/)])],
      email: ['', Validators.compose([Validators.required, Validators.pattern(/^([\+0-9]{9,15})|([A-Za-z0-9._%\+\-]+@[a-z0-9.\-]+\.[a-z]{2,3})$/)])],
      creation_date: [''],
      instagram: [''],
      facebook: [''],
      phone: ['', Validators.compose([Validators.pattern(/^\+?([0-9]{8,})$/)])],
      emergency_service_category: ['', Validators.required],
      web_address: [''],
      is_send_sms: [false],
      password: ['', Validators.required],
      confirm_password: ['', Validators.required],
      translations: this.fb.group({}),
    },{validator: this.helperService.matchingPasswords('password', 'confirm_password')});
    // this.form.reset();
  }

  getData(url) {
    this.requestService.getData(url).subscribe((res) => {
      this.data = res['data'] ? res['data'] : res;
      this.allPageData = res;
    })
  }

  getById(id) {
    this.id = id;
    this.pageType = 'edit';
    this.bool = false;
    this.formGet();
    this.form.controls.image.clearValidators();
    this.form.controls.password.clearValidators();
    this.form.controls.confirm_password.clearValidators();
    this.form.updateValueAndValidity();


    this.requestService.getData(this.url + '/' + id).subscribe((res:any) => {
      this.editImagePath = res?.image?.url;
      this.type = true;
      this.imageValue = undefined;
      this.getLanguageList(res['translations']);
      let inst;
      let fb;
      for (let i = 0; i < res.social_links.length; i++) {
        if (res.social_links[i].name == 'facebook') {
          fb = res.social_links[i].url
        } else if (res.social_links[i].name == 'instagram') {
          inst = res.social_links[i].url
        }
      }

      this.form.patchValue({
        latitudeAndLongitude: `${res.latitude}, ${res.longitude}`,
        email: res.email,
        creation_date: res.creation_date,
        facebook: fb,
        instagram: inst,
        phone: res.phone,
        web_address: res.web_address,
        is_send_sms: res.is_send_sms,
        emergency_service_category: [{id : res.category.id, itemName: res.category.translation}],
      })
      if (res.is_send_sms == 1) {
        this.form.controls.phone.setValidators([Validators.required,Validators.pattern(/^\+?([0-9]{8,})$/)]);
        this.form.updateValueAndValidity();
      } else {
        this.form.controls.phone.clearValidators();
        this.form.updateValueAndValidity();
        this.form.controls.phone.setValidators(Validators.pattern(/^\+?([0-9]{8,})$/));
      }
    })
  }

  changePhoneValidators() {
    if (this.form.value.is_send_sms) {
      this.form.controls.phone.setValidators([Validators.required,Validators.pattern(/^\+?([0-9]{8,})$/)]);
      this.form.controls.phone.updateValueAndValidity();
    } else {
      this.form.controls.phone.clearValidators();
      this.form.updateValueAndValidity();
      this.form.controls.phone.setValidators(Validators.pattern(/^\+?([0-9]{8,})$/));
      if (this.form.get('phone').invalid) {
        this.form.get('phone').reset();
      }
    }
  }

  createOrganization() {
    this.pageType = 'create';
    this.id = undefined;
    this.bool = false;
    this.openAddOrCreate = true;
    this.showFilter = false;
    this.getLanguageList();
    this.formGet();
  }

  getLanguageList (value?) {
    this.requestService.getData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.getLanguageList}`).subscribe((item: any) => {
      let data = item;
      this.languageTranslations = item;
      let translations = this.form.get('translations') as FormGroup;
      for (let i = 0; i < data.length; i++) {
        let a = {
          title: [(value && value[i] && value[i].language.code == data[i]['code']) ? value[i].title : '', Validators.compose([Validators.required, Validators.minLength(2)])],
          short_title: [(value && value[i] && value[i].language.code == data[i]['code']) ? value[i].short_title : ''],
          description: [(value && value[i] && value[i].language.code == data[i]['code']) ? value[i].description : '', Validators.compose([Validators.required])],
          city: [(value && value[i] && value[i].language.code == data[i]['code']) ? value[i].city : ''],
          address: [(value && value[i] && value[i].language.code == data[i]['code']) ? value[i].address : ''],
        };
        translations.setControl(data[i]['code'], this.fb.group(a));
        this.openAddOrCreate = true;
      }
    }, (error) => {

    })
  }

  close() {
    this.wordCount = {};
    this.letterCount = {};
    this.staffView = false;
    this.openAddOrCreate = false;
    this.openAddOrCreateStaff = false;
    this.chatOpen = false;
    this.chatOpenStaff = false;
    this.bool = false;
    this.boolStaff = false;
    this.professionsList = false;
    this.file = undefined;
    this.imageValue = undefined;
    this.editImagePath = undefined;
    this.type = false;
    this.form.reset();
  }



  onSubmit(form, status) {
    if (this.form.valid) {
      let url = this.id ? this.url + '/' + this.id : this.url;
      this.form.value.age_restricted = this.form.value.age_restricted ? '1' : '0';
      let formData = new FormData();
      if (form.creation_date) {
        let convertedStartDate = new Date(form.creation_date);
        let month = (+convertedStartDate.getMonth() + 1) < 10 ? '0' + (convertedStartDate.getMonth() + 1) : convertedStartDate.getMonth() + 1;
        let day = (+convertedStartDate.getDate()) < 10 ? '0' + (convertedStartDate.getDate()) : convertedStartDate.getDate();
        let year = convertedStartDate.getFullYear();
        let shortStartDate = day  + "/" + month + "/" + year;
        formData.append('creation_date', shortStartDate);
      }
      for (let key in form) {
        if (key == 'image') {
          if (this.form.value['image']) {
            formData.append(key, this.file);
          }
        } else if (key == 'translations') {
          for (let item in form['translations']) {
            for (let res in form['translations'][item]) {
              if (form['translations'][item][res] != '' && form['translations'][item][res] != null) {
                formData.append(`translations[${item}][${res}]`, form['translations'][item][res]);
              }
            }
          }
        }
      }
      formData.append('status', status);
      formData.append('is_send_sms', form.is_send_sms ? '1' : '0');
      formData.append('latitude', form.latitudeAndLongitude.split(',')[0].trim());
      formData.append('longitude', form.latitudeAndLongitude.split(',')[1].trim());
      formData.append('email', form.email);
      formData.append('phone', form.phone ? form.phone : '');

      formData.append('emergency_service_category', form.emergency_service_category[0] ? form.emergency_service_category[0]?.id : '');
      if (form.web_address) {
        formData.append('web_address', form.web_address);
      }
      if (form.facebook) {
        formData.append('social_links[0][name]', "facebook");
        formData.append('social_links[0][title]', "facebook");
        formData.append('social_links[0][icon]', "facebook");
        formData.append('social_links[0][url]', form.facebook);
      }
      if (form.instagram) {
        formData.append('social_links[1][name]', "instagram");
        formData.append('social_links[1][title]', "instagram");
        formData.append('social_links[1][icon]', "instagram");
        formData.append('social_links[1][url]', form.instagram);
      }
      if (form.password && form.confirm_password) {
        formData.append('password', form.password);
        formData.append('confirm_password', form.confirm_password);
      }

      if (this.id) {
        formData.append('_method', 'PUT')
      }
      this.requestService.createData(url, formData).subscribe((res) => {
        this.close();
        this.getData(this.urlConstructor());
      })
    } else {
      let showError = '';
      for (let i in this.form.controls) {
        if (this.form.controls[i].status == "INVALID") {
          if (i != 'translations') {
            showError += `${this.helperService.translation[i] + ' ' + this.helperService.translation?.is_required} \n`
          }
        }
      }

      for (let j in this.form.controls.translations.controls) {
        if (this.form.controls.translations.controls[j].status == "INVALID") {
          for (let k in this.form.controls.translations.controls[j].controls) {
            if (this.form.controls.translations.controls[j].controls[k].status == "INVALID") {
              showError += `${this.helperService.translation[k] + ` ${this.helperService.translation[j]}` + ' ' + this.helperService.translation?.is_required} \n`
            }
          }
        }
      }
      this.toastr.error(showError);
      this.form.markAllAsTouched();
    }
  }


  onChange(e) {
    if (e.target.files[0]) {
      this.file = e.target.files[0];
      const fileName = e.target.files[0].name;
      if (/\.(jpe?g|png|bmp)$/i.test(fileName)) {
        const filesize = e.target.files[0].size;
        // 15,72864 MB
        if (filesize > 15728640) {
          this.form.controls.image.setErrors({size: 'error'});
        } else {
          this.type= true;
          let reader = new FileReader();
          reader.readAsDataURL(e.target.files[0]);
          reader.onload = () => {
            this.imageValue = reader.result;
          };
          this.image = e.target.files[0];
        }
      } else {
        this.form.controls.image.setErrors({type: 'error'});
      }
    } else {
      this.editImagePath ? this.type = true : this.type = false;
      this.file = undefined;
      this.imageValue = undefined;
      this.form.controls.image.setErrors(null);
    }
  }

  onSubmitReport(form) {
  }

  closeDropdown (dropdownRef) {
    dropdownRef.closeDropdown();
  }

  log(event: boolean, index) {
    this.languageCollapse[index] = event;
  }

  closeStaff() {
    this.staffView = false;
    this.bool = false;
    this.boolStaff = false;
    this.professionsList = false;
    this.openAddOrCreateStaff = false;
    this.chatOpenStaff = false;
    this.editImagePath = undefined;
    this.imageValue = undefined;
    this.file = undefined;
    this.type = false;
  }

  closeFilter() {
    this.showFilter = false;
  }

  saveDateRange(data) {
    this.dateRangeFilter = data ? data[2] : '';
    this.allPageData.current_page = 1;
    this.getData(this.urlConstructor());
  }

  pageChanged(event) {
    this.allPageData.current_page = event.page;
    this.getData(this.urlConstructor());
  }

  deleteItem(id) {
    this.modal.modalRef.hide();
    this.requestService.delete(this.url, id).subscribe((item) => {
      this.allPageData.current_page = (this.allPageData.current_page > 1 && this.allPageData.data.length == 1) ?  this.allPageData.current_page - 1 : this.allPageData.current_page;
      this.getData(this.urlConstructor());
    })
  }

  urlConstructor() {
    let sorting =  Object.keys(this.sortingValue).length == 0 ? '' : `&sorts=${JSON.stringify(this.sortingValue)}`;
    let url = `${this.url}?page=${this.allPageData?.current_page ? this.allPageData?.current_page : 1}${encodeURI(sorting)}${this.dateRangeFilter}`;
    return url;
  }

  showViewPage (item) {
    // this.viewData = item;
    this.requestService.getViewId(item);
  }

  changeStatus(id, status) {
    let value = {status: status == 1 ? 0 : 1};
    this.requestService.updateData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.organization.changeStatus}`, value, id).subscribe((item) => {
      this.getData(this.urlConstructor());
    })
  }
  sorting(value, type?) {
    if (this.sortingValue[value]) {
      this.sortingValue[value] = this.sortingValue[value] == 'ASC' ? 'DESC' : !delete this.sortingValue[value];
    } else {
      this.sortingValue = {};
      this.sortingValue[value] = type;
    }
    if(this.sortingValue[value] == false) {
      this.sortingValue = {};
    }
    this.getData(this.urlConstructor())
  }

  viewStaff() {
    this.boolStaff = true;
    this.staffView = true;
  }

}
