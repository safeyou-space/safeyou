import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {ReactiveFormsModule} from '@angular/forms';
import {GeolocationComponent} from "./geolocation.component";
import {GeolocationRoutingModule} from "./geolocation-routing.module";
import {ModalModule} from "ngx-bootstrap/modal";
import {BsDropdownModule} from "ngx-bootstrap/dropdown";

@NgModule({
  declarations: [GeolocationComponent],
  imports: [
    CommonModule,
    GeolocationRoutingModule,
    ModalModule.forRoot(),
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    BsDropdownModule.forRoot(),
  ]
})
export class GeolocationModule { }
