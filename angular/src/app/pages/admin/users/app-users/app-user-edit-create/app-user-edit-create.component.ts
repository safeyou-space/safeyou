import {Component, EventEmitter, OnInit, Output} from '@angular/core';
import {FormBuilder, FormGroup, Validators} from "@angular/forms";
import {RequestService} from "../../../../../shared/request.service";
import {ActivatedRoute} from "@angular/router";
import {environment} from "../../../../../../environments/environment.prod";
import {HelperService} from "../../../../../shared/helper.service";
import {ToastrService} from "ngx-toastr";
import {AppUsersComponent} from "../app-users.component";

@Component({
  selector: 'app-app-user-edit-create',
  templateUrl: './app-user-edit-create.component.html',
  styleUrls: ['./app-user-edit-create.component.css']
})
export class AppUserEditCreateComponent implements OnInit {
  url: any;
  language: any;
  country: any;
  form!:FormGroup;
  @Output() getEvent = new EventEmitter();
  imageValue: any;
  editImagePath: any;
  imagePath: any;
  image: any;
  itemList: any = [];
  settings = {};
  file: any;
  userData;
  type:boolean = false;
  id: any;
  marital_status: any;
  static instance: AppUserEditCreateComponent;

  constructor(public requestService: RequestService,
              public activateRoute: ActivatedRoute,
              public helperService: HelperService,
              public fb: FormBuilder,
              private toastr: ToastrService) {
    AppUserEditCreateComponent.instance = this;
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];

  }
  ngOnInit(): void {
    this.form = this.fb.group({
      file: ['', Validators.required],
      first_name: ['', Validators.required],
      last_name: ['', Validators.required],
      phone: ['', Validators.compose([Validators.required, Validators.pattern(/^\+?([0-9]{8,})$/)])],
      password: ['', Validators.required],
      password_confirmation: ['', Validators.required],
      location: [''],
      nickname: ['', Validators.required],
      birthday: ['', Validators.required],
      marital_status: [''],
      is_verifying_otp: [''],
      check_police: [''],
    },{validator: this.helperService.matchingPasswords('password', 'password_confirmation')});
    this.file = undefined;
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.appUsers.get}`;
    this.requestService.getData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.marital_statuses}`).subscribe((res) => {
      this.itemList = [];
      for (let i in res) {
        this.itemList.push(
          {"id": res[i].type, "itemName": res[i].label},
        )
      }
    });
    setTimeout(() => {
      this.settings = {
        text: this.helperService.translation?.select_status,
        selectAllText: 'Select All',
        unSelectAllText: 'UnSelect All',
        enableSearchFilter: true,
        classes: "myclass custom-class",
        showCheckbox: true,
        singleSelection: true,
        autoPosition: false,
      };
    },0);

  }

  getDataById(id) {
    this.id = id;
    this.form.controls.file.clearValidators();
    this.form.controls.nickname.clearValidators();
    this.form.controls.password.clearValidators();
    this.form.controls.password_confirmation.clearValidators();
    this.form.updateValueAndValidity();

    this.requestService.getData(this.url + '/' + this.id).subscribe((res) => {
      this.userData = res[0];
      this.imageValue = undefined;
      for(let i = 0; i < this.itemList.length; i++) {
        this.marital_status = [];
        if (this.userData.marital_status == this.itemList[i].itemName) {
          this.form.patchValue({
            first_name: this.userData.first_name,
            last_name: this.userData.last_name,
            phone: this.userData.phone,
            nickname: this.userData.nickname,
            birthday: this.userData.birthday,
            location: this.userData.location,
            marital_status: [{id: this.itemList[i].id, itemName: this.itemList[i].itemName}],
            is_verifying_otp: this.userData.is_verifying_otp,
            check_police: this.userData.check_police,
          });
        }
      }
      this.type = true;
      this.editImagePath = this.userData.image.url;
    })
  }

  onSubmit(status?) {
    if(this.form.valid) {
      let allUrl = this.userData.is_consultant == 1 ? `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.consultants.get}` : `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.appUsers.get}`;
      let url = this.id ? allUrl + '/' + this.id : allUrl;
      let formData = new FormData();
      if (this.form.value.birthday) {
        let convertedStartDate = new Date(this.form.value.birthday);
        let month = (+convertedStartDate.getMonth() + 1) < 10 ? '0' + (convertedStartDate.getMonth() + 1) : convertedStartDate.getMonth() + 1;
        let day = (+convertedStartDate.getDate()) < 10 ? '0' + (convertedStartDate.getDate()) : convertedStartDate.getDate();
        let year = convertedStartDate.getFullYear();
        let shortStartDate = day  + "/" + month + "/" + year;
        formData.append('birthday', shortStartDate);
      }
      formData.append('status', status);
      formData.append('first_name', this.form.value.first_name);
      formData.append('last_name', this.form.value.last_name);
      formData.append('nickname', this.form.value.nickname ? this.form.value.nickname : '');
      formData.append('phone', this.form.value.phone);
      formData.append('location', this.form.value.location ? this.form.value.location : '');
      formData.append('marital_status', this.form.value.marital_status[0] ? this.form.value.marital_status[0]?.id : '-1');
      formData.append('is_verifying_otp', this.form.value.is_verifying_otp ? '1' : '0');
      formData.append('check_police', this.form.value.check_police ? '1' : '0');
      if (this.form.value.password && this.form.value.password_confirmation) {
        formData.append('password', this.form.value.password);
        formData.append('password_confirmation', this.form.value.password_confirmation);
      }
      if (this.file) {
        formData.append('image', this.file);
      }
      if (this.id) {
        formData.append('_method', 'PUT')
      }
      if (this.userData.is_consultant == 1) {
        formData.append('email', this.userData.email);
        formData.append('consultant_category_id', this.userData.consultant_category_id);
      }
      this.requestService.createData(url, formData).subscribe((res) => {
        this.close();
        AppUsersComponent.instance.getData(AppUsersComponent.instance.urlConstructor());
        AppUsersComponent.instance.close();
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

  close() {
    this.id = undefined;
    this.userData = undefined;
    this.editImagePath = undefined;
    this.imageValue = undefined;
    this.file = undefined;
    this.type = false;
    this.form.reset();
  }

  closeDropdown(dropdownRef) {
    dropdownRef.closeDropdown();
  }

  onChange(e) {
    if (e.target.files[0]) {
      this.file = e.target.files[0];
      const fileName = e.target.files[0].name;
      if (/\.(jpe?g|png|bmp)$/i.test(fileName)) {
        const filesize = e.target.files[0].size;
        if (filesize > 15728640) {
          this.form.controls.file.setErrors({size: 'error'});
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
        this.form.controls.file.setErrors({type: 'error'});
      }
    } else {
      this.editImagePath ? this.type = true : this.type = false;
      this.file = undefined;
      this.imageValue = undefined;
      this.form.controls.file.setErrors(null);
    }
  }
}
