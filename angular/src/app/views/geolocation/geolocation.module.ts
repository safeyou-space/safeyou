import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {ReactiveFormsModule} from '@angular/forms';
import {BsDatepickerModule, BsDropdownModule, ModalModule, PaginationModule} from 'ngx-bootstrap';
import {SharedModule} from '../error/shared.module';
import {GeolocationComponent} from "./geolocation.component";
import {GeolocationRoutingModule} from "./geolocation-routing.module";
import {AlertModule} from "ngx-alerts";

@NgModule({
  declarations: [GeolocationComponent],
  imports: [
    CommonModule,
    GeolocationRoutingModule,
    ModalModule.forRoot(),
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    SharedModule,
    BsDropdownModule.forRoot(),
    AlertModule.forRoot({maxMessages: 5, timeout: 5000, position: 'right'}),
  ]
})
export class GeolocationModule { }
