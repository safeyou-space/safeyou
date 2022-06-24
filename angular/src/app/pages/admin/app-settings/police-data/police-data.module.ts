import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PoliceDataRoutingModule } from './police-data-routing.module';
import { PoliceDataComponent } from './police-data.component';
import {SharedModule} from "../../../../components/shared.module";
import {ReactiveFormsModule} from "@angular/forms";


@NgModule({
  declarations: [
    PoliceDataComponent
  ],
  imports: [
    CommonModule,
    PoliceDataRoutingModule,
    SharedModule,
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
  ]
})
export class PoliceDataModule { }
