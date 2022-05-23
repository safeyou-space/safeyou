import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { SmsRoutingModule } from './sms-routing.module';
import { SmsComponent } from './sms.component';
import {SharedModule} from "../../../components/shared.module";
import {BsDropdownModule} from "ngx-bootstrap/dropdown";
import {TooltipModule} from "ngx-bootstrap/tooltip";
import { SmsViewComponent } from './sms-view/sms-view.component';
import {ModalModule} from "ngx-bootstrap/modal";
import {FormsModule, ReactiveFormsModule} from "@angular/forms";
import {PaginationModule} from "ngx-bootstrap/pagination";


@NgModule({
  declarations: [
    SmsComponent,
    SmsViewComponent
  ],
  imports: [
    CommonModule,
    SmsRoutingModule,
    SharedModule,
    BsDropdownModule.forRoot(),
    TooltipModule.forRoot(),
    ModalModule.forRoot(),
    PaginationModule,
    FormsModule,
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
  ]
})
export class SmsModule { }
