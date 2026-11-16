import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {ReactiveFormsModule} from '@angular/forms';
import {BsDatepickerModule, ModalModule, PaginationModule} from 'ngx-bootstrap';
import {SharedModule} from '../../error/shared.module';
import {CategoryConsultantsComponent} from "./category-consultants.component";
import {CategoryConsultantsRoutingModule} from "./category-consultants-routing.module";

@NgModule({
  declarations: [CategoryConsultantsComponent],
  imports: [
    CommonModule,
    CategoryConsultantsRoutingModule,
    ModalModule.forRoot(),
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    SharedModule,
    PaginationModule.forRoot(),
    BsDatepickerModule.forRoot()
  ]
})
export class CategoryConsultantsModule { }
