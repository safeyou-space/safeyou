import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {FormsModule, ReactiveFormsModule} from '@angular/forms';
import {AccordionModule, BsDatepickerModule, ModalModule, PaginationModule} from 'ngx-bootstrap';
import {SharedModule} from '../../error/shared.module';
import {ConsultantsComponent} from "./consultants.component";
import {ConsultantsRoutingModule} from "./consultants-routing.module";

@NgModule({
  declarations: [ConsultantsComponent],
  imports: [
    CommonModule,
    ConsultantsRoutingModule,
    ModalModule.forRoot(),
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    FormsModule,
    SharedModule,
    BsDatepickerModule.forRoot(),
    PaginationModule.forRoot(),
    AccordionModule.forRoot(),
  ]
})
export class ConsultantsModule { }
