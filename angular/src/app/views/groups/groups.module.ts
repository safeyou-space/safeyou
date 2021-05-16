import { NgModule } from '@angular/core';
import {GroupsRoutingModule} from "./groups-routing.module";
import {GroupsComponent} from "./groups.component";
import { CommonModule } from '@angular/common';
import {ModalModule, PaginationModule} from "ngx-bootstrap";
import {ReactiveFormsModule} from "@angular/forms";
import {SharedModule} from "../error/shared.module";


@NgModule({
  declarations: [GroupsComponent],
  imports: [
    CommonModule,
    GroupsRoutingModule,
    ModalModule.forRoot(),
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    SharedModule,
    PaginationModule.forRoot()
  ]
})
export class GroupsModule { }
