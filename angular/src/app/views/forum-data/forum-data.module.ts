import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import {ModalModule, PaginationModule} from "ngx-bootstrap";
import {ReactiveFormsModule} from "@angular/forms";
import {SharedModule} from "../error/shared.module";
import {ForumDataComponent} from "./forum-data.component";
import {ForumDataRoutingModule} from "./forum-data-routing.module";

@NgModule({
  declarations: [ForumDataComponent],
  imports: [
    CommonModule,
    ForumDataRoutingModule,
    ModalModule.forRoot(),
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    SharedModule,
    PaginationModule.forRoot()
  ]
})
export class ForumDataModule { }
