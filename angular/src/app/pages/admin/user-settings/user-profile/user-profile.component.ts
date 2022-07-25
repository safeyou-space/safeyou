import {Component, Input, OnInit, ViewChild} from '@angular/core';
import {ModalDirective} from "ngx-bootstrap/modal";
import {FormBuilder, FormControl, FormGroup, Validators} from "@angular/forms";
import {HelperService} from "../../../../shared/helper.service";
import {ActivatedRoute, Router} from "@angular/router";
import {RequestService} from "../../../../shared/request.service";
import {environment} from "../../../../../environments/environment.prod";
import {ChangeEvent} from "@ckeditor/ckeditor5-angular";
import * as customBuild from '../../../../shared/ckCustomBuild/build/ckeditor.js';
import {ToastrService} from "ngx-toastr";

@Component({
  selector: 'app-user-profile',
  templateUrl: './user-profile.component.html',
  styleUrls: ['./user-profile.component.css']
})
export class UserProfileComponent implements OnInit {
  isModalShown = false;
  @ViewChild('autoShownModal', { static: false }) autoShownModal:any = ModalDirective;
  form = this.fb.group({
    current_password: ['', Validators.compose([Validators.required, Validators.minLength(8)])],
    password: ['', Validators.compose([Validators.required, Validators.minLength(8)])],
    confirm_password: ['',Validators.compose([Validators.required, Validators.minLength(8)])]
  },{validator: this.helperService.matchingPasswords('password', 'confirm_password')});
  emailForm = new FormGroup({
    email: new FormControl('', Validators.compose([Validators.required, Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,10}$/)]))
  });
  formImage = new FormGroup({
    file: new FormControl('', Validators.required)
  });
  profileForm = new FormGroup({
    first_name: new FormControl('', Validators.required),
    last_name: new FormControl('', Validators.required),
    nickname: new FormControl(''),
    birthday: new FormControl(''),
    description: new FormControl(''),
    phone: new FormControl('', Validators.compose([Validators.required, Validators.pattern(/^\+?([0-9]{8,})$/)])),
    social_links: this.fb.group({
      '0': this.fb.group({name: ['instagram'], url: [''], icon: ['instagram'], title: ['In'] }),
      '1': this.fb.group({name: ['facebook'], url: [''], icon: ['facebook'], title: ['fb'] })
    }),
  });
  language: any;
  country: any;
  data: any;
  url: string = '';
  requestType: any;

  imagePath: any;
  image: any;
  imageValue: any;
  type:boolean = false;
  editImagePath: any;
  file: any;
  access: any = ["view", "edit", "change"];

  formNgo:any =FormGroup;
  objectKeys = Object.keys;
  languageTranslations: any;
  wordCount: any;
  letterCount: any;
  settingsCategory = {};
  itemListCategory: any;
  public Editor = customBuild;
  @Input() config = {

    toolbar: ['heading', 'bold', 'italic', 'link', 'outdent','blockQuote','insertTable', 'indent', 'numberedList', 'bulletedList', 'imageUpload', 'undo', 'redo','mediaEmbed' ],
    image: {
      styles: [
        'alignLeft', 'alignCenter', 'alignRight'
      ],
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
  languageCollapse = {};
  imageValueNgo: any;
  editImagePathNgo: any;
  imageNgo: any;
  fileNgo: any;
  typeNgo: any;

  constructor(public helperService: HelperService,
              public activateRoute: ActivatedRoute,
              private router: Router,
              public fb: FormBuilder,
              public requestService: RequestService,
              private toastr: ToastrService,) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.profile.get}`
  }

  ngOnInit(): void {
    if (localStorage.getItem('access')) {
      this.access = JSON.parse(localStorage.getItem( 'access')!)['profile'] ? JSON.parse(localStorage.getItem('access')!)['profile'] : []
    }
    this.getData(this.url);

    this.requestService.getData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.organization.getAllCategoryList}`).subscribe((res) => {
      this.itemListCategory = [];
      for (let i in res) {
        this.itemListCategory.push(
          {"id": i, "itemName": res[i]},
        )
      }
    });

    this.forGet();

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
  }

  forGet() {
    this.formNgo = this.fb.group({
      image: ['', Validators.required],
      email: ['', Validators.compose([Validators.required, Validators.pattern(/^([\+0-9]{9,15})|([A-Za-z0-9._%\+\-]+@[a-z0-9.\-]+\.[a-z]{2,3})$/)])],
      creation_date: [''],
      instagram: [''],
      facebook: [''],
      phone: [''],
      emergency_service_category: ['', Validators.required],
      web_address: [''],
      is_send_sms: [false],
      private_chat: [false],
      translations: this.fb.group({}),
    });
  }

  log(event: boolean, index) {
    this.languageCollapse[index] = event;
  }

  changePhoneValidators() {
    if (this.formNgo.value.is_send_sms) {
      this.formNgo.controls.phone.setValidators([Validators.required,Validators.pattern(/^\+?([0-9]{8,})$/)]);
      this.formNgo.controls.phone.updateValueAndValidity();
    } else {
      this.formNgo.controls.phone.clearValidators();
      this.formNgo.updateValueAndValidity();
      this.formNgo.controls.phone.setValidators(Validators.pattern(/^\+?([0-9]{8,})$/));
      if (this.formNgo.get('phone').invalid) {
        this.formNgo.get('phone').reset();
      }
    }
  }


  getLanguageList (value?) {
    this.requestService.getData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.getLanguageList}`).subscribe((item: any) => {
      let data = item;
      this.languageTranslations = undefined
      this.languageTranslations = item;
      let translations = this.formNgo.get('translations') as FormGroup;
      for (let i = 0; i < data.length; i++) {
        let a = {
          title: [(value && value[i] && value[i].language.code == data[i]['code']) ? value[i].title : '', Validators.compose([Validators.required, Validators.minLength(2)])],
          short_title: [(value && value[i] && value[i].language.code == data[i]['code']) ? value[i].short_title : ''],
          description: [(value && value[i] && value[i].language.code == data[i]['code']) ? value[i].description : '', Validators.compose([Validators.required])],
          city: [(value && value[i] && value[i].language.code == data[i]['code']) ? value[i].city : ''],
          address: [(value && value[i] && value[i].language.code == data[i]['code']) ? value[i].address : ''],
        };
        translations.setControl(data[i]['code'], this.fb.group(a));
      }
    }, (error) => {

    })
  }

  onChangeEditor( { editor }: ChangeEvent ) {
    if (editor != undefined) {
      this.wordCount = this.helperService._getWords(editor.model.document.getRoot());
      this.letterCount = this.helperService._getCharacters(editor.model.document.getRoot());
    }
  }

  closeDropdown (dropdownRef) {
    dropdownRef.closeDropdown();
  }

  onChangeNgo(e) {
    if (e.target.files[0]) {
      this.fileNgo = e.target.files[0];
      const fileName = e.target.files[0].name;
      if (/\.(jpe?g|png|bmp)$/i.test(fileName)) {
        const filesize = e.target.files[0].size;
        if (filesize > 15728640) {
          this.formNgo.controls.image.setErrors({size: 'error'});
        } else {
          this.typeNgo= true;
          let reader = new FileReader();
          reader.readAsDataURL(e.target.files[0]);
          reader.onload = () => {
            this.imageValueNgo = reader.result;
          };
          this.imageNgo = e.target.files[0];
        }
      } else {
        this.formNgo.controls.image.setErrors({type: 'error'});
      }
    } else {
      this.editImagePathNgo ? this.typeNgo = true : this.typeNgo = false;
      this.fileNgo = undefined;
      this.imageValueNgo = undefined;
      this.formNgo.controls.image.setErrors(null);
    }
  }

  getData(url) {
    if (localStorage.getItem('user_id')) {
      let id = localStorage.getItem('user_id');
      this.requestService.getData(`${url}/${id}`).subscribe((items:any) => {
        this.data = items;
        this.forGet();
        let imgPath = localStorage.getItem('image');
        if (items.image && imgPath != items.image.url) {
          localStorage.setItem('image', items.image.url);
          this.helperService.userImage = items.image.url;
        }
        if (this.data.emergency_service) {
          if (this.data.emergency_service.is_send_sms == 1) {
            this.formNgo.controls.phone.setValidators([Validators.required,Validators.pattern(/^\+?([0-9]{8,})$/)]);
            this.formNgo.updateValueAndValidity();
          } else {
            this.formNgo.controls.phone.clearValidators();
            this.formNgo.updateValueAndValidity();
            this.formNgo.controls.phone.setValidators(Validators.pattern(/^\+?([0-9]{8,})$/));
          }
          this.typeNgo = true;
          this.editImagePathNgo = this.data.emergency_service?.image?.url;
          this.imageValueNgo = undefined;
          this.requestType = 'ngo';
          this.formNgo.controls.image.clearValidators();
          this.formNgo.updateValueAndValidity();
          let inst;
          let fb;
          for (let i = 0; i < this.data.emergency_service.social_links.length; i++) {
            if (this.data.emergency_service.social_links[i].name == 'facebook') {
              fb = this.data.emergency_service.social_links[i].url
            } else if (this.data.emergency_service.social_links[i].name == 'instagram') {
              inst = this.data.emergency_service.social_links[i].url
            }
          }

          this.formNgo.patchValue({
            email: this.data.emergency_service.email,
            facebook: fb,
            instagram: inst,
            phone: this.data.emergency_service.phone,
            web_address: this.data.emergency_service.web_address,
            is_send_sms: this.data.emergency_service.is_send_sms,
            private_chat: this.data.emergency_service.private_chat,
            emergency_service_category: [{id : this.data.emergency_service.category.id, itemName: this.data.emergency_service.category.translation}],
          });
          this.getLanguageList(this.data.emergency_service['translations']);
        } else {
          this.getLanguageList();
        }

      })
    } else {
      let countryCode = localStorage.getItem('countryCode') as string;
      let shortCode = localStorage.getItem('shortCode')as string;
      localStorage.clear();
      localStorage.setItem('countryCode', countryCode);
      localStorage.setItem('shortCode', shortCode);
      this.router.navigateByUrl('login');
    }
  }

  onSubmit() {
    if (this.requestType == 'password') {
      this.changePassword(this.form.value);
    } else if (this.requestType == 'email') {
      this.changeEmail(this.emailForm.value);
    } else if (this.requestType == 'profile') {
      this.changeProfile(this.profileForm.value);
    } else if (this.requestType == 'image') {
      this.changeImage();
    } else if (this.requestType == 'ngo') {
      this.ngoSubmit(this.formNgo.value);
    }
  }

  ngoSubmit(form) {
    if (this.formNgo.valid) {
      let url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.organization.profileNgo}`;
      let formData = new FormData();
      for (let key in form) {
        if (key == 'image') {
          if (this.formNgo.value['image']) {
            formData.append(key, this.fileNgo);
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
      formData.append('status', '1');
      formData.append('is_send_sms', form.is_send_sms ? '1' : '0');
      formData.append('private_chat', form.private_chat ? '1' : '0');
      formData.append('email', form.email);
      if (form.phone) {
        formData.append('phone', form.phone);
      }

      formData.append('emergency_service_category_id', form.emergency_service_category[0] ? form.emergency_service_category[0]?.id : '');
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

      formData.append('_method', 'PUT');

      this.requestService.createData(url, formData).subscribe((res) => {
        this.getData(this.url);
        this.hideModal();
      })
    } else {
      let showError = '';
      for (let i in this.formNgo.controls) {
        if (this.formNgo.controls[i].status == "INVALID") {
          if (i != 'translations') {
            showError += `${this.helperService.translation[i] + ' ' + this.helperService.translation?.is_required} \n`
          }
        }
      }

      for (let j in this.formNgo.controls.translations.controls) {
        if (this.formNgo.controls.translations.controls[j].status == "INVALID") {
          for (let k in this.formNgo.controls.translations.controls[j].controls) {
            if (this.formNgo.controls.translations.controls[j].controls[k].status == "INVALID") {
              showError += `${this.helperService.translation[k] + ` ${this.helperService.translation[j]}` + ' ' + this.helperService.translation?.is_required} \n`
            }
          }
        }
      }
      this.toastr.error(showError);
      this.formNgo.markAllAsTouched();
    }
  }

  changePassword(form) {
    if (this.form.valid) {
      let id = localStorage.getItem('user_id');
      this.requestService.createData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.profile.changePassword}/${id}`, form).subscribe(()=> {
        this.getData(this.url);
        this.hideModal();
      });
    }
  }

  changeProfile(form) {
    if (this.profileForm.valid) {
      let data = new FormData();
      for(let i in form) {
        if (i == 'social_links' && this.data.role == 'Consultant') {
          for (let key in form[i]) {
            data.append(`social_links[${key}][name]`, form[i][key]['name']);
            data.append(`social_links[${key}][title]`, form[i][key]['title']);
            data.append(`social_links[${key}][url]`, form[i][key]['url'] ? form[i][key]['url'] : '');
            data.append(`social_links[${key}][icon]`, form[i][key]['icon']);
          }
        } else {
          if (form[i] && i != 'description' && i != 'social_links') {
            data.append(i, form[i]);
          }
        }
      }
      if (form.birthday) {
        let convertedStartDate = new Date(form.birthday);
        let month = (+convertedStartDate.getMonth() + 1) < 10 ? '0' + (convertedStartDate.getMonth() + 1) : convertedStartDate.getMonth() + 1;
        let day = (+convertedStartDate.getDate()) < 10 ? '0' + (convertedStartDate.getDate()) : convertedStartDate.getDate();
        let year = convertedStartDate.getFullYear();
        let shortStartDate = day  + "/" + month + "/" + year;
        data.append('birthday', shortStartDate);
      }

      if (form.description != null) {
        data.append('description', form.description);
      }
      if (form.nickname) {
        data.append('nickname', form.nickname);
      }
      data.append('_method', 'PUT');
      let id = localStorage.getItem('user_id');
      this.requestService.createData(`${this.url}/${id}`, data).subscribe(()=> {
        this.getData(this.url);
        localStorage.setItem('first_name', form.first_name);
        localStorage.setItem('last_name', form.last_name);
        if (form.email) {
          this.helperService.userEmail = form.email;
          localStorage.setItem('email', form.email);
        }
        this.helperService.userName = form.first_name;
        this.helperService.userLastName = form.last_name;
        this.hideModal();
      });
    }
  }

  changeEmail(form) {
    if (this.emailForm.valid) {
      let data = new FormData();
      data.append('email', form.email);
      data.append('_method', 'PUT');
      let id = localStorage.getItem('user_id');
      this.requestService.createData(`${this.url}/${id}`, data).subscribe(()=> {
        localStorage.setItem('email', form.email);
        this.helperService.userEmail = form.email;
        this.getData(this.url);
        this.hideModal();
      });
    }
  }

  changeImage() {
    let formData = new FormData();
    formData.append('image', this.image);
    formData.append('_method', 'PUT');
    let id = localStorage.getItem('user_id');
    this.requestService.createData(`${this.url}/${id}`, formData).subscribe((items) => {
      this.hideModal();
      this.getData(this.url);
    })
  }

  showModal(type): void {
    if (type == 'email') {
      this.emailForm.patchValue({
        email: this.data?.email
      })
    }
    if (type == 'profile') {
      let inst;
      let fb;
      for (let i = 0; i < this.data.social_links.length; i++) {
        if (this.data.social_links[i].name == 'facebook') {
          fb = this.data.social_links[i].url
        } else if (this.data.social_links[i].name == 'instagram') {
          inst = this.data.social_links[i].url
        }
      }
      this.profileForm.patchValue({
        first_name: this.data?.first_name,
        last_name: this.data?.last_name,
        description: this.data?.role == 'Consultant' ? this.data?.description : '',
        birthday: this.data?.role == 'Consultant' ? this.data?.birthday : '',
        nickname: this.data?.nickname != null ? this.data?.nickname : '',
        phone: this.data?.phone,
        social_links: {
          '0': {url: inst},
          '1': {url: fb},
        },
      });
    }

    if (type == 'ngo') {
      this.getData(this.url);
    }
    this.requestType = type;
    this.isModalShown = true;
  }

  hideModal(): void {
    this.autoShownModal.hide();
  }

  onHidden(): void {
    this.isModalShown = false;
    this.form.reset();
    this.formNgo.reset();
  }

  onChange(e) {
    if (e.target.files[0]) {
      this.file = e.target.files[0];
      this.type= true;
      const fileName = e.target.files[0].name;
      if (/\.(jpe?g|png|bmp)$/i.test(fileName)) {
        const filesize = e.target.files[0].size;
        // 15,72864 MB
        if (filesize > 15728640) {
          this.formImage.controls.file.setErrors({size: 'error'});
        } else {
          let reader = new FileReader();
          reader.readAsDataURL(e.target.files[0]);
          reader.onload = () => {
            this.imageValue = reader.result;
          };
          this.showModal('image');
          this.image = e.target.files[0];
        }
      } else {
        this.formImage.controls.file.setErrors({type: 'error'});
      }
    } else {
      this.editImagePath ? this.type = true : this.type = false;
      this.file = undefined;
      this.imageValue = undefined;
      this.formImage.controls.file.setErrors(null);
    }
  }
}
