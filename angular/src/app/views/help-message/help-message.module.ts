import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {ReactiveFormsModule} from '@angular/forms';
import {BsDatepickerModule, ModalModule, PaginationModule} from 'ngx-bootstrap';
import {SharedModule} from '../error/shared.module';
import {HelpMessageComponent} from "./help-message.component";
import {HelpMessageRoutingModule} from "./help-message-routing.module";

@NgModule({
  declarations: [HelpMessageComponent],
  imports: [
    CommonModule,
    HelpMessageRoutingModule,
    ModalModule.forRoot(),
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    SharedModule,
    PaginationModule.forRoot(),
    BsDatepickerModule.forRoot()
  ]
})
export class HelpMessageModule { }
