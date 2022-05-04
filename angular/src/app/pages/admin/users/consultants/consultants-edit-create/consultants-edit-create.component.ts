import {Component, Input, OnInit} from '@angular/core';
import {FormBuilder, FormGroup, Validators} from "@angular/forms";
import {HelperService} from "../../../../../shared/helper.service";
import {RequestService} from "../../../../../shared/request.service";
import {ActivatedRoute} from "@angular/router";
import {environment} from "../../../../../../environments/environment.prod";
import {ToastrService} from "ngx-toastr";
import {ConsultantsComponent} from "../consultants.component";
import * as customBuild from '../../../../../shared/ckCustomBuild/build/ckeditor.js';
import {ChangeEvent} from "@ckeditor/ckeditor5-angular";


@Component({
  selector: 'app-consultants-edit-create',
  templateUrl: './consultants-edit-create.component.html',
  styleUrls: ['./consultants-edit-create.component.css']
})
export class ConsultantsEditCreateComponent implements OnInit {

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
  files: any[] = [];
  languageCollapse = {};
  itemList: any;
  maritalStatusList: any;
  maritalStatussettings: any = {};
  selectedItems: any;
  settings = {};
  form:any =FormGroup;
  language: any;
  country: any;
  static instance: ConsultantsEditCreateComponent;
  imagePath: any;
  image: any;
  imageValue: any;
  type:boolean = false;
  editImagePath: any;
  file: any;
  id: any;
  url: any;
  userData: any;
  wordCount: any;
  letterCount: any;
  maritalId: any;

  constructor(public helperService: HelperService,
              public activateRoute: ActivatedRoute,
              public requestService: RequestService,
              public fb: FormBuilder,
              private toastr: ToastrService,
              ) {
    ConsultantsEditCreateComponent.instance = this;
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
  }

  ngOnInit(): void {
    this.form = this.fb.group({
      image: ['', Validators.required],
      consultant_category_id: ['', Validators.required],
      social_links: this.fb.group({
        '0': this.fb.group({name: ['instagram'], url: [''], icon: ['instagram'], title: ['In'] }),
        '1': this.fb.group({name: ['facebook'], url: [''], icon: ['facebook'], title: ['fb'] })
      }),
      phone: ['', Validators.compose([Validators.required, Validators.pattern(/^\+?([0-9]{8,})$/)])],
      email: ['', Validators.compose([Validators.required, Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,10}$/)])],
      first_name: ['', Validators.required],
      last_name: ['', Validators.required],
      nickname: [''],
      description: [''],
      marital_status: [''],
      is_verifying_otp: [''],
      check_police: [''],
      status: [''],
      location: [''],
      birthday: ['', Validators.required],
      password: ['', Validators.required],
      confirm_password: ['', Validators.required],
    },{validator: this.helperService.matchingPasswords('password', 'confirm_password')});

    this.form.reset();
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.consultants.get}`;
    this.itemList = [];
    this.maritalStatusList = [];
    this.selectedItems = [];
    setTimeout(() => {
      this.settings = {
        text:this.helperService.translation?.select_profession,
        selectAllText:'Select All',
        unSelectAllText:'UnSelect All',
        enableSearchFilter: true,
        classes:"myclass custom-class",
        showCheckbox: true,
        singleSelection: true,
        autoPosition: false
      };
      this.maritalStatussettings = {
        text: this.helperService.translation?.select_status,
        selectAllText:'Select All',
        unSelectAllText:'UnSelect All',
        enableSearchFilter: true,
        classes:"myclass custom-class",
        showCheckbox: true,
        singleSelection: true,
        autoPosition: false
      };
    },0);
    this.getProfessionList();
    this.getMaritalStatus();
  }

  closeDropdown(dropdownRef) {
    dropdownRef.closeDropdown();
  }


  close() {
    this.id = undefined;
    this.userData = undefined;
    this.editImagePath = undefined;
    this.imageValue = undefined;
    this.file = undefined;
    this.type = false;
    this.form.reset();
  }

  onChangeEditor( { editor }: ChangeEvent ) {
    if (editor != undefined) {
      this.wordCount = this.helperService._getWords(editor.model.document.getRoot());
      this.letterCount = this.helperService._getCharacters(editor.model.document.getRoot());
    }
  }

  getDataById(id) {
    this.id = id;
    this.form.controls.image.clearValidators();
    this.form.controls.password.clearValidators();
    this.form.controls.confirm_password.clearValidators();
    this.form.updateValueAndValidity();

    this.requestService.getData(this.url + '/' + this.id).subscribe((res) => {
      this.userData = res[0];
      this.imageValue = undefined;
      let maritalname;
      for(let i = 0; i < this.maritalStatusList.length; i++) {
        this.maritalId = this.maritalStatusList[i]?.id;
        maritalname = this.maritalStatusList[i]?.itemName;
      }

      let inst;
      let fb;
      for (let i = 0; i < res[0].social_links.length; i++) {
        if (res[0].social_links[i].name == 'facebook') {
          fb = res[0].social_links[i].url
        } else if (res[0].social_links[i].name == 'instagram') {
          inst = res[0].social_links[i].url
        }
      }

      this.form.patchValue({
        first_name: this.userData.first_name,
        last_name: this.userData.last_name,
        phone: this.userData.phone,
        nickname: this.userData.nickname,
        social_links: {
          '0': {url: inst},
          '1': {url: fb},
        },
        birthday: this.userData.birthday,
        location: this.userData.location,
        description: this.userData?.description,
        email: this.userData.email,
        marital_status: [{id: this.maritalId, itemName: maritalname}],
        is_verifying_otp: this.userData.is_verifying_otp,
        check_police: this.userData.check_police,
        consultant_category_id: [{id: this.userData.consultant_category_id, itemName: this.userData.consultant_category.translation}]
      });
      this.type = true;
      this.editImagePath = this.userData.image.url;
    })
  }

  onSubmit(status?) {
    if(this.form.valid) {
      this.form.value.status = status;
      this.form.value.is_verifying_otp = this.form.value.is_verifying_otp ? 1 : 0;
      this.form.value.check_police = this.form.value.check_police ? 1 : 0;
      let url = this.id ? this.url + '/' + this.id : this.url;
      let convertedStartDate = new Date(this.form.value.birthday);
      let month = (+convertedStartDate.getMonth() + 1) < 10 ? '0' + (convertedStartDate.getMonth() + 1) : convertedStartDate.getMonth() + 1;
      let day = (+convertedStartDate.getDate()) < 10 ? '0' + (convertedStartDate.getDate()) : convertedStartDate.getDate();
      let year = convertedStartDate.getFullYear();
      let shortStartDate = day  + "/" + month + "/" + year;
      let formData = new FormData();
      for (let it in this.form.value) {
        if (this.form.value[it] instanceof Array) {
          this.form.value[it][0] && this.form.value[it][0].id ? formData.append(it, this.form.value[it][0].id) : null;
        } else if (it == 'social_links') {
          for (let key in this.form.value[it]) {
            formData.append(`social_links[${key}][name]`, key == '0' ? 'instagram' : 'facebook');
            formData.append(`social_links[${key}][title]`, key == '0' ? 'In' : 'fb');
            formData.append(`social_links[${key}][url]`, this.form.value[it][key]['url'] ? this.form.value[it][key]['url'] : '');
            formData.append(`social_links[${key}][icon]`, key == '0' ? 'instagram' : 'facebook');
          }
        } else {
          if (this.form.value[it] && it != 'birthday') {
            formData.append(it, this.form.value[it]);
          }
        }
      }
      formData.append('birthday', shortStartDate);
      formData.append('location', this.form.value.location ? this.form.value.location : '');
      if (this.form.value.password && this.form.value.confirm_password) {
        formData.append('password', this.form.value.password);
        formData.append('confirm_password', this.form.value.confirm_password);
      } else {
        formData.delete('password');
        formData.delete('confirm_password');
      }
      if (this.file) {
        formData.append('image', this.file);
      } else {
        formData.delete('image')
      }
      if (this.id) {
        formData.append('_method', 'PUT')
      }
      this.requestService.createData(url, formData).subscribe((res) => {
        this.close();
        ConsultantsComponent.instance.getData(ConsultantsComponent.instance.urlConstructor());
        ConsultantsComponent.instance.close('openAddOrCreate')
      });
    } else {
      let showError = '';
      for (let i in this.form.controls) {
        if (this.form.controls[i].status == "INVALID") {
          showError += `${this.helperService.translation[i] + ' ' + this.helperService.translation?.is_required} \n`
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

  log(event: boolean, index) {
    this.languageCollapse[index] = event;
  }

  getProfessionList() {
    this.requestService.getData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.consultants.getProfessionList}/list`).subscribe((items) => {
      let arr = [] as any;
      for (let i in items) {
        arr.push({
          id: i,
          itemName: items[i]
        })
      }
      this.itemList = [...arr];
    })
  }

  getMaritalStatus() {
    this.requestService.getData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.consultants.getMaritalStatusList}`).subscribe((item: any) => {
      let list = [] as any;
      for(let i in item) {
        list.push({
          id: item[i].type,
          itemName: item[i].label
        })
      }
      this.maritalStatusList= [...list];
    })
  }

}
