import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {ReactiveFormsModule} from '@angular/forms';
import {BsDatepickerModule, ModalModule, PaginationModule} from 'ngx-bootstrap';
import {SharedModule} from '../error/shared.module';
import {ContactReplyComponent} from "./contact-reply.component";
import {ContactReplyRoutingModule} from "./contact-reply-routing.module";

@NgModule({
  declarations: [ContactReplyComponent],
  imports: [
    CommonModule,
    ContactReplyRoutingModule,
    ModalModule.forRoot(),
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    SharedModule,
    PaginationModule.forRoot(),
    BsDatepickerModule.forRoot()
  ]
})
export class ContactReplyModule { }
