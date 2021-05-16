import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {ReactiveFormsModule} from '@angular/forms';
import {BsDatepickerModule, ModalModule, PaginationModule} from 'ngx-bootstrap';
import {SharedModule} from '../error/shared.module';
import {EmergencyServiceCategoryComponent} from "./emergency-service-category.component";
import {EmergencyServiceCategoryRoutingModule} from "./emergency-service-category-routing.module";

@NgModule({
  declarations: [EmergencyServiceCategoryComponent],
  imports: [
    CommonModule,
    EmergencyServiceCategoryRoutingModule,
    ModalModule.forRoot(),
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    SharedModule,
    PaginationModule.forRoot(),
    BsDatepickerModule.forRoot()
  ]
})
export class EmergencyServiceCategoryModule { }
