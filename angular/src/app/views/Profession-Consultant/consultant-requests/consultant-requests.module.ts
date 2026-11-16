import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {ReactiveFormsModule} from '@angular/forms';
import {BsDatepickerModule, ModalModule, PaginationModule} from 'ngx-bootstrap';
import {SharedModule} from '../../error/shared.module';
import {ConsultantRequestsRoutingModule} from "./consultant-requests-routing.module";
import {ConsultantRequestsComponent} from "./consultant-requests.component";

@NgModule({
  declarations: [ConsultantRequestsComponent],
  imports: [
    CommonModule,
    ConsultantRequestsRoutingModule,
    ModalModule.forRoot(),
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    SharedModule,
    PaginationModule.forRoot(),
    BsDatepickerModule.forRoot()
  ]
})
export class ConsultantRequestsModule { }
