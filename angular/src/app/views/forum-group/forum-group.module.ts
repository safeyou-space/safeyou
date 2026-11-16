import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import {ModalModule, PaginationModule} from "ngx-bootstrap";
import {ReactiveFormsModule} from "@angular/forms";
import {SharedModule} from "../error/shared.module";
import {ForumGroupComponent} from "./forum-group.component";
import {ForumGroupRoutingModule} from "./forum-group-routing.module";

@NgModule({
  declarations: [ForumGroupComponent],
  imports: [
    CommonModule,
    ForumGroupRoutingModule,
    ModalModule.forRoot(),
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    SharedModule,
    PaginationModule.forRoot()
  ]
})
export class ForumGroupModule { }
