import { Component, OnInit } from '@angular/core';
import {FormBuilder, FormGroup, Validators} from "@angular/forms";
import {RequestService} from "../../../shared/request.service";
import {ActivatedRoute, Router} from "@angular/router";
import {environment} from "../../../../environments/environment.prod";
import {translations} from "../../../../assets/language/translation";
import {HelperService} from "../../../shared/helper.service";

@Component({
  selector: 'app-creating-new-password',
  templateUrl: './creating-new-password.component.html',
  styleUrls: ['./creating-new-password.component.css']
})
export class CreatingNewPasswordComponent implements OnInit {

  form = this.fb.group({
    token: [''],
    email: [''],
    password: ['', Validators.compose([Validators.required, Validators.minLength(8)])],
    confirm_password: ['', Validators.compose([Validators.required, Validators.minLength(8)])]
  }, {validator: this.checkPasswords});

  constructor(private requestService: RequestService,
              private fb: FormBuilder,
              public activateRoute: ActivatedRoute,
              private router: Router,
              public helperService: HelperService) {
  }

  ngOnInit(): void {
    this.helperService.loginTranslations = translations[this.helperService.defaultLanguage];
  }

  forgotForm() {
    this.form.patchValue({
      token: this.activateRoute.snapshot.queryParams.hash,
      email: this.activateRoute.snapshot.queryParams.email
    });
    if (this.form.valid) {
      this.requestService.createData(`${environment.baseUrl}/arm/hy/${environment.admin.createPassword}`, this.form.value).subscribe((data) => {
        if (data) {
          this.router.navigateByUrl(`login`);
        }
      }, error => {
      });
    } else {
      this.form.get('password')?.markAllAsTouched();
      this.form.get('confirm_password')?.markAllAsTouched();
    }
  }

  checkPasswords(group: FormGroup) {
    let pass = group.controls.password.value;
    let confirmPass = group.controls.confirm_password.value;
    if ((pass == '' && confirmPass == null) || (confirmPass == '' && pass == null)) {
      pass = confirmPass;
    }

    return pass === confirmPass ? null : {notSame: true};

  }
}
