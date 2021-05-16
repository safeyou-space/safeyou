import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {ReactiveFormsModule} from '@angular/forms';
import {ModalModule, PaginationModule} from 'ngx-bootstrap';
import {SharedModule} from '../error/shared.module';
import {LanguagesComponent} from "./languages.component";
import {LanguagesRoutingModule} from "./languages.routing-module";

@NgModule({
  declarations: [LanguagesComponent],
  imports: [
    CommonModule,
    LanguagesRoutingModule,
    ModalModule.forRoot(),
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    SharedModule,
    PaginationModule.forRoot(),
  ]
})
export class LanguagesModule { }
