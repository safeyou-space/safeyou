import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {ContentsRoutingModule} from "./contents.routing-module";
import {ReactiveFormsModule} from '@angular/forms';
import {ModalModule, PaginationModule, TabsModule} from 'ngx-bootstrap';
import {SharedModule} from '../error/shared.module';
import {ContentsComponent} from "./contents.component";
import {CKEditorModule} from "ng2-ckeditor";

@NgModule({
  declarations: [ContentsComponent],
  imports: [
    CommonModule,
    ContentsRoutingModule,
    ModalModule.forRoot(),
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    SharedModule,
    PaginationModule.forRoot(),
    TabsModule.forRoot(),
    CKEditorModule,
  ]
})
export class ContentsModule { }
