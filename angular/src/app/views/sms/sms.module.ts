import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {ReactiveFormsModule} from '@angular/forms';
import {BsDatepickerModule, ModalModule, PaginationModule} from 'ngx-bootstrap';
import {SharedModule} from '../error/shared.module';
import {SmsComponent} from "./sms.component";
import {SmsRoutingModule} from "./sms-routing.module";

@NgModule({
  declarations: [SmsComponent],
  imports: [
    CommonModule,
    SmsRoutingModule,
    ModalModule.forRoot(),
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    SharedModule,
    PaginationModule.forRoot(),
    BsDatepickerModule.forRoot()
  ]
})
export class SmsModule { }
