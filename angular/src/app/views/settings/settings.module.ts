import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {ReactiveFormsModule} from '@angular/forms';
import {BsDatepickerModule, ModalModule, PaginationModule} from 'ngx-bootstrap';
import {SharedModule} from '../error/shared.module';
import {SettingsRoutingModule} from "./settings-routing.module";
import {SettingsComponent} from "./settings.component";

@NgModule({
  declarations: [SettingsComponent],
  imports: [
    CommonModule,
    SettingsRoutingModule,
    ModalModule.forRoot(),
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    SharedModule,
    PaginationModule.forRoot(),
    BsDatepickerModule.forRoot()
  ]
})
export class SettingsModule { }
