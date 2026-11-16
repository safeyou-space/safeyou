import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {ModalModule, PaginationModule, TabsModule} from "ngx-bootstrap";
import {ReactiveFormsModule} from "@angular/forms";
import {SharedModule} from "../error/shared.module";
import {ForumComponent} from "./forum.component";
import {ForumRoutingModule} from "./forum.routing-module";
import {CKEditorModule} from "ng2-ckeditor";

@NgModule({
  declarations: [ForumComponent],
  imports: [
    CommonModule,
    ForumRoutingModule,
    ModalModule.forRoot(),
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    SharedModule,
    PaginationModule.forRoot(),
    TabsModule.forRoot(),
    CKEditorModule,
  ]
})
export class ForumModule { }
