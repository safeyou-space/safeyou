import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {SharedModule} from "../../../components/shared.module";
import {ReactiveFormsModule} from "@angular/forms";
import {CreatingNewPasswordComponent} from "./creating-new-password.component";
import {CreatingNewPasswordRoutingModule} from "./creating-new-password-routing.module";

@NgModule({
  declarations: [CreatingNewPasswordComponent],
  imports: [
    CommonModule,
    CreatingNewPasswordRoutingModule,
    SharedModule,
    ReactiveFormsModule
  ]
})
export class CreatingNewPasswordModule { }
