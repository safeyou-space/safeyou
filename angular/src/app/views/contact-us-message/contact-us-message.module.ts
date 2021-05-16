import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {ReactiveFormsModule} from '@angular/forms';
import {BsDatepickerModule, ModalModule, PaginationModule} from 'ngx-bootstrap';
import {SharedModule} from '../error/shared.module';
import {ContactUsMessageRoutingModule} from "./contact-us-message-routing.module";
import {ContactUsMessageComponent} from "./contact-us-message.component";

@NgModule({
  declarations: [ContactUsMessageComponent],
  imports: [
    CommonModule,
    ContactUsMessageRoutingModule,
    ModalModule.forRoot(),
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    SharedModule,
    PaginationModule.forRoot(),
    BsDatepickerModule.forRoot()
  ]
})
export class ContactUsMessageModule { }
