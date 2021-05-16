import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {ReactiveFormsModule} from '@angular/forms';
import {BsDatepickerModule, ModalModule, PaginationModule, TabsModule} from 'ngx-bootstrap';
import {SharedModule} from '../error/shared.module';
import {EmergencyServiceComponent} from "./emergency-service.component";
import {EmergencyServiceRoutingModule} from "./emergency-service-routing.module";

@NgModule({
  declarations: [EmergencyServiceComponent],
  imports: [
    CommonModule,
    EmergencyServiceRoutingModule,
    ModalModule.forRoot(),
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    SharedModule,
    PaginationModule.forRoot(),
    BsDatepickerModule.forRoot(),
    TabsModule.forRoot()
  ]
})
export class EmergencyServiceModule { }
