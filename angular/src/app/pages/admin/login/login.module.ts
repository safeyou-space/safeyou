import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {SharedModule} from "../../../components/shared.module";
import {LoginComponent} from "./login.component";
import {LoginRoutingModule} from "./login-routing.module";
import {ReactiveFormsModule} from "@angular/forms";
import {AngularMultiSelectModule} from "angular2-multiselect-dropdown";

@NgModule({
  declarations: [LoginComponent],
  imports: [
    CommonModule,
    LoginRoutingModule,
    SharedModule,
    ReactiveFormsModule,
    AngularMultiSelectModule,
  ]
})
export class LoginModule { }
