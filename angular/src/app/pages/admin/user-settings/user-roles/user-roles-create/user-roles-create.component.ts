import {Component, EventEmitter, OnInit, Output} from '@angular/core';
import {RequestService} from "../../../../../shared/request.service";
import {HelperService} from "../../../../../shared/helper.service";
import {FormBuilder, FormGroup, Validators} from "@angular/forms";
import {ActivatedRoute} from "@angular/router";
import {environment} from "../../../../../../environments/environment.prod";
import {ToastrService} from "ngx-toastr";

@Component({
  selector: 'app-user-roles-create',
  templateUrl: './user-roles-create.component.html',
  styleUrls: ['./user-roles-create.component.css']
})
export class UserRolesCreateComponent implements OnInit {
  @Output() closePage = new EventEmitter();

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
  static instance: UserRolesCreateComponent;
  localId = localStorage.getItem('user_id')

  constructor(public requestService: RequestService,
              public helperService: HelperService,
              public activateRoute: ActivatedRoute,
              public fb: FormBuilder,
              private toastr: ToastrService) {
    UserRolesCreateComponent.instance = this;
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
  }

  ngOnInit(): void {
    this.url = `${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.appAdmin.get}`;

    this.requestService.getData(this.url + '/roles').subscribe((res) => {
      this.itemList = [];
      for (let i in res) {
        this.itemList.push({"id": i, "itemName": res[i]})
      }
    });


    setTimeout(() => {
      this.settings = {
        text: this.helperService.translation?.select_role,
        selectAllText: 'Select All',
        unSelectAllText: 'UnSelect All',
        enableSearchFilter: true,
        classes: "myclass custom-class",
        showCheckbox: true,
        singleSelection: true,
        autoPosition: false,
      };
    },0);
    this.forGet();
  }


  forGet() {
    this.form = this.fb.group({
      file: [null, Validators.required],
      first_name: [null, Validators.required],
      last_name: [null, Validators.required],
      email: [null,  Validators.compose([Validators.required, Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,10}$/)])],
      role: [null, Validators.required],
      phone: [null, Validators.compose([Validators.required, Validators.pattern(/^\+?([0-9]{8,})$/)])],
      password: ['', Validators.required],
      password_confirmation: ['', Validators.required]
    },{validator: this.helperService.matchingPasswords('password', 'password_confirmation')});
  }

  getDataById(id) {
    this.forGet();
    this.id = id;
    this.form.controls.file.clearValidators();
    this.form.controls.password.clearValidators();
    this.form.controls.password_confirmation.clearValidators();
    this.form.updateValueAndValidity();

    this.requestService.getData(this.url + '/' + this.id).subscribe((res) => {
      this.userData = res[0];
      this.imageValue = undefined;
      for (let i = 0; i < this.itemList.length; i++) {
        if (this.itemList[i].itemName == this.userData.role_name) {
          this.form.patchValue({
            first_name: this.userData.first_name,
            last_name: this.userData.last_name,
            email: this.userData.email,
            phone: this.userData.phone,
            role: [{id: this.itemList[i].id, itemName: this.itemList[i].itemName}]
          });
        }
      }

      this.type = true;
      this.editImagePath = this.userData.image.url;
    })
  }

  onSubmit(form, status?) {
    if(this.form.valid) {
      let url = this.id ? this.url + '/' + this.id : this.url;
      let formData = new FormData();
      formData.append('status', status);
      formData.append('first_name', form.first_name);
      formData.append('last_name', form.last_name);
      formData.append('email', form.email);
      formData.append('phone', form.phone);
      formData.append('role', form.role ? form.role[0]?.id : '');
      if (this.form.value.password != '') {
        formData.append('password', this.form.value.password);
        formData.append('password_confirmation', this.form.value.password_confirmation);
      }
      if (this.file) {
        formData.append('image', this.file);
      }
      if (this.id) {
        formData.append('_method', 'PUT')
      }
      this.requestService.createData(url, formData).subscribe((res) => {
        let id = localStorage.getItem('user_id');
        if (this.id == id && status != '0') {
          localStorage.setItem('first_name', form.first_name);
          localStorage.setItem('last_name', form.last_name);
          if (form.email) {
            this.helperService.userEmail = form.email;
            localStorage.setItem('email', form.email);
          }
          this.helperService.userName = form.first_name;
          this.helperService.userLastName = form.last_name;
        }
        this.togglePage();
        this.form.reset();
        this.getEvent.emit('getData');
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

  togglePage() {
    this.id = undefined;
    this.userData = undefined;
    this.editImagePath = undefined;
    this.imageValue = undefined;
    this.file = undefined;
    this.type = false;
    this.form.reset();
    this.closePage.emit('close')
  }

}
