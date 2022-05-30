import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { OpenSurveysRoutingModule } from './open-surveys-routing.module';
import {SharedModule} from "../../../components/shared.module";
import {ReactiveFormsModule} from "@angular/forms";
import {OpenSurveysComponent} from "./open-surveys.component";


@NgModule({
  declarations: [OpenSurveysComponent],
  imports: [
    CommonModule,
    OpenSurveysRoutingModule,
    SharedModule,
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
  ]
})
export class OpenSurveysModule { }
