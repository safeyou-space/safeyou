import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { UsersComponent } from './users.component';
import {FormsModule, ReactiveFormsModule} from '@angular/forms';
import {AccordionModule, BsDatepickerModule, ModalModule, PaginationModule} from 'ngx-bootstrap';
import {UsersRoutingModule} from './users.routing-module';
import {SharedModule} from '../error/shared.module';

@NgModule({
  declarations: [UsersComponent],
  imports: [
    CommonModule,
    UsersRoutingModule,
    ModalModule.forRoot(),
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    FormsModule,
    SharedModule,
    BsDatepickerModule.forRoot(),
    PaginationModule.forRoot(),
    AccordionModule.forRoot(),
  ]
})
export class UsersModule { }
