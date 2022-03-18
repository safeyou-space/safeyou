import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { CommunicationRoutingModule } from './communication-routing.module';
import { CommunicationComponent } from './communication.component';
import {SharedModule} from "../../../components/shared.module";
import {ReactiveFormsModule} from "@angular/forms";
import {ModalModule} from "ngx-bootstrap/modal";
import {AngularMultiSelectModule} from "angular2-multiselect-dropdown";
import { RecivedDirective } from 'src/app/shared/Directives/recived.directive';
import { TooltipModule } from 'ngx-bootstrap/tooltip';


@NgModule({
  declarations: [
    CommunicationComponent,
    RecivedDirective
  ],
  imports: [
    CommonModule,
    CommunicationRoutingModule,
    SharedModule,
    ReactiveFormsModule,
    ModalModule.forRoot(),
    AngularMultiSelectModule,
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    TooltipModule.forRoot(),
  ]
})
export class CommunicationModule { }
