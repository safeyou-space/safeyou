import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {SharedModule} from "../../../components/shared.module";
import {ForgotPasswordComponent} from "./forgot-password.component";
import {ForgotPasswordRoutingModule} from "./forgot-password-routing.module";
import {ReactiveFormsModule} from "@angular/forms";

@NgModule({
  declarations: [ForgotPasswordComponent],
  imports: [
    CommonModule,
    ForgotPasswordRoutingModule,
    SharedModule,
    ReactiveFormsModule
  ]
})
export class ForgotPasswordModule { }
