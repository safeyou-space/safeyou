import { Component, OnInit } from '@angular/core';
import {FormControl, FormGroup, Validators} from "@angular/forms";
import {animate, state, style, transition, trigger} from "@angular/animations";
import {RequestService} from "../../../shared/request.service";
import {environment} from "../../../../environments/environment.prod";
import {Router} from "@angular/router";
import {HelperService} from "../../../shared/helper.service";

@Component({
  selector: 'app-forgot-password',
  templateUrl: './forgot-password.component.html',
  styleUrls: ['./forgot-password.component.css'],
  animations: [
    trigger('openClose', [
      state('openButton', style({
        opacity: '1',
        visibility: 'visible',
      })),
      state('closedButton', style({
        opacity: 0,
        visibility: 'hidden',
        height: 0,
        overflow: 'hidden'
      })),

      transition('openButton <=> closedButton', [
        animate('0.5s linear')
      ]),
    ])
    ]
})
export class ForgotPasswordComponent implements OnInit {

  forgotEmail = new FormGroup({
    email: new FormControl('', Validators.compose([Validators.required, Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,10}$/)])),
  });

  forgotPhone = new FormGroup({
    phone: new FormControl('', Validators.compose([Validators.required, Validators.pattern(/^\+?([0-9]{8,})$/)])),
  });

  show = false;

  constructor(private requestService: RequestService,
              public helperService: HelperService,
              private router: Router) { }

  ngOnInit(): void {
  }

  forgotForm() {
    if (this.forgotEmail.valid) {
      this.requestService.createData(`${environment.baseUrl}/arm/hy/${environment.admin.forgotPassword}`, this.forgotEmail.value).subscribe((data) => {
        if (data) {
          this.router.navigateByUrl(`login`);
        }
      }, error => {
      });
    } else {
      this.forgotEmail.get('email')?.markAllAsTouched();
    }
  }

  forgotPhoneForm() {
    if (this.forgotPhone.valid) {
      this.requestService.createData(`${environment.baseUrl}/arm/hy/${environment.admin.forgotPassword}`, this.forgotPhone.value).subscribe((data) => {
        if (data) {
          this.router.navigateByUrl(`login`);
        }
      }, error => {
      });
    } else {
      this.forgotEmail.get('phone')?.markAllAsTouched();
    }
  }

}
