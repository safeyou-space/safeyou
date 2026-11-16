import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {AdminComponent} from "./admin.component";
import { AdminRoutingModule } from "./admin-routing.module";
import {ReactiveFormsModule} from '@angular/forms';
import {ModalModule, PaginationModule} from 'ngx-bootstrap';
import {SharedModule} from '../error/shared.module';

@NgModule({
  declarations: [AdminComponent],
  imports: [
    CommonModule,
    AdminRoutingModule,
    ModalModule.forRoot(),
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    SharedModule,
    PaginationModule.forRoot(),
  ]
})
export class AdminModule { }
