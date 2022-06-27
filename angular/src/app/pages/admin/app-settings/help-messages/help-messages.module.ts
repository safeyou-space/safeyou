import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {SharedModule} from "../../../../components/shared.module";
import {FormsModule, ReactiveFormsModule} from "@angular/forms";
import {TooltipModule} from "ngx-bootstrap/tooltip";
import {ModalModule} from "ngx-bootstrap/modal";
import {HelpMessagesComponent} from "./help-messages.component";
import {HelpMessagesRoutingModule} from "./help-messages-routing.module";
import { HelpMessagesCreateEditComponent } from './help-messages-create-edit/help-messages-create-edit.component';
import {PaginationModule} from "ngx-bootstrap/pagination";
import { HelpMessagesViewComponent } from './help-messages-view/help-messages-view.component';


@NgModule({
  declarations: [
    HelpMessagesComponent,
    HelpMessagesCreateEditComponent,
    HelpMessagesViewComponent,
  ],
  imports: [
    CommonModule,
    HelpMessagesRoutingModule,
    SharedModule,
    TooltipModule.forRoot(),
    ModalModule.forRoot(),
    PaginationModule,
    FormsModule,
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
  ]
})
export class HelpMessagesModule { }
