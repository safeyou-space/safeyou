import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {SharedModule} from "../../../../components/shared.module";
import {ReactiveFormsModule} from "@angular/forms";
import {SettingsComponent} from "./settings.component";
import {SettingsRoutingModule} from "./settings-routing.module";
import {TooltipModule} from "ngx-bootstrap/tooltip";
import {ModalModule} from "ngx-bootstrap/modal";
import {AngularMultiSelectModule} from "angular2-multiselect-dropdown";
import { SettingsViewComponent } from './settings-view/settings-view.component';


@NgModule({
  declarations: [
    SettingsComponent,
    SettingsViewComponent,
  ],
  imports: [
    CommonModule,
    SettingsRoutingModule,
    SharedModule,
    TooltipModule.forRoot(),
    ModalModule.forRoot(),
    AngularMultiSelectModule,
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
  ]
})
export class SettingsModule { }
