import { Component, OnInit } from '@angular/core';
import {AlertService} from 'ngx-alerts';
import {FormBuilder, FormGroup, Validators} from '@angular/forms';
import {BsModalService} from 'ngx-bootstrap';
import {RequestService} from '../../shared/Service/request.service';
import {environment} from '../../../environments/environment.prod';
import {ActivatedRoute} from "@angular/router";

@Component({
  selector: 'app-reset-password',
  templateUrl: './reset-password.component.html',
  styleUrls: ['./reset-password.component.scss']
})
export class ResetPasswordComponent implements OnInit {

  passwordsGroup = this.fb.group({
    password: ['', Validators.compose([Validators.required, Validators.minLength(6)])],
    confirm_password: ['', Validators.compose([Validators.required, Validators.minLength(6)])],
  }, {validator: this.checkPasswords});
  url: any;
  imageValue: any;
  img: any;
  imagePath: any;
  editImagePath: any;


  form = this.fb.group({
    first_name: ['', Validators.compose([Validators.required, Validators.minLength(3)])],
    last_name: ['', Validators.compose([Validators.required, Validators.minLength(3)])],
    nickname: ['', Validators.compose([Validators.minLength(2)])],
    phone: ['', Validators.compose([Validators.required, Validators.minLength(1), Validators.pattern(this.requestService.patterns.phone)])],
    email: ['', Validators.compose([
      Validators.required,
      Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/)
    ])],
    image: [''],
    passwordsGroup: this.passwordsGroup
  });
  id: any;
  access: any = ['view', 'edit'];

  constructor(private alertService: AlertService,
              private fb: FormBuilder,
              private modalService: BsModalService,
              public activeRoute: ActivatedRoute,
              public requestService: RequestService) {
    this.requestService.activeCountryCode = this.activeRoute.snapshot.params['code'];
  }

  ngOnInit() {
    if (localStorage.getItem('access')) {
      this.access = JSON.parse(localStorage.getItem('access'))['profile'] ? JSON.parse(localStorage.getItem('access'))['profile'] : [];
    }
    this.imagePath = localStorage.getItem('image');
    this.id = localStorage.getItem('id');
    this.url = `${environment.endpoint}${this.requestService.activeCountryCode}${environment.resetPassword.get}/${this.id}`;
      this.passwordsGroup.get('password').setValidators([Validators.minLength(8)]);
      this.passwordsGroup.get('confirm_password').setValidators([Validators.minLength(8)]);
      this.passwordsGroup.updateValueAndValidity();
      this.getData(this.url);
  }

  // get auth user information
 getData (url, type?) {
    this.requestService.getData(url).subscribe((item: any) => {
      this.form.patchValue({
        first_name: item.first_name,
        last_name: item.last_name,
        email: item.email,
        nickname: item.nickname,
        phone: item.phone ? item.phone : '',
      });
      if (type) {
        localStorage.setItem('image', item.image.url);
        localStorage.setItem('first_name', item['first_name']);
        localStorage.setItem('last_name', item['last_name']);
        this.requestService.userInfo['first_name'] = item['first_name'];
        this.requestService.userInfo['last_name'] = item['last_name'];
        this.requestService.userInfo['image'] = item['image']['url'];
      }
      this.imagePath = item.image.url
    }, (error) => {
      this.requestService.StatusCode(error)
    })
 }

  // check is password and confirm password equal
  checkPasswords(group: FormGroup) {
    let pass = group.controls.password.value;
    let confirmPass = group.controls.confirm_password.value;
    return pass === confirmPass ? null : {notSame: true};
  }

  // send create or edit request
  formSubmit (form) {
    let newValue = {};
    let formData = new FormData();
    for (let key in form) {
      if (key == 'passwordsGroup') {
        if (form['passwordsGroup']['password']) {
          newValue['password'] = form['passwordsGroup']['password'];
          newValue['confirm_password'] = form['passwordsGroup']['confirm_password'];
        }
      } else {
        newValue[key] = form[key];
      }
    }

    for (let i in newValue) {
      if (newValue[i] == null) {
        newValue[i] = '';
      }
      if (i == 'image') {
        if (newValue[i]) {
          formData.append('image', this.img);
        }
      } else {
        formData.append(i, newValue[i]);
      }
    }
    formData.append('_method', 'PUT');
    this.requestService.createData(`${this.url}`, formData).subscribe((items) => {
      this.getData(this.url, true);

      this.alertService.success(items['message']);
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }

  // image validation function
  fileUpload(e) {
    if (e.target.files[0]) {
      const fileName = e.target.files[0].name;
      if (/\.(jpe?g|png|bmp)$/i.test(fileName)) {
        const filesize = e.target.files[0].size;
        if (filesize > 15728640) {
          this.imageValue = undefined;
          this.form.get('image').setErrors({size: 'Image max size 1mb'})
        } else {
          let reader = new FileReader();
          reader.readAsDataURL(e.target.files[0]);
          reader.onload = () => {
            this.imageValue = reader.result;
          };
          this.img = e.target.files[0];
          this.form.get('image').setErrors(null);
        }
      } else {
        this.imageValue = undefined;
        this.form.get('image').setErrors({type: 'pleace enter valid image'});
      }
    } else {
      this.imageValue = undefined;
      this.form.get('image').setErrors(null);
    }
  }

}
